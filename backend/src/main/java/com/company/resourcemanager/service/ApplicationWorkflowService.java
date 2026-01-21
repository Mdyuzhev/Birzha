package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.ApplicationDto;
import com.company.resourcemanager.dto.workflow.*;
import com.company.resourcemanager.entity.*;
import com.company.resourcemanager.exception.BusinessException;
import com.company.resourcemanager.exception.ResourceNotFoundException;
import com.company.resourcemanager.repository.ApplicationHistoryRepository;
import com.company.resourcemanager.repository.ApplicationRepository;
import com.company.resourcemanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ApplicationWorkflowService {
    private final ApplicationRepository applicationRepository;
    private final ApplicationHistoryRepository historyRepository;
    private final UserRepository userRepository;
    private final CurrentUserService currentUserService;
    private final RoleService roleService;

    // === Подача заявки (из черновика) ===

    public ApplicationDto submit(Long applicationId, String comment) {
        Application app = getApplicationWithAccessCheck(applicationId);
        User currentUser = currentUserService.getCurrentUser();

        validateTransition(app, ApplicationStatus.AVAILABLE_FOR_REVIEW);
        validateIsCreator(app, currentUser);

        ApplicationStatus oldStatus = app.getStatus();
        app.setStatus(ApplicationStatus.AVAILABLE_FOR_REVIEW);
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "SUBMIT",
            comment != null ? comment : "Заявка подана на рассмотрение");

        return toDto(app);
    }

    // === Рекрутер берёт заявку в работу ===

    public ApplicationDto assignRecruiter(Long applicationId, String comment) {
        Application app = getApplicationWithAccessCheck(applicationId);
        User currentUser = currentUserService.getCurrentUser();

        validateRole(currentUser, Role.RECRUITER);
        validateStatus(app, ApplicationStatus.AVAILABLE_FOR_REVIEW);

        ApplicationStatus oldStatus = app.getStatus();
        app.setRecruiter(currentUser);
        app.setAssignedToRecruiterAt(LocalDateTime.now());
        app.setStatus(ApplicationStatus.IN_PROGRESS);
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "ASSIGN_RECRUITER",
            comment != null ? comment : "Рекрутер взял заявку в работу");

        return toDto(app);
    }

    // === Начало собеседования ===

    public ApplicationDto startInterview(Long applicationId, String comment) {
        Application app = getApplicationWithAccessCheck(applicationId);
        User currentUser = currentUserService.getCurrentUser();

        validateIsRecruiter(app, currentUser);
        validateStatus(app, ApplicationStatus.IN_PROGRESS);

        ApplicationStatus oldStatus = app.getStatus();
        app.setStatus(ApplicationStatus.INTERVIEW);
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "START_INTERVIEW",
            comment != null ? comment : "Начато собеседование");

        return toDto(app);
    }

    // === Отправка на согласование HR BP ===

    public ApplicationDto sendToHrBpApproval(SendToApprovalRequest request) {
        Application app = getApplicationWithAccessCheck(request.getApplicationId());
        User currentUser = currentUserService.getCurrentUser();

        validateIsRecruiter(app, currentUser);
        validateStatusIn(app, ApplicationStatus.IN_PROGRESS, ApplicationStatus.INTERVIEW);

        // Назначить HR BP если указан
        if (request.getApproverId() != null) {
            User hrBp = userRepository.findById(request.getApproverId())
                .orElseThrow(() -> new ResourceNotFoundException("HR BP not found"));
            if (!hrBp.hasRole(Role.HR_BP)) {
                throw new BusinessException("User is not HR BP");
            }
            app.setHrBp(hrBp);
        }

        if (app.getHrBp() == null) {
            throw new BusinessException("HR BP must be assigned before sending for approval");
        }

        ApplicationStatus oldStatus = app.getStatus();
        app.setStatus(ApplicationStatus.PENDING_HR_BP);
        app.setHrBpDecision(DecisionType.PENDING);
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "SEND_TO_HR_BP",
            request.getComment() != null ? request.getComment() : "Отправлено на согласование HR BP");

        // TODO: Отправить email уведомление HR BP (Фаза 9)

        return toDto(app);
    }

    // === Решение HR BP ===

    public ApplicationDto approveByHrBp(ApprovalDecisionRequest request) {
        Application app = getApplicationWithAccessCheck(request.getApplicationId());
        User currentUser = currentUserService.getCurrentUser();

        validateIsHrBp(app, currentUser);
        validateStatus(app, ApplicationStatus.PENDING_HR_BP);

        ApplicationStatus oldStatus = app.getStatus();
        app.setHrBpDecision(DecisionType.APPROVED);
        app.setHrBpComment(request.getComment());
        app.setHrBpDecisionAt(LocalDateTime.now());
        app.setStatus(ApplicationStatus.APPROVED_HR_BP);
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "HR_BP_APPROVED",
            request.getComment() != null ? request.getComment() : "Согласовано HR BP");

        // TODO: Отправить email уведомление создателю и рекрутеру (Фаза 9)

        return toDto(app);
    }

    public ApplicationDto rejectByHrBp(ApprovalDecisionRequest request) {
        Application app = getApplicationWithAccessCheck(request.getApplicationId());
        User currentUser = currentUserService.getCurrentUser();

        validateIsHrBp(app, currentUser);
        validateStatus(app, ApplicationStatus.PENDING_HR_BP);

        if (request.getComment() == null || request.getComment().isBlank()) {
            throw new BusinessException("Comment is required for rejection");
        }

        ApplicationStatus oldStatus = app.getStatus();
        app.setHrBpDecision(DecisionType.REJECTED);
        app.setHrBpComment(request.getComment());
        app.setHrBpDecisionAt(LocalDateTime.now());
        app.setStatus(ApplicationStatus.REJECTED_HR_BP);
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "HR_BP_REJECTED", request.getComment());

        // TODO: Отправить email уведомление (Фаза 9)

        return toDto(app);
    }

    // === Отправка на согласование БОРУП ===

    public ApplicationDto sendToBorupApproval(SendToApprovalRequest request) {
        Application app = getApplicationWithAccessCheck(request.getApplicationId());
        User currentUser = currentUserService.getCurrentUser();

        validateIsRecruiter(app, currentUser);
        validateStatus(app, ApplicationStatus.APPROVED_HR_BP);

        if (!app.getRequiresBorupApproval()) {
            throw new BusinessException("This application does not require BORUP approval (salary increase <= 30%)");
        }

        // Назначить БОРУП если указан
        if (request.getApproverId() != null) {
            User borup = userRepository.findById(request.getApproverId())
                .orElseThrow(() -> new ResourceNotFoundException("BORUP not found"));
            if (!borup.hasRole(Role.BORUP)) {
                throw new BusinessException("User is not BORUP");
            }
            app.setBorup(borup);
        }

        if (app.getBorup() == null) {
            throw new BusinessException("BORUP must be assigned before sending for approval");
        }

        ApplicationStatus oldStatus = app.getStatus();
        app.setStatus(ApplicationStatus.PENDING_BORUP);
        app.setBorupDecision(DecisionType.PENDING);
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "SEND_TO_BORUP",
            request.getComment() != null ? request.getComment() : "Отправлено на согласование БОРУП");

        // TODO: Отправить email уведомление БОРУП (Фаза 9)

        return toDto(app);
    }

    // === Решение БОРУП ===

    public ApplicationDto approveByBorup(ApprovalDecisionRequest request) {
        Application app = getApplicationWithAccessCheck(request.getApplicationId());
        User currentUser = currentUserService.getCurrentUser();

        validateRole(currentUser, Role.BORUP);
        validateStatus(app, ApplicationStatus.PENDING_BORUP);

        ApplicationStatus oldStatus = app.getStatus();
        app.setBorupDecision(DecisionType.APPROVED);
        app.setBorupComment(request.getComment());
        app.setBorupDecisionAt(LocalDateTime.now());
        app.setStatus(ApplicationStatus.APPROVED_BORUP);
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "BORUP_APPROVED",
            request.getComment() != null ? request.getComment() : "Согласовано БОРУП");

        return toDto(app);
    }

    public ApplicationDto rejectByBorup(ApprovalDecisionRequest request) {
        Application app = getApplicationWithAccessCheck(request.getApplicationId());
        User currentUser = currentUserService.getCurrentUser();

        validateRole(currentUser, Role.BORUP);
        validateStatus(app, ApplicationStatus.PENDING_BORUP);

        if (request.getComment() == null || request.getComment().isBlank()) {
            throw new BusinessException("Comment is required for rejection");
        }

        ApplicationStatus oldStatus = app.getStatus();
        app.setBorupDecision(DecisionType.REJECTED);
        app.setBorupComment(request.getComment());
        app.setBorupDecisionAt(LocalDateTime.now());
        app.setStatus(ApplicationStatus.REJECTED_BORUP);
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "BORUP_REJECTED", request.getComment());

        return toDto(app);
    }

    // === Подготовка к переводу ===

    public ApplicationDto prepareTransfer(Long applicationId, String comment) {
        Application app = getApplicationWithAccessCheck(applicationId);
        User currentUser = currentUserService.getCurrentUser();

        validateIsRecruiter(app, currentUser);

        // Можно перейти из APPROVED_HR_BP (если не требуется БОРУП) или APPROVED_BORUP
        if (app.getStatus() == ApplicationStatus.APPROVED_HR_BP) {
            if (app.getRequiresBorupApproval()) {
                throw new BusinessException("BORUP approval is required before transfer");
            }
        } else if (app.getStatus() != ApplicationStatus.APPROVED_BORUP) {
            throw new BusinessException("Invalid status for prepare transfer: " + app.getStatus());
        }

        ApplicationStatus oldStatus = app.getStatus();
        app.setStatus(ApplicationStatus.PREPARING_TRANSFER);
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "PREPARE_TRANSFER",
            comment != null ? comment : "Подготовка к переводу");

        return toDto(app);
    }

    // === Завершение перевода ===

    public ApplicationDto completeTransfer(CompleteTransferRequest request) {
        Application app = getApplicationWithAccessCheck(request.getApplicationId());
        User currentUser = currentUserService.getCurrentUser();

        validateIsRecruiter(app, currentUser);
        validateStatus(app, ApplicationStatus.PREPARING_TRANSFER);

        ApplicationStatus oldStatus = app.getStatus();
        app.setStatus(ApplicationStatus.TRANSFERRED);
        app.setTransferDate(request.getTransferDate());
        app.setFinalComment(request.getComment());
        app.setCompletedAt(LocalDateTime.now());
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "COMPLETE_TRANSFER",
            "Перевод завершён. Дата перевода: " + request.getTransferDate());

        return toDto(app);
    }

    // === Увольнение ===

    public ApplicationDto dismiss(DismissRequest request) {
        Application app = getApplicationWithAccessCheck(request.getApplicationId());
        User currentUser = currentUserService.getCurrentUser();

        // Рекрутер или админ ДЗО
        if (!currentUser.hasRole(Role.RECRUITER) &&
            !currentUser.hasRole(Role.DZO_ADMIN) &&
            !currentUser.hasRole(Role.SYSTEM_ADMIN)) {
            throw new AccessDeniedException("No permission to dismiss");
        }

        if (currentUser.hasRole(Role.RECRUITER)) {
            validateIsRecruiter(app, currentUser);
        }

        validateNotFinalStatus(app);

        ApplicationStatus oldStatus = app.getStatus();
        app.setStatus(ApplicationStatus.DISMISSED);
        app.setFinalComment(request.getReason());
        app.setCompletedAt(LocalDateTime.now());
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "DISMISS", request.getReason());

        return toDto(app);
    }

    // === Отмена заявки ===

    public ApplicationDto cancel(CancelRequest request) {
        Application app = getApplicationWithAccessCheck(request.getApplicationId());
        User currentUser = currentUserService.getCurrentUser();

        // Создатель или админ
        boolean isCreator = app.getCreatedBy().getId().equals(currentUser.getId());
        boolean isAdmin = currentUser.hasRole(Role.DZO_ADMIN) || currentUser.hasRole(Role.SYSTEM_ADMIN);

        if (!isCreator && !isAdmin) {
            throw new AccessDeniedException("Only creator or admin can cancel application");
        }

        validateNotFinalStatus(app);

        ApplicationStatus oldStatus = app.getStatus();
        app.setStatus(ApplicationStatus.CANCELLED);
        app.setFinalComment(request.getReason());
        app.setCompletedAt(LocalDateTime.now());
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "CANCEL",
            request.getReason() != null ? request.getReason() : "Заявка отменена");

        return toDto(app);
    }

    // === Возврат на доработку ===

    public ApplicationDto returnToHrBp(Long applicationId, String comment) {
        Application app = getApplicationWithAccessCheck(applicationId);
        User currentUser = currentUserService.getCurrentUser();

        validateIsRecruiter(app, currentUser);
        validateStatus(app, ApplicationStatus.REJECTED_HR_BP);

        ApplicationStatus oldStatus = app.getStatus();
        app.setStatus(ApplicationStatus.PENDING_HR_BP);
        app.setHrBpDecision(DecisionType.PENDING);
        app.setHrBpComment(null);
        app.setHrBpDecisionAt(null);
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "RETURN_TO_HR_BP",
            comment != null ? comment : "Возвращено на повторное согласование HR BP");

        return toDto(app);
    }

    public ApplicationDto returnToBorup(Long applicationId, String comment) {
        Application app = getApplicationWithAccessCheck(applicationId);
        User currentUser = currentUserService.getCurrentUser();

        validateIsRecruiter(app, currentUser);
        validateStatus(app, ApplicationStatus.REJECTED_BORUP);

        ApplicationStatus oldStatus = app.getStatus();
        app.setStatus(ApplicationStatus.PENDING_BORUP);
        app.setBorupDecision(DecisionType.PENDING);
        app.setBorupComment(null);
        app.setBorupDecisionAt(null);
        app = applicationRepository.save(app);

        recordHistory(app, oldStatus, app.getStatus(), "RETURN_TO_BORUP",
            comment != null ? comment : "Возвращено на повторное согласование БОРУП");

        return toDto(app);
    }

    // === Получить доступные действия ===

    public List<String> getAvailableActions(Long applicationId) {
        Application app = getApplicationWithAccessCheck(applicationId);
        User currentUser = currentUserService.getCurrentUser();

        List<String> actions = new ArrayList<>();
        ApplicationStatus status = app.getStatus();

        boolean isCreator = app.getCreatedBy().getId().equals(currentUser.getId());
        boolean isRecruiter = app.getRecruiter() != null &&
                             app.getRecruiter().getId().equals(currentUser.getId());
        boolean isHrBp = app.getHrBp() != null &&
                        app.getHrBp().getId().equals(currentUser.getId());
        boolean isBorup = currentUser.hasRole(Role.BORUP);
        boolean isAdmin = currentUser.hasRole(Role.DZO_ADMIN) || currentUser.hasRole(Role.SYSTEM_ADMIN);

        switch (status) {
            case DRAFT:
                if (isCreator) actions.add("submit");
                break;

            case AVAILABLE_FOR_REVIEW:
                if (currentUser.hasRole(Role.RECRUITER)) actions.add("assignRecruiter");
                if (isCreator || isAdmin) actions.add("cancel");
                break;

            case IN_PROGRESS:
                if (isRecruiter) {
                    actions.add("startInterview");
                    actions.add("sendToHrBpApproval");
                }
                if (isCreator || isAdmin) actions.add("cancel");
                break;

            case INTERVIEW:
                if (isRecruiter) actions.add("sendToHrBpApproval");
                if (isCreator || isAdmin) actions.add("cancel");
                break;

            case PENDING_HR_BP:
                if (isHrBp) {
                    actions.add("approveByHrBp");
                    actions.add("rejectByHrBp");
                }
                if (isCreator || isAdmin) actions.add("cancel");
                break;

            case APPROVED_HR_BP:
                if (isRecruiter) {
                    if (app.getRequiresBorupApproval()) {
                        actions.add("sendToBorupApproval");
                    } else {
                        actions.add("prepareTransfer");
                    }
                }
                if (isCreator || isAdmin) actions.add("cancel");
                break;

            case REJECTED_HR_BP:
                if (isRecruiter) actions.add("returnToHrBp");
                if (isCreator || isAdmin) actions.add("cancel");
                if (isRecruiter || isAdmin) actions.add("dismiss");
                break;

            case PENDING_BORUP:
                if (isBorup) {
                    actions.add("approveByBorup");
                    actions.add("rejectByBorup");
                }
                if (isCreator || isAdmin) actions.add("cancel");
                break;

            case APPROVED_BORUP:
                if (isRecruiter) actions.add("prepareTransfer");
                if (isCreator || isAdmin) actions.add("cancel");
                break;

            case REJECTED_BORUP:
                if (isRecruiter) actions.add("returnToBorup");
                if (isCreator || isAdmin) actions.add("cancel");
                if (isRecruiter || isAdmin) actions.add("dismiss");
                break;

            case PREPARING_TRANSFER:
                if (isRecruiter) {
                    actions.add("completeTransfer");
                    actions.add("dismiss");
                }
                if (isCreator || isAdmin) actions.add("cancel");
                break;

            // Финальные статусы — действий нет
            case TRANSFERRED:
            case DISMISSED:
            case CANCELLED:
                break;
        }

        return actions;
    }

    // === Валидации ===

    private void validateTransition(Application app, ApplicationStatus targetStatus) {
        // Проверка допустимости перехода (можно расширить)
        if (app.getStatus().isFinal()) {
            throw new BusinessException("Cannot change status of completed application");
        }
    }

    private void validateStatus(Application app, ApplicationStatus expectedStatus) {
        if (app.getStatus() != expectedStatus) {
            throw new BusinessException("Invalid status. Expected: " + expectedStatus +
                ", actual: " + app.getStatus());
        }
    }

    private void validateStatusIn(Application app, ApplicationStatus... expectedStatuses) {
        for (ApplicationStatus expected : expectedStatuses) {
            if (app.getStatus() == expected) return;
        }
        throw new BusinessException("Invalid status: " + app.getStatus() +
            ". Expected one of: " + Arrays.toString(expectedStatuses));
    }

    private void validateNotFinalStatus(Application app) {
        if (app.getStatus().isFinal()) {
            throw new BusinessException("Application is already in final status: " + app.getStatus());
        }
    }

    private void validateRole(User user, Role role) {
        if (!user.hasRole(role)) {
            throw new AccessDeniedException("User does not have role: " + role);
        }
    }

    private void validateIsCreator(Application app, User user) {
        if (!app.getCreatedBy().getId().equals(user.getId())) {
            throw new AccessDeniedException("Only creator can perform this action");
        }
    }

    private void validateIsRecruiter(Application app, User user) {
        if (app.getRecruiter() == null || !app.getRecruiter().getId().equals(user.getId())) {
            throw new AccessDeniedException("Only assigned recruiter can perform this action");
        }
    }

    private void validateIsHrBp(Application app, User user) {
        if (app.getHrBp() == null || !app.getHrBp().getId().equals(user.getId())) {
            throw new AccessDeniedException("Only assigned HR BP can perform this action");
        }
    }

    // === Вспомогательные методы ===

    private Application getApplicationWithAccessCheck(Long id) {
        Application app = applicationRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Application not found: " + id));

        User currentUser = currentUserService.getCurrentUser();
        if (!currentUser.isSystemAdmin() &&
            !roleService.canAccessDzo(currentUser, app.getDzo().getId())) {
            throw new AccessDeniedException("No access to this application");
        }

        return app;
    }

    private void recordHistory(Application app, ApplicationStatus oldStatus,
                              ApplicationStatus newStatus, String action, String comment) {
        User currentUser = currentUserService.getCurrentUser();

        ApplicationHistory history = ApplicationHistory.builder()
            .application(app)
            .changedBy(currentUser)
            .oldStatus(oldStatus)
            .newStatus(newStatus)
            .action(action)
            .comment(comment)
            .build();

        historyRepository.save(history);
    }

    private ApplicationDto toDto(Application app) {
        // Использовать маппер из ApplicationService или создать общий
        return ApplicationDto.builder()
            .id(app.getId())
            .dzoId(app.getDzo().getId())
            .dzoName(app.getDzo().getName())
            .employeeId(app.getEmployee().getId())
            .employeeName(app.getEmployee().getFullName())
            .employeeEmail(app.getEmployee().getEmail())
            .createdById(app.getCreatedBy().getId())
            .createdByName(app.getCreatedBy().getUsername())
            .createdAt(app.getCreatedAt())
            .updatedAt(app.getUpdatedAt())
            .status(app.getStatus().name())
            .statusDisplayName(app.getStatus().getDisplayName())
            .targetPosition(app.getTargetPosition())
            .targetStack(app.getTargetStack())
            .currentSalary(app.getCurrentSalary())
            .targetSalary(app.getTargetSalary())
            .salaryIncreasePercent(app.getSalaryIncreasePercent())
            .requiresBorupApproval(app.getRequiresBorupApproval())
            .resumeFilePath(app.getResumeFilePath())
            .comment(app.getComment())
            .recruiterId(app.getRecruiter() != null ? app.getRecruiter().getId() : null)
            .recruiterName(app.getRecruiter() != null ? app.getRecruiter().getUsername() : null)
            .assignedToRecruiterAt(app.getAssignedToRecruiterAt())
            .hrBpId(app.getHrBp() != null ? app.getHrBp().getId() : null)
            .hrBpName(app.getHrBp() != null ? app.getHrBp().getUsername() : null)
            .borupId(app.getBorup() != null ? app.getBorup().getId() : null)
            .borupName(app.getBorup() != null ? app.getBorup().getUsername() : null)
            .hrBpDecision(app.getHrBpDecision() != null ? app.getHrBpDecision().name() : null)
            .hrBpComment(app.getHrBpComment())
            .hrBpDecisionAt(app.getHrBpDecisionAt())
            .borupDecision(app.getBorupDecision() != null ? app.getBorupDecision().name() : null)
            .borupComment(app.getBorupComment())
            .borupDecisionAt(app.getBorupDecisionAt())
            .finalComment(app.getFinalComment())
            .transferDate(app.getTransferDate())
            .completedAt(app.getCompletedAt())
            .build();
    }
}
