package com.company.resourcemanager.dto.workflow;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;

@Data
public class CompleteTransferRequest {
    @NotNull
    private Long applicationId;

    @NotNull
    private LocalDate transferDate;

    private String comment;
}
