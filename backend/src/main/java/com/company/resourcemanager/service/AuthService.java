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

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final UserSessionRepository userSessionRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider tokenProvider;

    private static final int SESSION_TIMEOUT_MINUTES = 30;

    @Transactional
    public LoginResponse login(LoginRequest request) {
        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new BadRequestException("Invalid credentials"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new BadRequestException("Invalid credentials");
        }

        // Check if user already has active session (only for non-admin users)
        if (user.getRole() != User.Role.ADMIN) {
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

        String token = tokenProvider.generateToken(user.getUsername(), user.getRole().name());

        // Create new session
        UserSession session = UserSession.builder()
                .user(user)
                .sessionToken(token)
                .build();
        userSessionRepository.save(session);

        return LoginResponse.builder()
                .token(token)
                .username(user.getUsername())
                .role(user.getRole().name())
                .build();
    }

    public UserDto getCurrentUser() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new BadRequestException("User not found"));

        return UserDto.builder()
                .id(user.getId())
                .username(user.getUsername())
                .role(user.getRole().name())
                .createdAt(user.getCreatedAt())
                .build();
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
}
