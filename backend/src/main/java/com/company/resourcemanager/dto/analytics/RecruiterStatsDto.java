package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RecruiterStatsDto {
    private Long recruiterId;
    private String recruiterName;
    private long completedCount;
    private long inProgressCount;
    private double avgDaysToComplete;
}
