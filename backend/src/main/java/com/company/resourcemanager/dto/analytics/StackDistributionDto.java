package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class StackDistributionDto {
    private String stack;
    private long count;
}
