package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.ApplicationDto;
import com.company.resourcemanager.dto.workflow.*;
import com.company.resourcemanager.service.ApplicationWorkflowService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/applications")
@RequiredArgsConstructor
public class ApplicationWorkflowController {
    private final ApplicationWorkflowService workflowService;

    // === Подача заявки ===

    @PostMapping("/{id}/submit")
    @PreAuthorize("hasAnyRole('MANAGER', 'HR_BP')")
    public ResponseEntity<ApplicationDto> submit(
            @PathVariable Long id,
            @RequestParam(required = false) String comment) {
        return ResponseEntity.ok(workflowService.submit(id, comment));
    }

    // === Рекрутер берёт в работу ===

    @PostMapping("/{id}/assign-recruiter")
    @PreAuthorize("hasRole('RECRUITER')")
    public ResponseEntity<ApplicationDto> assignRecruiter(
            @PathVariable Long id,
            @RequestParam(required = false) String comment) {
        return ResponseEntity.ok(workflowService.assignRecruiter(id, comment));
    }

    // === Начало собеседования ===

    @PostMapping("/{id}/start-interview")
    @PreAuthorize("hasRole('RECRUITER')")
    public ResponseEntity<ApplicationDto> startInterview(
            @PathVariable Long id,
            @RequestParam(required = false) String comment) {
        return ResponseEntity.ok(workflowService.startInterview(id, comment));
    }

    // === Отправка на согласование HR BP ===

    @PostMapping("/{id}/send-to-hr-bp")
    @PreAuthorize("hasRole('RECRUITER')")
    public ResponseEntity<ApplicationDto> sendToHrBpApproval(
            @PathVariable Long id,
            @RequestBody(required = false) SendToApprovalRequest request) {
        if (request == null) {
            request = new SendToApprovalRequest();
        }
        request.setApplicationId(id);
        return ResponseEntity.ok(workflowService.sendToHrBpApproval(request));
    }

    // === Решение HR BP ===

    @PostMapping("/{id}/approve-hr-bp")
    @PreAuthorize("hasRole('HR_BP')")
    public ResponseEntity<ApplicationDto> approveByHrBp(
            @PathVariable Long id,
            @RequestBody(required = false) ApprovalDecisionRequest request) {
        if (request == null) {
            request = new ApprovalDecisionRequest();
        }
        request.setApplicationId(id);
        request.setApproved(true);
        return ResponseEntity.ok(workflowService.approveByHrBp(request));
    }

    @PostMapping("/{id}/reject-hr-bp")
    @PreAuthorize("hasRole('HR_BP')")
    public ResponseEntity<ApplicationDto> rejectByHrBp(
            @PathVariable Long id,
            @Valid @RequestBody ApprovalDecisionRequest request) {
        request.setApplicationId(id);
        request.setApproved(false);
        return ResponseEntity.ok(workflowService.rejectByHrBp(request));
    }

    // === Отправка на согласование БОРУП ===

    @PostMapping("/{id}/send-to-borup")
    @PreAuthorize("hasRole('RECRUITER')")
    public ResponseEntity<ApplicationDto> sendToBorupApproval(
            @PathVariable Long id,
            @RequestBody(required = false) SendToApprovalRequest request) {
        if (request == null) {
            request = new SendToApprovalRequest();
        }
        request.setApplicationId(id);
        return ResponseEntity.ok(workflowService.sendToBorupApproval(request));
    }

    // === Решение БОРУП ===

    @PostMapping("/{id}/approve-borup")
    @PreAuthorize("hasRole('BORUP')")
    public ResponseEntity<ApplicationDto> approveByBorup(
            @PathVariable Long id,
            @RequestBody(required = false) ApprovalDecisionRequest request) {
        if (request == null) {
            request = new ApprovalDecisionRequest();
        }
        request.setApplicationId(id);
        request.setApproved(true);
        return ResponseEntity.ok(workflowService.approveByBorup(request));
    }

    @PostMapping("/{id}/reject-borup")
    @PreAuthorize("hasRole('BORUP')")
    public ResponseEntity<ApplicationDto> rejectByBorup(
            @PathVariable Long id,
            @Valid @RequestBody ApprovalDecisionRequest request) {
        request.setApplicationId(id);
        request.setApproved(false);
        return ResponseEntity.ok(workflowService.rejectByBorup(request));
    }

    // === Подготовка к переводу ===

    @PostMapping("/{id}/prepare-transfer")
    @PreAuthorize("hasRole('RECRUITER')")
    public ResponseEntity<ApplicationDto> prepareTransfer(
            @PathVariable Long id,
            @RequestParam(required = false) String comment) {
        return ResponseEntity.ok(workflowService.prepareTransfer(id, comment));
    }

    // === Завершение перевода ===

    @PostMapping("/{id}/complete-transfer")
    @PreAuthorize("hasRole('RECRUITER')")
    public ResponseEntity<ApplicationDto> completeTransfer(
            @PathVariable Long id,
            @Valid @RequestBody CompleteTransferRequest request) {
        request.setApplicationId(id);
        return ResponseEntity.ok(workflowService.completeTransfer(request));
    }

    // === Увольнение ===

    @PostMapping("/{id}/dismiss")
    @PreAuthorize("hasAnyRole('RECRUITER', 'DZO_ADMIN', 'SYSTEM_ADMIN')")
    public ResponseEntity<ApplicationDto> dismiss(
            @PathVariable Long id,
            @Valid @RequestBody DismissRequest request) {
        request.setApplicationId(id);
        return ResponseEntity.ok(workflowService.dismiss(request));
    }

    // === Отмена ===

    @PostMapping("/{id}/cancel")
    public ResponseEntity<ApplicationDto> cancel(
            @PathVariable Long id,
            @RequestBody(required = false) CancelRequest request) {
        if (request == null) {
            request = new CancelRequest();
        }
        request.setApplicationId(id);
        return ResponseEntity.ok(workflowService.cancel(request));
    }

    // === Возврат на доработку ===

    @PostMapping("/{id}/return-to-hr-bp")
    @PreAuthorize("hasRole('RECRUITER')")
    public ResponseEntity<ApplicationDto> returnToHrBp(
            @PathVariable Long id,
            @RequestParam(required = false) String comment) {
        return ResponseEntity.ok(workflowService.returnToHrBp(id, comment));
    }

    @PostMapping("/{id}/return-to-borup")
    @PreAuthorize("hasRole('RECRUITER')")
    public ResponseEntity<ApplicationDto> returnToBorup(
            @PathVariable Long id,
            @RequestParam(required = false) String comment) {
        return ResponseEntity.ok(workflowService.returnToBorup(id, comment));
    }

    // === Доступные действия ===

    @GetMapping("/{id}/available-actions")
    public ResponseEntity<List<String>> getAvailableActions(@PathVariable Long id) {
        return ResponseEntity.ok(workflowService.getAvailableActions(id));
    }
}
