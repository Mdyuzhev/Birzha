package com.company.resourcemanager.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LockInfoDto {
    private boolean locked;
    private Long lockedById;
    private String lockedByName;
    private LocalDateTime lockedAt;
    private LocalDateTime expiresAt;
    private boolean ownLock;
}
