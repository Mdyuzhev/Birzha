package com.company.resourcemanager.dto.workflow;

import lombok.Data;

@Data
public class AssignRecruiterRequest {
    private Long applicationId;
    private String comment;
}
