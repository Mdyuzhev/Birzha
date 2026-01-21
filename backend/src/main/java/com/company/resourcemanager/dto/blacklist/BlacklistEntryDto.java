package com.company.resourcemanager.dto.blacklist;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Builder
public class BlacklistEntryDto {
    private Long id;
    private Long dzoId;
    private String dzoName;
    private Long employeeId;
    private String employeeName;
    private String fullName;
    private String email;
    private String phone;
    private String reason;
    private String reasonCategory;
    private String reasonCategoryDisplayName;
    private String source;
    private Boolean isActive;
    private Long addedById;
    private String addedByName;
    private LocalDateTime addedAt;
    private LocalDateTime expiresAt;
    private Boolean isExpired;
    private Long removedById;
    private String removedByName;
    private LocalDateTime removedAt;
    private String removalReason;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
