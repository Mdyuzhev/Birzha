package com.company.resourcemanager.service;

import com.company.resourcemanager.config.JwtTokenProvider;
import com.company.resourcemanager.dto.LoginRequest;
import com.company.resourcemanager.dto.LoginResponse;
import com.company.resourcemanager.dto.UserDto;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.entity.UserSession;
import com.company.resourcemanager.exception.BadRequestException;
import com.company.resourcemanager.repository.UserRepository;
import com.company.resourcemanager.repository.UserSessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final UserSessionRepository userSessionRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider tokenProvider;
    private final TotpService totpService;

    private static final int SESSION_TIMEOUT_MINUTES = 30;

    // Временное хранилище для токенов 2FA (в продакшене использовать Redis)
    private final Map<String, PendingTwoFactorAuth> pendingTwoFactorAuths = new ConcurrentHashMap<>();

    @Transactional
    public LoginResponse login(LoginRequest request) {
        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new BadRequestException("Invalid credentials"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new BadRequestException("Invalid credentials");
        }

        // Проверяем, нужна ли 2FA
        if (user.isTotpEnabled()) {
            // Генерируем временный токен
            String twoFactorToken = UUID.randomUUID().toString();

            // Сохраняем pending auth (истекает через 5 минут)
            pendingTwoFactorAuths.put(twoFactorToken, new PendingTwoFactorAuth(
                    user.getId(),
                    System.currentTimeMillis() + 5 * 60 * 1000
            ));

            // Очистка старых токенов
            cleanupExpiredTwoFactorTokens();

            return LoginResponse.builder()
                    .requiresTwoFactor(true)
                    .twoFactorToken(twoFactorToken)
                    .build();
        }

        // Check if user already has active session (only for non-admin users)
        boolean isSystemAdmin = user.hasRole(com.company.resourcemanager.entity.Role.SYSTEM_ADMIN);
        if (!isSystemAdmin) {
            userSessionRepository.findByUserId(user.getId()).ifPresent(session -> {
                // Check if session is still active (last activity within timeout)
                if (session.getLastActivity().plusMinutes(SESSION_TIMEOUT_MINUTES).isAfter(LocalDateTime.now())) {
                    throw new BadRequestException("Учетная запись занята, выберите другую");
                }
                // Session expired, remove it
                userSessionRepository.deleteByUserId(user.getId());
            });
        } else {
            // For admin, just remove old session
            userSessionRepository.deleteByUserId(user.getId());
        }
        userSessionRepository.flush();

        String token = tokenProvider.generateToken(user.getUsername(), user.getRoles());

        // Create new session
        UserSession session = UserSession.builder()
                .user(user)
                .sessionToken(token)
                .build();
        userSessionRepository.save(session);

        java.util.Set<String> roleNames = user.getRoles().stream()
                .map(Enum::name)
                .collect(java.util.stream.Collectors.toSet());

        return LoginResponse.builder()
                .token(token)
                .username(user.getUsername())
                .roles(roleNames)
                .dzoId(user.getDzo() != null ? user.getDzo().getId() : null)
                .role(roleNames.isEmpty() ? null : roleNames.iterator().next())
                .requiresTwoFactor(false)
                .build();
    }

    @Transactional(readOnly = true)
    public UserDto getCurrentUser() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new BadRequestException("User not found"));

        return UserDto.fromEntity(user);
    }

    public User getCurrentUserEntity() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new BadRequestException("User not found"));
    }

    @Transactional
    public void logout() {
        User user = getCurrentUserEntity();
        userSessionRepository.deleteByUserId(user.getId());
    }

    @Transactional
    public void updateSessionActivity(String token) {
        userSessionRepository.findBySessionToken(token).ifPresent(session -> {
            session.setLastActivity(LocalDateTime.now());
            userSessionRepository.save(session);
        });
    }

    @Transactional
    public void cleanupExpiredSessions() {
        LocalDateTime threshold = LocalDateTime.now().minusMinutes(SESSION_TIMEOUT_MINUTES);
        userSessionRepository.deleteInactiveSessions(threshold);
    }

    @Transactional
    public LoginResponse verifyTwoFactor(String twoFactorToken, String code) {
        // Проверяем pending auth
        PendingTwoFactorAuth pending = pendingTwoFactorAuths.get(twoFactorToken);

        if (pending == null) {
            throw new BadRequestException("Сессия истекла. Войдите заново.");
        }

        if (pending.expiresAt < System.currentTimeMillis()) {
            pendingTwoFactorAuths.remove(twoFactorToken);
            throw new BadRequestException("Сессия истекла. Войдите заново.");
        }

        // Получаем пользователя
        User user = userRepository.findById(pending.userId)
                .orElseThrow(() -> new BadRequestException("User not found"));

        // Проверяем TOTP код
        if (!totpService.verifyCode(user.getTotpSecret(), code)) {
            throw new BadRequestException("Неверный код. Попробуйте снова.");
        }

        // Удаляем pending auth
        pendingTwoFactorAuths.remove(twoFactorToken);

        // Check if user already has active session (only for non-admin users)
        boolean isSystemAdmin = user.hasRole(com.company.resourcemanager.entity.Role.SYSTEM_ADMIN);
        if (!isSystemAdmin) {
            userSessionRepository.findByUserId(user.getId()).ifPresent(session -> {
                if (session.getLastActivity().plusMinutes(SESSION_TIMEOUT_MINUTES).isAfter(LocalDateTime.now())) {
                    throw new BadRequestException("Учетная запись занята, выберите другую");
                }
                userSessionRepository.deleteByUserId(user.getId());
            });
        } else {
            userSessionRepository.deleteByUserId(user.getId());
        }
        userSessionRepository.flush();

        // Выдаём JWT
        String token = tokenProvider.generateToken(user.getUsername(), user.getRoles());

        // Create new session
        UserSession session = UserSession.builder()
                .user(user)
                .sessionToken(token)
                .build();
        userSessionRepository.save(session);

        java.util.Set<String> roleNames = user.getRoles().stream()
                .map(Enum::name)
                .collect(java.util.stream.Collectors.toSet());

        return LoginResponse.builder()
                .token(token)
                .username(user.getUsername())
                .roles(roleNames)
                .dzoId(user.getDzo() != null ? user.getDzo().getId() : null)
                .role(roleNames.isEmpty() ? null : roleNames.iterator().next())
                .requiresTwoFactor(false)
                .build();
    }

    private void cleanupExpiredTwoFactorTokens() {
        long now = System.currentTimeMillis();
        pendingTwoFactorAuths.entrySet().removeIf(e -> e.getValue().expiresAt < now);
    }

    // Внутренний класс для pending auth
    private record PendingTwoFactorAuth(Long userId, long expiresAt) {}
}
