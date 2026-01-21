package com.company.resourcemanager.dto.blacklist;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class CreateBlacklistRequest {

    private Long employeeId;  // Опционально — связь с сотрудником

    @NotBlank(message = "ФИО обязательно")
    @Size(max = 255)
    private String fullName;

    @Size(max = 255)
    private String email;

    @Size(max = 50)
    private String phone;

    @NotBlank(message = "Причина обязательна")
    @Size(max = 2000)
    private String reason;

    @NotNull(message = "Категория причины обязательна")
    private String reasonCategory;  // Enum name

    @Size(max = 255)
    private String source;

    private LocalDateTime expiresAt;  // Опционально — срок действия
}
