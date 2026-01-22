package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class FunnelDto {
    private long created;
    private long sentToHrBp;
    private long approvedHrBp;
    private long transferred;

    private double conversionCreatedToHrBp;
    private double conversionHrBpToApproved;
    private double conversionApprovedToTransferred;
    private double overallConversion;
}
