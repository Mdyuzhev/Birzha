package com.company.resourcemanager.entity;

public enum DecisionType {
    PENDING("Ожидает решения"),
    APPROVED("Согласовано"),
    REJECTED("Отклонено");

    private final String displayName;

    DecisionType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
