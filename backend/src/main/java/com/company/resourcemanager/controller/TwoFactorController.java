package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.TotpSetupResponse;
import com.company.resourcemanager.dto.TotpVerifyRequest;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.repository.UserRepository;
import com.company.resourcemanager.service.CurrentUserService;
import com.company.resourcemanager.service.TotpService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/2fa")
@RequiredArgsConstructor
public class TwoFactorController {

    private final TotpService totpService;
    private final CurrentUserService currentUserService;
    private final UserRepository userRepository;

    /**
     * Получить статус 2FA для текущего пользователя
     */
    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> getStatus() {
        User user = currentUserService.getCurrentUser();
        return ResponseEntity.ok(Map.of(
            "enabled", user.isTotpEnabled(),
            "enabledAt", user.getTotpEnabledAt() != null ? user.getTotpEnabledAt().toString() : null
        ));
    }

    /**
     * Начать настройку 2FA — получить секрет и QR-код
     */
    @PostMapping("/setup")
    public ResponseEntity<TotpSetupResponse> setupTotp() {
        User user = currentUserService.getCurrentUser();

        // Генерируем новый секрет
        String secret = totpService.generateSecret();

        // Сохраняем секрет (но пока не включаем 2FA)
        user.setTotpSecret(secret);
        userRepository.save(user);

        // Генерируем QR-код
        String qrCodeDataUrl = totpService.generateQrCodeDataUrl(secret, user.getUsername());

        // Форматируем секрет для ручного ввода (группы по 4 символа)
        String manualKey = secret.replaceAll("(.{4})", "$1 ").trim();

        return ResponseEntity.ok(TotpSetupResponse.builder()
            .secret(secret)
            .qrCodeDataUrl(qrCodeDataUrl)
            .manualEntryKey(manualKey)
            .build());
    }

    /**
     * Подтвердить настройку 2FA — проверить код и включить
     */
    @PostMapping("/enable")
    public ResponseEntity<Map<String, Object>> enableTotp(@Valid @RequestBody TotpVerifyRequest request) {
        User user = currentUserService.getCurrentUser();

        if (user.getTotpSecret() == null) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Сначала вызовите /setup для получения секрета"
            ));
        }

        // Проверяем код
        if (!totpService.verifyCode(user.getTotpSecret(), request.getCode())) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Неверный код. Проверьте настройку приложения и попробуйте снова."
            ));
        }

        // Включаем 2FA
        user.setTotpEnabled(true);
        user.setTotpEnabledAt(LocalDateTime.now());
        userRepository.save(user);

        return ResponseEntity.ok(Map.of(
            "success", true,
            "message", "Двухфакторная аутентификация успешно включена"
        ));
    }

    /**
     * Отключить 2FA
     */
    @PostMapping("/disable")
    public ResponseEntity<Map<String, Object>> disableTotp() {
        User user = currentUserService.getCurrentUser();

        if (!user.isTotpEnabled()) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "2FA не включена"
            ));
        }

        // Отключаем 2FA
        user.setTotpEnabled(false);
        user.setTotpSecret(null);
        user.setTotpEnabledAt(null);
        userRepository.save(user);

        return ResponseEntity.ok(Map.of(
            "success", true,
            "message", "Двухфакторная аутентификация отключена"
        ));
    }
}
