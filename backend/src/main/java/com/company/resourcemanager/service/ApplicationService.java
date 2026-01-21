package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.*;
import com.company.resourcemanager.entity.*;
import com.company.resourcemanager.exception.BusinessException;
import com.company.resourcemanager.exception.ResourceNotFoundException;
import com.company.resourcemanager.repository.ApplicationHistoryRepository;
import com.company.resourcemanager.repository.ApplicationRepository;
import com.company.resourcemanager.repository.EmployeeRepository;
import com.company.resourcemanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional
public class ApplicationService {
    private final ApplicationRepository applicationRepository;
    private final ApplicationHistoryRepository historyRepository;
    private final EmployeeRepository employeeRepository;
    private final UserRepository userRepository;
    private final CurrentUserService currentUserService;
    private final RoleService roleService;
    private final BlacklistService blacklistService;

    // === CRUD операции ===

    public ApplicationDto create(CreateApplicationRequest request) {
        User currentUser = currentUserService.getCurrentUser();

        // Проверка прав: только Руководитель или HR BP могут создавать заявки
        if (!currentUser.hasRole(Role.MANAGER) && !currentUser.hasRole(Role.HR_BP)) {
            throw new AccessDeniedException("Only MANAGER or HR_BP can create applications");
        }

        Employee employee = employeeRepository.findById(request.getEmployeeId())
            .orElseThrow(() -> new ResourceNotFoundException("Employee not found"));

        // Проверка чёрного списка
        if (blacklistService.isEmployeeInBlacklist(request.getEmployeeId(), currentUser.getDzo().getId())) {
            throw new BusinessException("Сотрудник находится в чёрном списке. Создание заявки невозможно.");
        }

        // Проверка: нет ли уже активной заявки на этого сотрудника
        List<ApplicationStatus> finalStatuses = List.of(
            ApplicationStatus.TRANSFERRED,
            ApplicationStatus.DISMISSED,
            ApplicationStatus.CANCELLED
        );
        if (applicationRepository.findByEmployeeIdAndStatusNotIn(employee.getId(), finalStatuses).isPresent()) {
            throw new BusinessException("Employee already has an active application");
        }

        Application application = Application.builder()
            .dzo(currentUser.getDzo())
            .employee(employee)
            .createdBy(currentUser)
            .status(ApplicationStatus.AVAILABLE_FOR_REVIEW)
            .targetPosition(request.getTargetPosition())
            .targetStack(request.getTargetStack())
            .currentSalary(request.getCurrentSalary())
            .targetSalary(request.getTargetSalary())
            .comment(request.getComment())
            .build();

        // Если указан HR BP
        if (request.getHrBpId() != null) {
            User hrBp = userRepository.findById(request.getHrBpId())
                .orElseThrow(() -> new ResourceNotFoundException("HR BP not found"));
            application.setHrBp(hrBp);
        }

        application = applicationRepository.save(application);

        // Записать в историю
        recordHistory(application, null, ApplicationStatus.AVAILABLE_FOR_REVIEW,
            "CREATE", "Заявка создана");

        return toDto(application);
    }

    public ApplicationDto getById(Long id) {
        Application application = findByIdWithAccessCheck(id);
        return toDto(application);
    }

    public ApplicationDto update(Long id, UpdateApplicationRequest request) {
        Application application = findByIdWithAccessCheck(id);
        User currentUser = currentUserService.getCurrentUser();

        // Можно редактировать только в статусах DRAFT, AVAILABLE_FOR_REVIEW
        if (application.getStatus() != ApplicationStatus.DRAFT &&
            application.getStatus() != ApplicationStatus.AVAILABLE_FOR_REVIEW) {
            throw new BusinessException("Cannot update application in status: " + application.getStatus());
        }

        // Проверка прав: создатель или рекрутер
        if (!application.getCreatedBy().getId().equals(currentUser.getId()) &&
            (application.getRecruiter() == null || !application.getRecruiter().getId().equals(currentUser.getId()))) {
            throw new AccessDeniedException("No permission to update this application");
        }

        if (request.getTargetPosition() != null) {
            application.setTargetPosition(request.getTargetPosition());
        }
        if (request.getTargetStack() != null) {
            application.setTargetStack(request.getTargetStack());
        }
        if (request.getCurrentSalary() != null) {
            application.setCurrentSalary(request.getCurrentSalary());
        }
        if (request.getTargetSalary() != null) {
            application.setTargetSalary(request.getTargetSalary());
        }
        if (request.getComment() != null) {
            application.setComment(request.getComment());
        }
        if (request.getHrBpId() != null) {
            User hrBp = userRepository.findById(request.getHrBpId())
                .orElseThrow(() -> new ResourceNotFoundException("HR BP not found"));
            application.setHrBp(hrBp);
        }

        application = applicationRepository.save(application);

        recordHistory(application, application.getStatus(), application.getStatus(),
            "UPDATE", "Заявка обновлена");

        return toDto(application);
    }

