# Фаза 4: Заявки — Workflow

## Цель

Реализовать статусную машину для заявок: переходы между статусами, согласования HR BP и БОРУП, назначение рекрутера, итоговые решения. Каждое действие валидируется по роли пользователя и текущему статусу заявки.

**Расположение проекта:** `E:\Birzha`

**Зависимости:** 
- Фаза 1 (Мультитенантность) ✅
- Фаза 2 (Ролевая модель) ✅
- Фаза 3 (Заявки — Backend) ✅

---

## Схема Workflow

```
                    ┌─────────────────────────────────────────────────────────────────┐
                    │                                                                 │
                    ▼                                                                 │
┌──────────┐    ┌──────────────────────┐    ┌─────────────┐    ┌────────────┐        │
│  DRAFT   │───▶│ AVAILABLE_FOR_REVIEW │───▶│ IN_PROGRESS │───▶│ INTERVIEW  │        │
└──────────┘    └──────────────────────┘    └─────────────┘    └────────────┘        │
   submit()         assignRecruiter()          startInterview()       │              │
                                                                      │              │
                                               ┌──────────────────────┘              │
                                               ▼                                      │
                                        ┌──────────────┐                             │
                                        │ PENDING_HR_BP│◀────────────────────────────┤
                                        └──────────────┘      returnToHrBp()         │
                                               │                                      │
                              ┌────────────────┼────────────────┐                    │
                              ▼                                 ▼                    │
                    ┌─────────────────┐              ┌─────────────────┐             │
                    │ APPROVED_HR_BP  │              │ REJECTED_HR_BP  │─────────────┘
                    └─────────────────┘              └─────────────────┘
                              │                              cancel()
                              │
              ┌───────────────┴───────────────┐
              │ requiresBorupApproval?        │
              ▼ YES                           ▼ NO
      ┌──────────────┐                ┌───────────────────┐
      │PENDING_BORUP │                │PREPARING_TRANSFER │
      └──────────────┘                └───────────────────┘
              │                               │
    ┌─────────┼─────────┐                     │
    ▼                   ▼                     ▼
┌──────────────┐ ┌──────────────┐     ┌─────────────┐
│APPROVED_BORUP│ │REJECTED_BORUP│     │ TRANSFERRED │
└──────────────┘ └──────────────┘     └─────────────┘
        │               │
        ▼               │             ┌─────────────┐
┌───────────────────┐   └────────────▶│  DISMISSED  │
│PREPARING_TRANSFER │                 └─────────────┘
└───────────────────┘
        │
        ▼
┌─────────────┐
│ TRANSFERRED │
└─────────────┘
```

---

## Матрица переходов

| Из статуса | В статус | Действие | Роль | Условия |
|------------|----------|----------|------|---------|
| DRAFT | AVAILABLE_FOR_REVIEW | submit | MANAGER, HR_BP | Создатель заявки |
| AVAILABLE_FOR_REVIEW | IN_PROGRESS | assignRecruiter | RECRUITER | — |
| IN_PROGRESS | INTERVIEW | startInterview | RECRUITER | Назначенный рекрутер |
| INTERVIEW | PENDING_HR_BP | sendToHrBpApproval | RECRUITER | HR BP назначен |
| IN_PROGRESS | PENDING_HR_BP | sendToHrBpApproval | RECRUITER | HR BP назначен |
| PENDING_HR_BP | APPROVED_HR_BP | approveByHrBp | HR_BP | Назначенный HR BP |
| PENDING_HR_BP | REJECTED_HR_BP | rejectByHrBp | HR_BP | Назначенный HR BP |
| APPROVED_HR_BP | PENDING_BORUP | sendToBorupApproval | RECRUITER | requiresBorupApproval=true |
| APPROVED_HR_BP | PREPARING_TRANSFER | prepareTransfer | RECRUITER | requiresBorupApproval=false |
| PENDING_BORUP | APPROVED_BORUP | approveByBorup | BORUP | — |
| PENDING_BORUP | REJECTED_BORUP | rejectByBorup | BORUP | — |
| APPROVED_BORUP | PREPARING_TRANSFER | prepareTransfer | RECRUITER | — |
| PREPARING_TRANSFER | TRANSFERRED | completeTransfer | RECRUITER | transferDate указана |
| * (не финальные) | DISMISSED | dismiss | RECRUITER, DZO_ADMIN | — |
| * (не финальные) | CANCELLED | cancel | Создатель, DZO_ADMIN | — |
| REJECTED_HR_BP | PENDING_HR_BP | returnToHrBp | RECRUITER | После доработки |
| REJECTED_BORUP | PENDING_BORUP | returnToBorup | RECRUITER | После доработки |

