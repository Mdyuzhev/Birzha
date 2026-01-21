package com.company.resourcemanager.dto.techstack;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class TechDirectionDto {
    private Long id;
    private String code;
    private String name;
    private String description;
    private String icon;
    private String color;
    private Integer sortOrder;
    private List<TechStackDto> stacks;
}
