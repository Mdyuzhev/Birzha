package com.company.resourcemanager.entity;

public enum Role {
    SYSTEM_ADMIN("Администратор системы"),
    DZO_ADMIN("Администратор ДЗО"),
    RECRUITER("Рекрутер"),
    HR_BP("HR BP"),
    BORUP("БОРУП"),
    MANAGER("Руководитель");

    private final String displayName;

    Role(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
