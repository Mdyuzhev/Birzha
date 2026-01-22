# Фаза 9: Email-уведомления — Базовая инфраструктура

**Статус:** 📋 Специфицировано
**Приоритет:** P2
**Трудозатраты:** ~8-10 часов
**Цель:** Добавить возможность отправки email из приложения

---

## Описание

Реализовать базовую инфраструктуру для отправки email-сообщений через SMTP. На этом этапе создаётся только механизм отправки. Правила уведомлений (когда и кому отправлять) будут добавлены позже.

---

## Backend

### 1. Зависимость

**Файл:** `backend/pom.xml`

Добавить в `<dependencies>`:

```xml
<!-- Email -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-mail</artifactId>
</dependency>

<!-- Thymeleaf для HTML шаблонов писем -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```

---

### 2. Конфигурация SMTP

**Файл:** `backend/src/main/resources/application.yml`

Добавить секцию:

```yaml
# Email Configuration
spring:
  mail:
    host: ${MAIL_HOST:smtp.example.com}
    port: ${MAIL_PORT:587}
    username: ${MAIL_USERNAME:}
    password: ${MAIL_PASSWORD:}
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enable: true
            required: true
          connectiontimeout: 5000
          timeout: 5000
          writetimeout: 5000
    default-encoding: UTF-8

# App mail settings
app:
  mail:
    enabled: ${MAIL_ENABLED:false}
    from: ${MAIL_FROM:noreply@example.com}
    from-name: ${MAIL_FROM_NAME:Birzha}
    base-url: ${APP_BASE_URL:http://localhost:31080}
```

**Файл:** `docker-compose.yml`

Добавить переменные окружения в backend сервис:

```yaml
backend:
  environment:
    # ... существующие переменные ...
    
    # Email
    MAIL_ENABLED: "false"
    MAIL_HOST: "smtp.example.com"
    MAIL_PORT: "587"
    MAIL_USERNAME: ""
    MAIL_PASSWORD: ""
    MAIL_FROM: "noreply@example.com"
    MAIL_FROM_NAME: "Birzha"
    APP_BASE_URL: "http://localhost:31080"
```

---

### 3. EmailProperties

**Файл:** `backend/src/main/java/com/company/resourcemanager/config/EmailProperties.java`

```java
package com.company.resourcemanager.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "app.mail")
public class EmailProperties {
    
    private boolean enabled = false;
    private String from = "noreply@example.com";
    private String fromName = "Birzha";
    private String baseUrl = "http://localhost:31080";
}
```

---

### 4. EmailService

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/EmailService.java`

```java
package com.company.resourcemanager.service;

