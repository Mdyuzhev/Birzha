package com.company.resourcemanager.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.Map;

@Data
public class CreateEmployeeRequest {
    @NotBlank
    private String fullName;

    private String email;

    private Map<String, Object> customFields;
}
