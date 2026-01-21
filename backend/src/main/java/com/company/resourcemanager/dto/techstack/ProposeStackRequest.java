package com.company.resourcemanager.dto.techstack;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.util.List;

@Data
public class ProposeStackRequest {
    @NotNull
    private Long directionId;
    @NotBlank
    private String name;
    @NotBlank
    private String justification;
    private List<String> technologies;
}
