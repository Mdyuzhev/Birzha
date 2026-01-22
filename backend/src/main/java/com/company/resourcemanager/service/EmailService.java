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
     * Отправить HTML письмо (внутренний метод, без @Async)
     */
    private void doSendHtmlEmail(String to, String subject, String htmlContent) {
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
            throw new RuntimeException("Failed to send email", e);
        }
    }

    /**
     * Отправить HTML письмо (публичный async метод)
     */
    @Async
    public void sendHtmlEmail(String to, String subject, String htmlContent) {
        if (!emailProperties.isEnabled()) {
            log.info("Email disabled. Would send HTML to: {}, subject: {}", to, subject);
            return;
        }
        doSendHtmlEmail(to, subject, htmlContent);
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
            
            // Вызываем приватный метод напрямую (без @Async)
            doSendHtmlEmail(to, subject, htmlContent);
            
        } catch (Exception e) {
            log.error("Failed to process/send template '{}' for: {}, error: {}", templateName, to, e.getMessage(), e);
        }
    }

    /**
     * Отправить нескольким получателям
     */
    @Async
    public void sendToMultiple(String[] recipients, String subject, String templateName, Map<String, Object> variables) {
        for (String to : recipients) {
            try {
                Context context = new Context();
                context.setVariables(variables);
                context.setVariable("baseUrl", emailProperties.getBaseUrl());
                
                String htmlContent = templateEngine.process("email/" + templateName, context);
                doSendHtmlEmail(to, subject, htmlContent);
            } catch (Exception e) {
                log.error("Failed to send to {}: {}", to, e.getMessage());
            }
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
