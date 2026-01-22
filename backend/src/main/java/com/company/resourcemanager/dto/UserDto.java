package com.company.resourcemanager.dto;

import com.company.resourcemanager.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.stream.Collectors;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDto {
    private Long id;
    private String username;
    private String fullName;
    private Set<String> roles;
    private Long dzoId;
    private LocalDateTime createdAt;
    private String createdByUsername;

    @Deprecated
    private String role;

    public static UserDto fromEntity(User entity) {
        Set<String> roleNames = entity.getRoles().stream()
                .map(Enum::name)
                .collect(Collectors.toSet());

        return UserDto.builder()
                .id(entity.getId())
                .username(entity.getUsername())
                .fullName(entity.getFullName())
                .roles(roleNames)
                .dzoId(entity.getDzo() != null ? entity.getDzo().getId() : null)
                .role(roleNames.isEmpty() ? null : roleNames.iterator().next())
                .createdAt(entity.getCreatedAt())
                .createdByUsername(entity.getCreatedBy() != null ? entity.getCreatedBy().getUsername() : null)
                .build();
    }
}
