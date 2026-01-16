package com.company.resourcemanager.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LockRequest {

    @NotBlank(message = "Тип сущности обязателен")
    private String entityType;

    @NotNull(message = "ID сущности обязателен")
    private Long entityId;
}
