package com.company.resourcemanager.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreateColumnPresetRequest {

    @NotBlank(message = "Название борда обязательно")
    @Size(max = 100, message = "Название не должно превышать 100 символов")
    private String name;

    @NotNull(message = "Конфигурация колонок обязательна")
    private List<Map<String, Object>> columnConfig;

    private Boolean isDefault = false;
}
