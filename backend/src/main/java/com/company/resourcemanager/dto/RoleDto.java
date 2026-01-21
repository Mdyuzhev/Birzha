package com.company.resourcemanager.dto;

import com.company.resourcemanager.entity.Role;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RoleDto {
    private String name;
    private String displayName;

    public static RoleDto from(Role role) {
        return new RoleDto(role.name(), role.getDisplayName());
    }
}
