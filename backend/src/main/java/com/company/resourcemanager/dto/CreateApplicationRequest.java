package com.company.resourcemanager.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class CreateApplicationRequest {
    @NotNull(message = "Employee ID is required")
    private Long employeeId;

    @Size(max = 255)
    private String targetPosition;

    @Size(max = 100)
    private String targetStack;

    @DecimalMin(value = "0.0")
    private BigDecimal currentSalary;

    @DecimalMin(value = "0.0")
    private BigDecimal targetSalary;

    private String comment;

    // Опционально: сразу назначить HR BP
    private Long hrBpId;
}
