package com.company.resourcemanager.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class TotpVerifyRequest {
    @NotBlank(message = "Код обязателен")
    @Pattern(regexp = "^\\d{6}$", message = "Код должен содержать 6 цифр")
    private String code;
}
