package com.company.resourcemanager.dto.blacklist;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class RemoveFromBlacklistRequest {

    @NotBlank(message = "Причина снятия обязательна")
    @Size(max = 2000)
    private String reason;
}
