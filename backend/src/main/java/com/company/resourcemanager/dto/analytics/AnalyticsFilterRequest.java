package com.company.resourcemanager.dto.analytics;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AnalyticsFilterRequest {
    private Long dzoId;
    private LocalDate startDate;
    private LocalDate endDate;
}