---

## Задачи

### 1. Создать DTO для workflow действий

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/workflow/AssignRecruiterRequest.java`

```java
@Data
public class AssignRecruiterRequest {
    private Long applicationId;
    private String comment;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/workflow/SendToApprovalRequest.java`

```java
@Data
public class SendToApprovalRequest {
    @NotNull
    private Long applicationId;
    
    private Long approverId;  // HR BP или BORUP ID (опционально, если не назначен)
    
    private String comment;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/workflow/ApprovalDecisionRequest.java`

```java
@Data
public class ApprovalDecisionRequest {
    @NotNull
    private Long applicationId;
    
    @NotNull
    private Boolean approved;
    
    @Size(max = 2000)
    private String comment;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/workflow/CompleteTransferRequest.java`

```java
@Data
public class CompleteTransferRequest {
    @NotNull
    private Long applicationId;
    
    @NotNull
    private LocalDate transferDate;
    
    private String comment;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/workflow/DismissRequest.java`

```java
@Data
public class DismissRequest {
    @NotNull
    private Long applicationId;
    
    @NotBlank
    @Size(max = 2000)
    private String reason;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/workflow/CancelRequest.java`

```java
@Data
public class CancelRequest {
    @NotNull
    private Long applicationId;
    
    @Size(max = 2000)
    private String reason;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/workflow/ChangeStatusRequest.java`

```java
@Data
public class ChangeStatusRequest {
    @NotNull
    private Long applicationId;
    
    @NotNull
    private String newStatus;
    
