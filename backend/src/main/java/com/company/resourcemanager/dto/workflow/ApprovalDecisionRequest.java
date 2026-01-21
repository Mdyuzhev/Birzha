package com.company.resourcemanager.dto.workflow;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ApprovalDecisionRequest {
    @NotNull
    private Long applicationId;

    @NotNull
    private Boolean approved;

    @Size(max = 2000)
    private String comment;
}
