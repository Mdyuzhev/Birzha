package com.company.resourcemanager.dto.blacklist;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class BlacklistCheckResult {
    private boolean inBlacklist;
    private List<BlacklistEntryDto> entries;
    private String message;
}
