package com.company.resourcemanager.dto;

import com.company.resourcemanager.entity.ColumnDefinition;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ColumnDefinitionDto {
    private Long id;
    private String name;
    private String displayName;
    private String fieldType;
    private Long dictionaryId;
    private Integer sortOrder;
    private Boolean isRequired;

    public static ColumnDefinitionDto fromEntity(ColumnDefinition entity) {
        return ColumnDefinitionDto.builder()
                .id(entity.getId())
                .name(entity.getName())
                .displayName(entity.getDisplayName())
                .fieldType(entity.getFieldType().name())
                .dictionaryId(entity.getDictionary() != null ? entity.getDictionary().getId() : null)
                .sortOrder(entity.getSortOrder())
                .isRequired(entity.getIsRequired())
                .build();
    }
}
