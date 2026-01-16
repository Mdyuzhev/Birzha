package com.company.resourcemanager.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EmployeeResumeDTO {
    private Long id;
    private Long employeeId;
    private String employeeName;
    private String employeeEmail;
    private String position;
    private String summary;
    private List<Map<String, Object>> skills;
    private List<Map<String, Object>> experience;
    private List<Map<String, Object>> education;
    private List<Map<String, Object>> certifications;
    private List<Map<String, Object>> languages;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
