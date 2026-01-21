package com.company.resourcemanager.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class ApplicationHistoryDto {
    private Long id;
    private Long applicationId;
    private Long changedById;
    private String changedByName;
    private LocalDateTime changedAt;
    private String oldStatus;
    private String newStatus;
    private String action;
    private String comment;
}
