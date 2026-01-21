package com.company.resourcemanager.dto.techstack;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RejectStackRequest {
    @NotBlank
    private String reason;
}
