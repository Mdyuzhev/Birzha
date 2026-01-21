package com.company.resourcemanager.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
public class ApplicationDto {
    private Long id;
    private Long dzoId;
    private String dzoName;

    // Сотрудник
    private Long employeeId;
    private String employeeName;
    private String employeeEmail;

    // Создатель
    private Long createdById;
    private String createdByName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Статус
    private String status;
    private String statusDisplayName;

    // Данные заявки
    private String targetPosition;
    private String targetStack;
    private BigDecimal currentSalary;
    private BigDecimal targetSalary;
    private BigDecimal salaryIncreasePercent;
    private Boolean requiresBorupApproval;
    private String resumeFilePath;
    private String comment;

    // Участники
    private Long recruiterId;
    private String recruiterName;
    private LocalDateTime assignedToRecruiterAt;

    private Long hrBpId;
    private String hrBpName;

    private Long borupId;
    private String borupName;

    // Решения
    private String hrBpDecision;
    private String hrBpComment;
    private LocalDateTime hrBpDecisionAt;

    private String borupDecision;
    private String borupComment;
    private LocalDateTime borupDecisionAt;

    // Итог
    private String finalComment;
    private LocalDate transferDate;
    private LocalDateTime completedAt;
}
