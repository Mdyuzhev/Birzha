package com.company.resourcemanager.dto.blacklist;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Builder
public class BlacklistHistoryDto {
    private Long id;
    private Long blacklistEntryId;
    private Long changedById;
    private String changedByName;
    private LocalDateTime changedAt;
    private String action;
    private String comment;
}
