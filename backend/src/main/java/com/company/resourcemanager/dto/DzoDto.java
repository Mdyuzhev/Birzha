package com.company.resourcemanager.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DzoDto {
    private Long id;
    private String code;
    private String name;
    private String emailDomain;
    private Boolean isActive;
}
