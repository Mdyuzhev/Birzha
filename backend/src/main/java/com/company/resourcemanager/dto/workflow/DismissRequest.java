package com.company.resourcemanager.dto.workflow;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class DismissRequest {
    @NotNull
    private Long applicationId;

    @NotBlank
    @Size(max = 2000)
    private String reason;
}
