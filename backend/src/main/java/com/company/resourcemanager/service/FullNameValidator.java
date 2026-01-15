package com.company.resourcemanager.service;

import com.company.resourcemanager.exception.BadRequestException;
import org.springframework.stereotype.Service;

import java.util.regex.Pattern;

@Service
public class FullNameValidator {

    // Паттерн для кириллицы: Фамилия Имя Отчество (каждое слово с заглавной буквы)
    private static final Pattern CYRILLIC_FIO_PATTERN = Pattern.compile(
            "^[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?\\s+[А-ЯЁ][а-яё]+\\s+[А-ЯЁ][а-яё]+$"
    );

    public void validate(String fullName) {
        if (fullName == null || fullName.isBlank()) {
            throw new BadRequestException("ФИО обязательно для заполнения");
        }

        String trimmed = fullName.trim();

        // Проверка на латиницу
        if (trimmed.matches(".*[A-Za-z].*")) {
            throw new BadRequestException("ФИО должно быть на кириллице");
        }

        // Проверка формата: Фамилия Имя Отчество
        String[] parts = trimmed.split("\\s+");
        if (parts.length != 3) {
            throw new BadRequestException("ФИО должно содержать три слова: Фамилия Имя Отчество");
        }

        // Проверка что каждое слово начинается с заглавной буквы кириллицы
        if (!CYRILLIC_FIO_PATTERN.matcher(trimmed).matches()) {
            throw new BadRequestException("ФИО должно быть в формате: Фамилия Имя Отчество (кириллица, каждое слово с заглавной буквы)");
        }
    }
}
