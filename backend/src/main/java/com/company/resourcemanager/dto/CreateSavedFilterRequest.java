package com.company.resourcemanager.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreateSavedFilterRequest {

    @NotBlank(message = "Название фильтра обязательно")
    @Size(max = 100, message = "Название не должно превышать 100 символов")
    private String name;

    @NotNull(message = "Конфигурация фильтра обязательна")
    private Map<String, Object> filterConfig;

    private Boolean isDefault = false;

    private Boolean isGlobal = false;
}
