package com.company.resourcemanager.dto.blacklist;

import lombok.Builder;
import lombok.Data;
import java.util.Map;

@Data
@Builder
public class BlacklistStatsDto {
    private long totalActive;
    private long totalInactive;
    private Map<String, Long> byCategory;
}
