package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class DzoDistributionDto {
    private Long dzoId;
    private String dzoName;
    private long count;
}
