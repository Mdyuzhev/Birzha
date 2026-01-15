package com.company.resourcemanager.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.List;

@Data
public class CreateDictionaryRequest {
    @NotBlank(message = "Name is required")
    @Size(max = 50, message = "Name must be max 50 characters")
    private String name;

    @NotBlank(message = "Display name is required")
    @Size(max = 100, message = "Display name must be max 100 characters")
    private String displayName;

    private List<String> values;
}
