package com.company.resourcemanager.dto;

import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.Set;

@Data
public class UpdateUserRequest {
    @Size(min = 6, message = "Password must be at least 6 characters")
    private String password;

    @Size(max = 255, message = "Full name must not exceed 255 characters")
    private String fullName;

    private Set<String> roles;

    private Long dzoId;
}
