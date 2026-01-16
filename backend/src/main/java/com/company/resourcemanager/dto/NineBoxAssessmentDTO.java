package com.company.resourcemanager.dto;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NineBoxAssessmentDTO {
    private Long id;
    private Long employeeId;
    private String employeeFullName;
    private String employeeDepartment;
    private String employeePosition;
    private Long assessedById;
    private String assessedByUsername;
    private LocalDateTime assessedAt;

    private Integer q1Results;
    private Integer q2Goals;
    private Integer q3Quality;
    private Integer q4Growth;
    private Integer q5Leadership;

    private BigDecimal performanceScore;
    private BigDecimal potentialScore;
    private Integer boxPosition;
    private String boxName;

    private String comment;

    public static String getBoxName(int position) {
        return switch (position) {
            case 1 -> "Risk";
            case 2 -> "Average Performer";
            case 3 -> "Trusted Professional";
            case 4 -> "Inconsistent Player";
            case 5 -> "Core Player";
            case 6 -> "High Performer";
            case 7 -> "Rough Diamond";
            case 8 -> "Future Star";
            case 9 -> "Star";
            default -> "Unknown";
        };
    }
}
