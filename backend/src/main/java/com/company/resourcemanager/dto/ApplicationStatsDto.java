package com.company.resourcemanager.dto;

import lombok.Builder;
import lombok.Data;

import java.util.Map;

@Data
@Builder
public class ApplicationStatsDto {
    private Map<String, Long> byStatus;
    private Map<String, Long> byStack;
    private Long total;
    private Long inProgress;
    private Long pendingApproval;
    private Long completed;
}
