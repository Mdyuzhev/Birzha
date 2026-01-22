package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;
import java.util.Map;

@Data
@Builder
public class ApplicationsSummaryDto {
    private long total;
    private long inProgress;
    private long completed;
    private long rejected;
    private long cancelled;
    private Map<String, Long> byStatus;
}
