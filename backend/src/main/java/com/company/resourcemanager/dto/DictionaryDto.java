package com.company.resourcemanager.dto;

import com.company.resourcemanager.entity.Dictionary;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DictionaryDto {
    private Long id;
    private String name;
    private String displayName;
    private List<String> values;

    public static DictionaryDto fromEntity(Dictionary entity) {
        return DictionaryDto.builder()
                .id(entity.getId())
                .name(entity.getName())
                .displayName(entity.getDisplayName())
                .values(entity.getValues())
                .build();
    }
}
