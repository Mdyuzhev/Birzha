package com.company.resourcemanager.dto;

import com.company.resourcemanager.entity.Role;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AssignRoleRequest {
    private Long userId;
    private Role role;
}
