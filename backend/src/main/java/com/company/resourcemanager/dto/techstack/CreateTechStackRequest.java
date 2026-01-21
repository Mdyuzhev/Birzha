package com.company.resourcemanager.dto.techstack;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.util.List;

@Data
public class CreateTechStackRequest {
    @NotNull
    private Long directionId;
    @NotBlank
    private String code;
    @NotBlank
    private String name;
    private String description;
    private List<String> technologies;
    private Integer sortOrder;
}
