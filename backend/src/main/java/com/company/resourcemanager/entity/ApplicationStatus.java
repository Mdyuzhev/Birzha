package com.company.resourcemanager.entity;

public enum ApplicationStatus {
    // Начальный статус
    DRAFT("Черновик"),
    AVAILABLE_FOR_REVIEW("Свободен для рассмотрения"),

    // Обработка рекрутером
    IN_PROGRESS("В работе"),
    INTERVIEW("На собеседовании"),

    // Согласование HR BP
    PENDING_HR_BP("Ожидает согласования HR BP"),
    APPROVED_HR_BP("Согласован HR BP"),
    REJECTED_HR_BP("Отклонён HR BP"),

    // Согласование БОРУП
    PENDING_BORUP("Ожидает согласования БОРУП"),
    APPROVED_BORUP("Согласован БОРУП"),
    REJECTED_BORUP("Отклонён БОРУП"),

    // Итоговые статусы
    PREPARING_TRANSFER("Готовится к переводу"),
    TRANSFERRED("Переведён"),
    DISMISSED("Увольнение"),
    CANCELLED("Отменена");

    private final String displayName;

    ApplicationStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public boolean isFinal() {
        return this == TRANSFERRED || this == DISMISSED || this == CANCELLED;
    }

    public boolean isRejected() {
        return this == REJECTED_HR_BP || this == REJECTED_BORUP;
    }
}
