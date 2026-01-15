package com.company.resourcemanager.service;

import com.company.resourcemanager.entity.ColumnDefinition;
import com.company.resourcemanager.entity.Dictionary;
import com.company.resourcemanager.exception.BadRequestException;
import com.company.resourcemanager.repository.ColumnDefinitionRepository;
import com.company.resourcemanager.repository.DictionaryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CustomFieldsValidator {

    private final ColumnDefinitionRepository columnRepository;
    private final DictionaryRepository dictionaryRepository;

    public void validate(Map<String, Object> customFields) {
        if (customFields == null || customFields.isEmpty()) {
            return;
        }

        List<ColumnDefinition> columns = columnRepository.findAllByOrderBySortOrderAsc();
        List<String> errors = new ArrayList<>();

        for (ColumnDefinition column : columns) {
            String fieldName = column.getName();
            Object value = customFields.get(fieldName);

            // Проверка обязательных полей
            if (Boolean.TRUE.equals(column.getIsRequired())) {
                if (value == null || value.toString().isBlank()) {
                    errors.add("Поле '" + column.getDisplayName() + "' обязательно для заполнения");
                    continue;
                }
            }

            // Пропускаем пустые необязательные поля
            if (value == null || value.toString().isBlank()) {
                continue;
            }

            String stringValue = value.toString();

            // Валидация SELECT полей - проверка что значение есть в справочнике
            if (column.getFieldType() == ColumnDefinition.FieldType.SELECT) {
                if (column.getDictionary() == null) {
                    errors.add("Для поля '" + column.getDisplayName() + "' не настроен справочник");
                    continue;
                }

                Dictionary dictionary = dictionaryRepository.findById(column.getDictionary().getId())
                        .orElse(null);

                if (dictionary == null || dictionary.getValues() == null) {
                    errors.add("Справочник для поля '" + column.getDisplayName() + "' не найден");
                    continue;
                }

                if (!dictionary.getValues().contains(stringValue)) {
                    errors.add("Недопустимое значение '" + stringValue + "' для поля '" +
                            column.getDisplayName() + "'. Допустимые значения: " +
                            String.join(", ", dictionary.getValues()));
                }
            }

            // Валидация NUMBER полей
            if (column.getFieldType() == ColumnDefinition.FieldType.NUMBER) {
                try {
                    Double.parseDouble(stringValue);
                } catch (NumberFormatException e) {
                    errors.add("Поле '" + column.getDisplayName() + "' должно быть числом");
                }
            }

            // Валидация DATE полей (формат YYYY-MM-DD)
            if (column.getFieldType() == ColumnDefinition.FieldType.DATE) {
                if (!stringValue.matches("\\d{4}-\\d{2}-\\d{2}")) {
                    errors.add("Поле '" + column.getDisplayName() + "' должно быть в формате YYYY-MM-DD");
                }
            }
        }

        if (!errors.isEmpty()) {
            throw new BadRequestException(String.join("; ", errors));
        }
    }
}
