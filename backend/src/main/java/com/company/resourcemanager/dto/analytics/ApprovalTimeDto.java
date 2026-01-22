package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ApprovalTimeDto {
    private double avgTotalDays;
    private double avgToHrBpDays;
    private double avgHrBpDecisionDays;
    private double avgToBorupDays;
    private double avgBorupDecisionDays;
}
