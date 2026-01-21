package com.company.resourcemanager.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AssignHrBpRequest {
    private Long userId;
    private Long dzoId;
}
