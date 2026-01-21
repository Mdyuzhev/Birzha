package com.company.resourcemanager.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum BlacklistReasonCategory {

    FRAUD("Мошенничество", "Подделка документов, обман"),
    THEFT("Кража", "Хищение имущества или данных"),
    CONFIDENTIALITY_BREACH("Разглашение информации", "Нарушение NDA, утечка данных"),
    MISCONDUCT("Грубое нарушение", "Нарушение трудовой дисциплины"),
    POOR_PERFORMANCE("Низкая эффективность", "Систематическое невыполнение обязанностей"),
    CONFLICT("Конфликтность", "Систематические конфликты с коллегами"),
    NO_SHOW("Неявка", "Не вышел на работу без уважительной причины"),
    FAKE_DOCUMENTS("Поддельные документы", "Предоставление ложных сведений"),
    CRIMINAL("Уголовное дело", "Привлечение к уголовной ответственности"),
    OTHER("Другое", "Иная причина");

    private final String displayName;
    private final String description;
}
