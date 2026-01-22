package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SalaryStatsDto {
    private double avgCurrentSalary;
    private double avgTargetSalary;
    private double avgIncreasePercent;
    private double maxIncreasePercent;
    private long countRequiringBorup;
}
