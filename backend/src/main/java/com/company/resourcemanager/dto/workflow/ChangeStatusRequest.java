package com.company.resourcemanager.dto.workflow;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ChangeStatusRequest {
    @NotNull
    private Long applicationId;

    @NotNull
    private String newStatus;

    private String comment;
}