    public void delete(Long id) {
        Application application = findByIdWithAccessCheck(id);
        User currentUser = currentUserService.getCurrentUser();

        // Можно удалить только черновик
        if (application.getStatus() != ApplicationStatus.DRAFT) {
            throw new BusinessException("Can only delete DRAFT applications");
        }

        // Проверка прав: только создатель
        if (!application.getCreatedBy().getId().equals(currentUser.getId()) &&
            !currentUser.isSystemAdmin() && !currentUser.isDzoAdmin()) {
            throw new AccessDeniedException("No permission to delete this application");
        }

        applicationRepository.delete(application);
    }

    // === Списки и фильтрация ===

    public Page<ApplicationDto> getAll(ApplicationFilterRequest filter, Pageable pageable) {
        User currentUser = currentUserService.getCurrentUser();
        Long dzoId = currentUserService.getCurrentDzoId();

        // Системный админ видит все
        if (currentUser.isSystemAdmin()) {
            dzoId = null;
        }

        // Применить фильтры (упрощённая версия)
        Page<Application> applications;
        if (dzoId != null) {
            if (filter != null && filter.getSearch() != null && !filter.getSearch().isEmpty()) {
                applications = applicationRepository.searchByDzo(dzoId, filter.getSearch(), pageable);
            } else if (filter != null && filter.getStatuses() != null && !filter.getStatuses().isEmpty()) {
                List<ApplicationStatus> statuses = filter.getStatuses().stream()
                    .map(ApplicationStatus::valueOf)
                    .toList();
                applications = applicationRepository.findByDzoIdAndStatus(dzoId, statuses.get(0), pageable);
            } else {
                applications = applicationRepository.findByDzoId(dzoId, pageable);
            }
        } else {
            applications = applicationRepository.findAll(pageable);
        }

        return applications.map(this::toDto);
    }

    public Page<ApplicationDto> getMyApplications(Pageable pageable) {
        User currentUser = currentUserService.getCurrentUser();
        Page<Application> applications = applicationRepository.findByCreatedById(currentUser.getId(), pageable);
        return applications.map(this::toDto);
    }

    public Page<ApplicationDto> getAssignedToMe(Pageable pageable) {
        User currentUser = currentUserService.getCurrentUser();
        Page<Application> applications = applicationRepository.findByRecruiterId(currentUser.getId(), pageable);
        return applications.map(this::toDto);
    }

    public Page<ApplicationDto> getPendingMyApproval(Pageable pageable) {
        User currentUser = currentUserService.getCurrentUser();

        if (currentUser.hasRole(Role.HR_BP)) {
            return applicationRepository.findByHrBpIdAndStatus(
                currentUser.getId(), ApplicationStatus.PENDING_HR_BP, pageable
            ).map(this::toDto);
        }

        if (currentUser.hasRole(Role.BORUP)) {
            return applicationRepository.findByBorupIdAndStatus(
                currentUser.getId(), ApplicationStatus.PENDING_BORUP, pageable
            ).map(this::toDto);
        }

        return Page.empty();
    }

    // === История ===

    public List<ApplicationHistoryDto> getHistory(Long applicationId) {
        findByIdWithAccessCheck(applicationId);
        return historyRepository.findByApplicationIdOrderByChangedAtDesc(applicationId)
            .stream()
            .map(this::toHistoryDto)
            .toList();
    }

    // === Статистика ===

    public ApplicationStatsDto getStats() {
        User currentUser = currentUserService.getCurrentUser();
        Long dzoId = currentUserService.getCurrentDzoId();

        if (currentUser.isSystemAdmin()) {
            dzoId = null;
        }

        Map<String, Long> byStatus = new HashMap<>();
        Map<String, Long> byStack = new HashMap<>();

        if (dzoId != null) {
            applicationRepository.countByStatusForDzo(dzoId)
                .forEach(row -> byStatus.put(((ApplicationStatus) row[0]).name(), (Long) row[1]));
            applicationRepository.countByStackForDzo(dzoId)
                .forEach(row -> byStack.put((String) row[0], (Long) row[1]));
        }

        long total = byStatus.values().stream().mapToLong(Long::longValue).sum();
        long inProgress = byStatus.getOrDefault("IN_PROGRESS", 0L) +
                         byStatus.getOrDefault("INTERVIEW", 0L);
        long pendingApproval = byStatus.getOrDefault("PENDING_HR_BP", 0L) +
                              byStatus.getOrDefault("PENDING_BORUP", 0L);
        long completed = byStatus.getOrDefault("TRANSFERRED", 0L) +
                        byStatus.getOrDefault("DISMISSED", 0L);

        return ApplicationStatsDto.builder()
            .byStatus(byStatus)
            .byStack(byStack)
            .total(total)
            .inProgress(inProgress)
            .pendingApproval(pendingApproval)
            .completed(completed)
            .build();
    }

