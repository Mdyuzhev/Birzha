package com.company.resourcemanager.dto.blacklist;

import jakarta.validation.constraints.Size;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class UpdateBlacklistRequest {

    @Size(max = 255)
    private String fullName;

    @Size(max = 255)
    private String email;

    @Size(max = 50)
    private String phone;

    @Size(max = 2000)
    private String reason;

    private String reasonCategory;

    @Size(max = 255)
    private String source;

    private LocalDateTime expiresAt;
}
