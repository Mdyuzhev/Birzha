package com.company.resourcemanager.dto.techstack;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class TechStackDto {
    private Long id;
    private Long directionId;
    private String directionCode;
    private String directionName;
    private String code;
    private String name;
    private String description;
    private List<String> technologies;
    private String status;
    private String statusDisplayName;
    private Integer sortOrder;
    private Long createdById;
    private String createdByName;
    private LocalDateTime createdAt;
}