    // === Назначение согласующих ===

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

    // === Вспомогательные методы ===

    private Application findByIdWithAccessCheck(Long id) {
        Application application = applicationRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Application not found: " + id));

        User currentUser = currentUserService.getCurrentUser();

        // Системный админ видит всё
        if (currentUser.isSystemAdmin()) {
            return application;
        }

        // Проверка доступа по ДЗО
        if (!roleService.canAccessDzo(currentUser, application.getDzo().getId())) {
            throw new AccessDeniedException("No access to this DZO");
        }

        return application;
    }

    private void recordHistory(Application application, ApplicationStatus oldStatus,
                              ApplicationStatus newStatus, String action, String comment) {
        User currentUser = currentUserService.getCurrentUser();

        ApplicationHistory history = ApplicationHistory.builder()
            .application(application)
            .changedBy(currentUser)
            .oldStatus(oldStatus)
            .newStatus(newStatus)
            .action(action)
            .comment(comment)
            .build();

        historyRepository.save(history);
    }

    private ApplicationDto toDto(Application a) {
        return ApplicationDto.builder()
            .id(a.getId())
            .dzoId(a.getDzo().getId())
            .dzoName(a.getDzo().getName())
            .employeeId(a.getEmployee().getId())
            .employeeName(a.getEmployee().getFullName())
            .employeeEmail(a.getEmployee().getEmail())
            .createdById(a.getCreatedBy().getId())
            .createdByName(a.getCreatedBy().getUsername())
            .createdAt(a.getCreatedAt())
            .updatedAt(a.getUpdatedAt())
            .status(a.getStatus().name())
            .statusDisplayName(a.getStatus().getDisplayName())
            .targetPosition(a.getTargetPosition())
            .targetStack(a.getTargetStack())
            .currentSalary(a.getCurrentSalary())
            .targetSalary(a.getTargetSalary())
            .salaryIncreasePercent(a.getSalaryIncreasePercent())
            .requiresBorupApproval(a.getRequiresBorupApproval())
            .resumeFilePath(a.getResumeFilePath())
            .comment(a.getComment())
            .recruiterId(a.getRecruiter() != null ? a.getRecruiter().getId() : null)
            .recruiterName(a.getRecruiter() != null ? a.getRecruiter().getUsername() : null)
            .assignedToRecruiterAt(a.getAssignedToRecruiterAt())
            .hrBpId(a.getHrBp() != null ? a.getHrBp().getId() : null)
            .hrBpName(a.getHrBp() != null ? a.getHrBp().getUsername() : null)
            .borupId(a.getBorup() != null ? a.getBorup().getId() : null)
            .borupName(a.getBorup() != null ? a.getBorup().getUsername() : null)
            .hrBpDecision(a.getHrBpDecision() != null ? a.getHrBpDecision().name() : null)
            .hrBpComment(a.getHrBpComment())
            .hrBpDecisionAt(a.getHrBpDecisionAt())
            .borupDecision(a.getBorupDecision() != null ? a.getBorupDecision().name() : null)
            .borupComment(a.getBorupComment())
            .borupDecisionAt(a.getBorupDecisionAt())
            .finalComment(a.getFinalComment())
            .transferDate(a.getTransferDate())
            .completedAt(a.getCompletedAt())
            .build();
    }

    private ApplicationHistoryDto toHistoryDto(ApplicationHistory h) {
        return ApplicationHistoryDto.builder()
            .id(h.getId())
            .applicationId(h.getApplication().getId())
            .changedById(h.getChangedBy().getId())
            .changedByName(h.getChangedBy().getUsername())
            .changedAt(h.getChangedAt())
            .oldStatus(h.getOldStatus() != null ? h.getOldStatus().name() : null)
            .newStatus(h.getNewStatus() != null ? h.getNewStatus().name() : null)
            .action(h.getAction())
            .comment(h.getComment())
            .build();
    }
}
