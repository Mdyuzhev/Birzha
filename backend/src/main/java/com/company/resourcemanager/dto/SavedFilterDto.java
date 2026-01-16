package com.company.resourcemanager.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SavedFilterDto {
    private Long id;
    private String name;
    private Map<String, Object> filterConfig;
    private Boolean isGlobal;
    private Boolean isDefault;
    private Long ownerId;
    private String ownerName;
    private Boolean isOwner;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