    private String comment;
}
```

### 2. Создать ApplicationWorkflowService

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/ApplicationWorkflowService.java`

```java
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
```

### 3. Создать ApplicationWorkflowController

**Файл:** `backend/src/main/java/com/company/resourcemanager/controller/ApplicationWorkflowController.java`

```java
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
```

### 4. Добавить метод assignHrBp в ApplicationService

**Файл:** обновить `ApplicationService.java`

```java
// Добавить в ApplicationService

public ApplicationDto assignHrBp(Long applicationId, Long hrBpId) {
    Application app = findByIdWithAccessCheck(applicationId);
    User currentUser = currentUserService.getCurrentUser();
    
    // Рекрутер или создатель могут назначить HR BP
    boolean canAssign = (app.getRecruiter() != null && app.getRecruiter().getId().equals(currentUser.getId()))
        || app.getCreatedBy().getId().equals(currentUser.getId())
        || currentUser.hasRole(Role.DZO_ADMIN)
        || currentUser.hasRole(Role.SYSTEM_ADMIN);
    
    if (!canAssign) {
        throw new AccessDeniedException("No permission to assign HR BP");
    }
    
    User hrBp = userRepository.findById(hrBpId)
        .orElseThrow(() -> new ResourceNotFoundException("HR BP not found"));
    
    if (!hrBp.hasRole(Role.HR_BP)) {
        throw new BusinessException("User is not HR BP");
    }
    
    app.setHrBp(hrBp);
    app = applicationRepository.save(app);
    
    recordHistory(app, app.getStatus(), app.getStatus(), "ASSIGN_HR_BP", 
        "Назначен HR BP: " + hrBp.getUsername());
    
    return toDto(app);
}

public ApplicationDto assignBorup(Long applicationId, Long borupId) {
    Application app = findByIdWithAccessCheck(applicationId);
    User currentUser = currentUserService.getCurrentUser();
    
    // Только рекрутер или админ
    boolean canAssign = (app.getRecruiter() != null && app.getRecruiter().getId().equals(currentUser.getId()))
        || currentUser.hasRole(Role.DZO_ADMIN)
        || currentUser.hasRole(Role.SYSTEM_ADMIN);
    
    if (!canAssign) {
        throw new AccessDeniedException("No permission to assign BORUP");
    }
    
    User borup = userRepository.findById(borupId)
        .orElseThrow(() -> new ResourceNotFoundException("BORUP not found"));
    
    if (!borup.hasRole(Role.BORUP)) {
        throw new BusinessException("User is not BORUP");
    }
    
    app.setBorup(borup);
    app = applicationRepository.save(app);
    
    recordHistory(app, app.getStatus(), app.getStatus(), "ASSIGN_BORUP", 
        "Назначен БОРУП: " + borup.getUsername());
    
    return toDto(app);
}
```

### 5. Добавить эндпоинты назначения в ApplicationController

**Файл:** обновить `ApplicationController.java`

```java
// Добавить в ApplicationController

@PostMapping("/{id}/assign-hr-bp")
public ResponseEntity<ApplicationDto> assignHrBp(
        @PathVariable Long id,
        @RequestParam Long hrBpId) {
    return ResponseEntity.ok(applicationService.assignHrBp(id, hrBpId));
}

@PostMapping("/{id}/assign-borup")
public ResponseEntity<ApplicationDto> assignBorup(
        @PathVariable Long id,
        @RequestParam Long borupId) {
    return ResponseEntity.ok(applicationService.assignBorup(id, borupId));
}
```

---

## Критерии приёмки

### Backend

- [ ] **Все workflow действия работают**

| Действие | Endpoint | Роль | Из статуса | В статус |
|----------|----------|------|------------|----------|
| submit | POST /{id}/submit | MANAGER, HR_BP | DRAFT | AVAILABLE_FOR_REVIEW |
| assignRecruiter | POST /{id}/assign-recruiter | RECRUITER | AVAILABLE_FOR_REVIEW | IN_PROGRESS |
| startInterview | POST /{id}/start-interview | RECRUITER | IN_PROGRESS | INTERVIEW |
| sendToHrBpApproval | POST /{id}/send-to-hr-bp | RECRUITER | IN_PROGRESS, INTERVIEW | PENDING_HR_BP |
| approveByHrBp | POST /{id}/approve-hr-bp | HR_BP | PENDING_HR_BP | APPROVED_HR_BP |
| rejectByHrBp | POST /{id}/reject-hr-bp | HR_BP | PENDING_HR_BP | REJECTED_HR_BP |
| sendToBorupApproval | POST /{id}/send-to-borup | RECRUITER | APPROVED_HR_BP | PENDING_BORUP |
| approveByBorup | POST /{id}/approve-borup | BORUP | PENDING_BORUP | APPROVED_BORUP |
| rejectByBorup | POST /{id}/reject-borup | BORUP | PENDING_BORUP | REJECTED_BORUP |
| prepareTransfer | POST /{id}/prepare-transfer | RECRUITER | APPROVED_HR_BP*, APPROVED_BORUP | PREPARING_TRANSFER |
| completeTransfer | POST /{id}/complete-transfer | RECRUITER | PREPARING_TRANSFER | TRANSFERRED |
| dismiss | POST /{id}/dismiss | RECRUITER, DZO_ADMIN | любой не финальный | DISMISSED |
| cancel | POST /{id}/cancel | Создатель, DZO_ADMIN | любой не финальный | CANCELLED |
| returnToHrBp | POST /{id}/return-to-hr-bp | RECRUITER | REJECTED_HR_BP | PENDING_HR_BP |
| returnToBorup | POST /{id}/return-to-borup | RECRUITER | REJECTED_BORUP | PENDING_BORUP |

- [ ] **Валидации работают**
  - Нельзя перейти из финального статуса
  - Нельзя выполнить действие без нужной роли
  - Нельзя выполнить действие не из своего статуса
  - Нельзя отклонить без комментария
  - Нельзя пропустить БОРУП если requiresBorupApproval=true

- [ ] **История записывается**
  - Каждое действие создаёт запись в application_history
  - Сохраняется старый и новый статус
  - Сохраняется action и комментарий

- [ ] **Доступные действия возвращаются корректно**
  - GET /{id}/available-actions возвращает список доступных действий
  - Учитывается роль пользователя
  - Учитывается текущий статус заявки

### Тестирование (curl)

```bash
# === Полный workflow тест ===

# 1. Создать заявку (MANAGER)
curl -X POST http://localhost:31081/api/applications \
  -H "Authorization: Bearer $MANAGER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "employeeId": 1,
    "targetPosition": "Senior Developer",
    "targetStack": "Java",
    "currentSalary": 100000,
    "targetSalary": 150000,
    "hrBpId": 5
  }'
# Ответ: status = AVAILABLE_FOR_REVIEW, requiresBorupApproval = true

# 2. Рекрутер берёт в работу
curl -X POST http://localhost:31081/api/applications/1/assign-recruiter \
  -H "Authorization: Bearer $RECRUITER_TOKEN"
# Ответ: status = IN_PROGRESS, recruiterId = <current user>

# 3. Начать собеседование
curl -X POST http://localhost:31081/api/applications/1/start-interview \
  -H "Authorization: Bearer $RECRUITER_TOKEN"
# Ответ: status = INTERVIEW

# 4. Отправить на согласование HR BP
curl -X POST http://localhost:31081/api/applications/1/send-to-hr-bp \
  -H "Authorization: Bearer $RECRUITER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}'
# Ответ: status = PENDING_HR_BP

# 5. HR BP согласует
curl -X POST http://localhost:31081/api/applications/1/approve-hr-bp \
  -H "Authorization: Bearer $HR_BP_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"comment": "Согласовано"}'
# Ответ: status = APPROVED_HR_BP, hrBpDecision = APPROVED

# 6. Отправить на согласование БОРУП (т.к. >30%)
curl -X POST "http://localhost:31081/api/applications/1/send-to-borup?borupId=6" \
  -H "Authorization: Bearer $RECRUITER_TOKEN"
# Ответ: status = PENDING_BORUP

# 7. БОРУП согласует
curl -X POST http://localhost:31081/api/applications/1/approve-borup \
  -H "Authorization: Bearer $BORUP_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"comment": "Согласовано БОРУП"}'
# Ответ: status = APPROVED_BORUP

# 8. Подготовка к переводу
curl -X POST http://localhost:31081/api/applications/1/prepare-transfer \
  -H "Authorization: Bearer $RECRUITER_TOKEN"
# Ответ: status = PREPARING_TRANSFER

# 9. Завершить перевод
curl -X POST http://localhost:31081/api/applications/1/complete-transfer \
  -H "Authorization: Bearer $RECRUITER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"transferDate": "2026-02-01", "comment": "Успешный перевод"}'
# Ответ: status = TRANSFERRED, transferDate = 2026-02-01

# === Проверка истории ===
curl -X GET http://localhost:31081/api/applications/1/history \
  -H "Authorization: Bearer $TOKEN"
# Ответ: 9 записей истории

# === Проверка доступных действий ===
curl -X GET http://localhost:31081/api/applications/1/available-actions \
  -H "Authorization: Bearer $RECRUITER_TOKEN"
# Ответ: [] (финальный статус, действий нет)
```

---

## Файлы для создания/изменения

### Создать новые файлы:
```
backend/src/main/java/com/company/resourcemanager/dto/workflow/AssignRecruiterRequest.java
backend/src/main/java/com/company/resourcemanager/dto/workflow/SendToApprovalRequest.java
backend/src/main/java/com/company/resourcemanager/dto/workflow/ApprovalDecisionRequest.java
backend/src/main/java/com/company/resourcemanager/dto/workflow/CompleteTransferRequest.java
backend/src/main/java/com/company/resourcemanager/dto/workflow/DismissRequest.java
backend/src/main/java/com/company/resourcemanager/dto/workflow/CancelRequest.java
backend/src/main/java/com/company/resourcemanager/dto/workflow/ChangeStatusRequest.java
backend/src/main/java/com/company/resourcemanager/service/ApplicationWorkflowService.java
backend/src/main/java/com/company/resourcemanager/controller/ApplicationWorkflowController.java
```

### Изменить существующие файлы:
```
backend/src/main/java/com/company/resourcemanager/service/ApplicationService.java
backend/src/main/java/com/company/resourcemanager/controller/ApplicationController.java
```

---

## После завершения

1. Обновить статус Фазы 4 в `E:\Birzha\.claude\DEVELOPMENT_PLAN.md` на ✅ Завершено
2. Обновить `E:\Birzha\.claude\Project_map.md`:
   - Добавить описание ApplicationWorkflowService
   - Добавить все workflow endpoints
   - Добавить диаграмму workflow
3. Создать тестовых пользователей с разными ролями для полного тестирования workflow
4. Перейти к Фазе 5 (Заявки — Frontend)
