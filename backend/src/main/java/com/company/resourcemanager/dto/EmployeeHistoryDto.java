package com.company.resourcemanager.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
public class EmployeeHistoryDto {
    private Long id;
    private String changedBy;
    private LocalDateTime changedAt;
    private String fieldName;
    private String oldValue;
    private String newValue;
}
