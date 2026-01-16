package com.company.resourcemanager.dto;

import jakarta.validation.constraints.*;
import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NineBoxCreateDTO {
    @NotNull
    private Long employeeId;

    @NotNull
    @Min(1) @Max(5)
    private Integer q1Results;

    @NotNull
    @Min(1) @Max(5)
    private Integer q2Goals;

    @NotNull
    @Min(1) @Max(5)
    private Integer q3Quality;

    @NotNull
    @Min(1) @Max(5)
    private Integer q4Growth;

    @NotNull
    @Min(1) @Max(5)
    private Integer q5Leadership;

    private String comment;
}
