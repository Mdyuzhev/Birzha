package com.company.resourcemanager.controller;

import com.company.resourcemanager.config.EmailProperties;
import com.company.resourcemanager.service.EmailService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/email")
@RequiredArgsConstructor
public class EmailController {

    private final EmailService emailService;

    /**
     * Получить статус email-сервиса
     */
    @GetMapping("/status")
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN')")
    public ResponseEntity<Map<String, Object>> getStatus() {
        EmailProperties props = emailService.getProperties();

        Map<String, Object> status = new HashMap<>();
        status.put("enabled", props.isEnabled());
        status.put("from", props.getFrom());
        status.put("fromName", props.getFromName());
        status.put("baseUrl", props.getBaseUrl());

        return ResponseEntity.ok(status);
    }

    /**
     * Проверить подключение к SMTP
     */
    @PostMapping("/test-connection")
    @PreAuthorize("hasAuthority('SYSTEM_ADMIN')")
    public ResponseEntity<Map<String, Object>> testConnection() {
        boolean success = emailService.testConnection();

        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", success ? "SMTP подключение успешно" : "Ошибка подключения к SMTP");

        return ResponseEntity.ok(result);
    }

    /**
     * Отправить тестовое письмо
     */
    @PostMapping("/send-test")
    @PreAuthorize("hasAuthority('SYSTEM_ADMIN')")
    public ResponseEntity<Map<String, Object>> sendTestEmail(@RequestBody Map<String, String> request) {
        String to = request.get("to");

        if (to == null || to.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Укажите email получателя в поле 'to'"
            ));
        }

        Map<String, Object> variables = new HashMap<>();
        variables.put("timestamp", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm:ss")));
        variables.put("recipient", to);

        emailService.sendTemplateEmail(to, "Тестовое письмо от Birzha", "test", variables);

        return ResponseEntity.ok(Map.of(
            "success", true,
            "message", "Тестовое письмо отправлено на " + to
        ));
    }

    /**
     * Отправить простое текстовое письмо
     */
    @PostMapping("/send-simple")
    @PreAuthorize("hasAuthority('SYSTEM_ADMIN')")
    public ResponseEntity<Map<String, Object>> sendSimpleEmail(@RequestBody Map<String, String> request) {
        String to = request.get("to");
        String subject = request.get("subject");
        String text = request.get("text");

        if (to == null || subject == null || text == null) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Укажите 'to', 'subject' и 'text'"
            ));
        }

        emailService.sendSimpleEmail(to, subject, text);

        return ResponseEntity.ok(Map.of(
            "success", true,
            "message", "Письмо отправлено"
        ));
    }

    /**
     * Отправить письмо по шаблону
     */
    @PostMapping("/send-template")
    @PreAuthorize("hasAuthority('SYSTEM_ADMIN')")
    public ResponseEntity<Map<String, Object>> sendTemplateEmail(@RequestBody Map<String, Object> request) {
        String to = (String) request.get("to");
        String subject = (String) request.get("subject");
        String templateName = (String) request.get("template");
        @SuppressWarnings("unchecked")
        Map<String, Object> variables = (Map<String, Object>) request.getOrDefault("variables", new HashMap<>());

        if (to == null || subject == null || templateName == null) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Укажите 'to', 'subject' и 'template'"
            ));
        }

        emailService.sendTemplateEmail(to, subject, templateName, variables);

        return ResponseEntity.ok(Map.of(
            "success", true,
            "message", "Письмо по шаблону '" + templateName + "' отправлено на " + to
        ));
    }
}
