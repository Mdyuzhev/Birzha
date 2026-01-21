package com.company.resourcemanager.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum TechStackStatus {
    PROPOSED("Предложен"),
    ACTIVE("Активен"),
    DEPRECATED("Устаревший"),
    REJECTED("Отклонён");

    private final String displayName;
}