import com.company.resourcemanager.config.EmailProperties;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.io.UnsupportedEncodingException;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailService {

    private final JavaMailSender mailSender;
    private final EmailProperties emailProperties;
    private final TemplateEngine templateEngine;

    /**
     * Отправить простое текстовое письмо
     */
    @Async
    public void sendSimpleEmail(String to, String subject, String text) {
        if (!emailProperties.isEnabled()) {
            log.info("Email disabled. Would send to: {}, subject: {}", to, subject);
            return;
        }

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(emailProperties.getFrom());
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);

            mailSender.send(message);
            log.info("Email sent to: {}, subject: {}", to, subject);
        } catch (MailException e) {
            log.error("Failed to send email to: {}, subject: {}", to, subject, e);
        }
    }

    /**
     * Отправить HTML письмо
     */
    @Async
    public void sendHtmlEmail(String to, String subject, String htmlContent) {
        if (!emailProperties.isEnabled()) {
            log.info("Email disabled. Would send HTML to: {}, subject: {}", to, subject);
            return;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(emailProperties.getFrom(), emailProperties.getFromName());
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlContent, true);

            mailSender.send(message);
            log.info("HTML email sent to: {}, subject: {}", to, subject);
        } catch (MessagingException | UnsupportedEncodingException | MailException e) {
            log.error("Failed to send HTML email to: {}, subject: {}", to, subject, e);
        }
    }

    /**
     * Отправить письмо по шаблону
     */
    @Async
    public void sendTemplateEmail(String to, String subject, String templateName, Map<String, Object> variables) {
        if (!emailProperties.isEnabled()) {
            log.info("Email disabled. Would send template '{}' to: {}, subject: {}", templateName, to, subject);
            return;
        }

        try {
            Context context = new Context();
            context.setVariables(variables);
            context.setVariable("baseUrl", emailProperties.getBaseUrl());
            
            String htmlContent = templateEngine.process("email/" + templateName, context);
            sendHtmlEmail(to, subject, htmlContent);
        } catch (Exception e) {
            log.error("Failed to process template '{}' for: {}", templateName, to, e);
        }
    }

    /**
     * Отправить нескольким получателям
     */
    @Async
    public void sendToMultiple(String[] recipients, String subject, String templateName, Map<String, Object> variables) {
        for (String to : recipients) {
            sendTemplateEmail(to, subject, templateName, variables);
        }
    }

    /**
     * Проверить подключение к SMTP
     */
    public boolean testConnection() {
        if (!emailProperties.isEnabled()) {
            log.warn("Email is disabled");
            return false;
        }

        try {
            mailSender.createMimeMessage();
            log.info("SMTP connection successful");
            return true;
        } catch (Exception e) {
            log.error("SMTP connection failed", e);
            return false;
        }
    }

    /**
     * Получить настройки (для отладки)
     */
    public EmailProperties getProperties() {
        return emailProperties;
    }
}
```

---

### 5. Async Configuration

**Файл:** `backend/src/main/java/com/company/resourcemanager/config/AsyncConfig.java`

```java
package com.company.resourcemanager.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;

@Configuration
@EnableAsync
public class AsyncConfig {
    // Включает асинхронную отправку писем через @Async
}
```

---

### 6. Шаблоны писем (Thymeleaf)

**Папка:** `backend/src/main/resources/templates/email/`

#### Базовый layout

**Файл:** `backend/src/main/resources/templates/email/layout.html`

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title th:text="${subject}">Email</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }
        .card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
            color: white;
            padding: 24px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
        }
        .content {
            padding: 24px;
        }
        .footer {
            background: #f9fafb;
            padding: 16px 24px;
            text-align: center;
            font-size: 12px;
            color: #6b7280;
            border-top: 1px solid #e5e7eb;
        }
        .button {
            display: inline-block;
            background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
            color: white !important;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 500;
            margin: 16px 0;
        }
        .button:hover {
            opacity: 0.9;
        }
        .info-row {
            display: flex;
            padding: 8px 0;
            border-bottom: 1px solid #f3f4f6;
        }
        .info-label {
            color: #6b7280;
            width: 140px;
            flex-shrink: 0;
        }
        .info-value {
            color: #111827;
            font-weight: 500;
        }
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        .status-success { background: #d1fae5; color: #065f46; }
        .status-warning { background: #fef3c7; color: #92400e; }
        .status-danger { background: #fee2e2; color: #991b1b; }
        .status-info { background: #dbeafe; color: #1e40af; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="header">
                <h1>Birzha</h1>
            </div>
            <div class="content" th:replace="${content}">
                <!-- Content will be inserted here -->
            </div>
            <div class="footer">
                <p>Это автоматическое уведомление от системы Birzha.</p>
                <p>Пожалуйста, не отвечайте на это письмо.</p>
            </div>
        </div>
    </div>
</body>
</html>
```

#### Тестовое письмо

