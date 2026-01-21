package com.company.resourcemanager.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class ApplicationFilterRequest {
    private List<String> statuses;
    private String targetStack;
    private Long recruiterId;
    private Long hrBpId;
    private String search;
    private LocalDate createdFrom;
    private LocalDate createdTo;
}
