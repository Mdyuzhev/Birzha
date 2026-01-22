package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MonthlyTrendDto {
    private int year;
    private int month;
    private long created;
    private long completed;
    private long rejected;
}