**Файл:** `backend/src/main/resources/templates/email/test.html`

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }
        .card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
            color: white;
            padding: 24px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 24px;
        }
        .content {
            padding: 24px;
        }
        .footer {
            background: #f9fafb;
            padding: 16px 24px;
            text-align: center;
            font-size: 12px;
            color: #6b7280;
        }
        .success-icon {
            font-size: 48px;
            text-align: center;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="header">
                <h1>Birzha</h1>
            </div>
            <div class="content">
                <div class="success-icon">✅</div>
                <h2 style="text-align: center; margin-top: 0;">Тестовое письмо</h2>
                <p>Это тестовое сообщение для проверки настройки email в системе Birzha.</p>
                <p>Если вы видите это письмо — отправка почты работает корректно!</p>
                <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 20px 0;">
                <p><strong>Время отправки:</strong> <span th:text="${timestamp}">2026-01-22 12:00:00</span></p>
                <p><strong>Получатель:</strong> <span th:text="${recipient}">user@example.com</span></p>
            </div>
            <div class="footer">
                <p>Это автоматическое уведомление от системы Birzha.</p>
            </div>
        </div>
    </div>
</body>
</html>
```

#### Шаблон уведомления о заявке (заготовка)

**Файл:** `backend/src/main/resources/templates/email/application-notification.html`

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }
        .card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
            color: white;
            padding: 24px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 24px;
        }
        .content {
            padding: 24px;
        }
        .footer {
            background: #f9fafb;
            padding: 16px 24px;
            text-align: center;
            font-size: 12px;
            color: #6b7280;
        }
        .button {
            display: inline-block;
            background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
            color: white !important;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 500;
            margin: 16px 0;
        }
        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin: 16px 0;
        }
        .info-table td {
            padding: 8px 0;
            border-bottom: 1px solid #f3f4f6;
        }
        .info-table td:first-child {
            color: #6b7280;
            width: 140px;
        }
        .info-table td:last-child {
            font-weight: 500;
        }
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        .status-success { background: #d1fae5; color: #065f46; }
        .status-warning { background: #fef3c7; color: #92400e; }
        .status-danger { background: #fee2e2; color: #991b1b; }
        .status-info { background: #dbeafe; color: #1e40af; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="header">
                <h1>Birzha</h1>
            </div>
            <div class="content">
                <h2 th:text="${title}">Уведомление о заявке</h2>
                <p th:text="${message}">Текст уведомления</p>
                
                <table class="info-table" th:if="${application}">
                    <tr>
                        <td>Заявка №</td>
                        <td th:text="${application.id}">123</td>
                    </tr>
                    <tr>
                        <td>Сотрудник</td>
                        <td th:text="${application.employeeName}">Иванов Иван</td>
                    </tr>
                    <tr>
                        <td>Должность</td>
                        <td th:text="${application.targetPosition}">Senior Developer</td>
                    </tr>
                    <tr>
                        <td>Статус</td>
                        <td>
                            <span class="status-badge status-info" th:text="${application.statusDisplayName}">В работе</span>
                        </td>
                    </tr>
                </table>
                
                <p style="text-align: center;" th:if="${actionUrl}">
                    <a th:href="${actionUrl}" class="button">Открыть заявку</a>
                </p>
            </div>
            <div class="footer">
                <p>Это автоматическое уведомление от системы Birzha.</p>
                <p>Пожалуйста, не отвечайте на это письмо.</p>
            </div>
        </div>
    </div>
</body>
</html>
```

---

### 7. EmailController (для тестирования)

**Файл:** `backend/src/main/java/com/company/resourcemanager/controller/EmailController.java`

```java
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
    @PreAuthorize("hasAnyRole('SYSTEM_ADMIN', 'DZO_ADMIN')")
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
    @PreAuthorize("hasRole('SYSTEM_ADMIN')")
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
    @PreAuthorize("hasRole('SYSTEM_ADMIN')")
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
    @PreAuthorize("hasRole('SYSTEM_ADMIN')")
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
}
```

---

### 8. Thymeleaf Configuration

**Файл:** `backend/src/main/java/com/company/resourcemanager/config/ThymeleafConfig.java`

```java
package com.company.resourcemanager.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.thymeleaf.spring6.SpringTemplateEngine;
import org.thymeleaf.spring6.templateresolver.SpringResourceTemplateResolver;
import org.thymeleaf.templatemode.TemplateMode;

import java.nio.charset.StandardCharsets;

@Configuration
public class ThymeleafConfig {

    @Bean
    public SpringResourceTemplateResolver emailTemplateResolver() {
        SpringResourceTemplateResolver resolver = new SpringResourceTemplateResolver();
        resolver.setPrefix("classpath:/templates/");
        resolver.setSuffix(".html");
        resolver.setTemplateMode(TemplateMode.HTML);
        resolver.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resolver.setCacheable(false); // Для разработки, в проде включить
        resolver.setOrder(1);
        return resolver;
    }

    @Bean
    public SpringTemplateEngine templateEngine(SpringResourceTemplateResolver emailTemplateResolver) {
        SpringTemplateEngine engine = new SpringTemplateEngine();
        engine.setTemplateResolver(emailTemplateResolver);
        engine.setEnableSpringELCompiler(true);
        return engine;
    }
}
```

---

## API Endpoints

| Метод | URL | Описание | Роли |
|-------|-----|----------|------|
| GET | `/api/email/status` | Статус email-сервиса | ADMIN |
| POST | `/api/email/test-connection` | Проверить SMTP | SYSTEM_ADMIN |
| POST | `/api/email/send-test` | Отправить тестовое письмо | SYSTEM_ADMIN |
| POST | `/api/email/send-simple` | Отправить простое письмо | SYSTEM_ADMIN |

---

## Файлы для создания

| # | Файл | Действие |
|---|------|----------|
| 1 | `pom.xml` | Добавить зависимости mail и thymeleaf |
| 2 | `application.yml` | Добавить секцию mail и app.mail |
| 3 | `docker-compose.yml` | Добавить переменные MAIL_* |
| 4 | `config/EmailProperties.java` | Создать |
| 5 | `config/AsyncConfig.java` | Создать |
| 6 | `config/ThymeleafConfig.java` | Создать |
| 7 | `service/EmailService.java` | Создать |
| 8 | `controller/EmailController.java` | Создать |
| 9 | `templates/email/test.html` | Создать |
| 10 | `templates/email/application-notification.html` | Создать |

---

## Настройка SMTP (Yandex)

Используем Yandex SMTP. Переменные окружения:

```yaml
# docker-compose.yml
environment:
  MAIL_ENABLED: "true"
  MAIL_HOST: "smtp.yandex.ru"
  MAIL_PORT: "587"
  MAIL_USERNAME: "ivaaanssergeev@yandex.ru"
  MAIL_PASSWORD: "Misha2021@1@"
  MAIL_FROM: "ivaaanssergeev@yandex.ru"
  MAIL_FROM_NAME: "Birzha"
  APP_BASE_URL: "http://localhost:31080"
```

**Важно для Yandex:**
- Порт 587 с STARTTLS (или 465 с SSL)
- MAIL_FROM должен совпадать с MAIL_USERNAME
- Если не работает — нужно создать "пароль приложения" в настройках Яндекс

---

## Тестирование

1. Пересобрать backend: `docker-compose build backend`
2. Перезапустить: `docker-compose up -d`
3. Проверить статус:
   ```bash
   curl -X GET http://localhost:31081/api/email/status \
     -H "Authorization: Bearer <token>"
   ```
4. Проверить подключение (когда SMTP настроен):
   ```bash
   curl -X POST http://localhost:31081/api/email/test-connection \
     -H "Authorization: Bearer <token>"
   ```
5. Отправить тестовое письмо:
   ```bash
   curl -X POST http://localhost:31081/api/email/send-test \
     -H "Authorization: Bearer <token>" \
     -H "Content-Type: application/json" \
     -d '{"to": "test@example.com"}'
   ```

---

## Следующий шаг

После настройки SMTP нужно будет создать:
- `NotificationService` — правила когда и кому отправлять
- Таблица `notification_settings` — настройки уведомлений пользователей
- Интеграция с `ApplicationWorkflowService` — триггеры при смене статуса

Это будет отдельная задача.
