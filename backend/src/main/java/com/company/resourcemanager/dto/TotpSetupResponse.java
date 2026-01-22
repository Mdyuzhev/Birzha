package com.company.resourcemanager.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TotpSetupResponse {
    private String secret;
    private String qrCodeDataUrl;
    private String manualEntryKey;
}
