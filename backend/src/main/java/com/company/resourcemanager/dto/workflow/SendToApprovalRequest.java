package com.company.resourcemanager.dto.workflow;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class SendToApprovalRequest {
    @NotNull
    private Long applicationId;

    private Long approverId;  // HR BP или BORUP ID (опционально, если не назначен)

    private String comment;
}
