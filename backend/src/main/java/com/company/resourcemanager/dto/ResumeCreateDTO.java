package com.company.resourcemanager.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResumeCreateDTO {
    @NotNull(message = "Employee ID is required")
    private Long employeeId;

    private String position;
    private String summary;
    private List<Map<String, Object>> skills;
    private List<Map<String, Object>> experience;
    private List<Map<String, Object>> education;
    private List<Map<String, Object>> certifications;
    private List<Map<String, Object>> languages;
}
