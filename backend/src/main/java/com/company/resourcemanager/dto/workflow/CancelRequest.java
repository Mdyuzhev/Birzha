package com.company.resourcemanager.dto.workflow;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CancelRequest {
    @NotNull
    private Long applicationId;

    @Size(max = 2000)
    private String reason;
}
