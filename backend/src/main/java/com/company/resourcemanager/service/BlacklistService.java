package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.blacklist.*;
import com.company.resourcemanager.entity.*;
import com.company.resourcemanager.exception.BusinessException;
import com.company.resourcemanager.exception.ResourceNotFoundException;
import com.company.resourcemanager.repository.BlacklistHistoryRepository;
import com.company.resourcemanager.repository.BlacklistRepository;
import com.company.resourcemanager.repository.EmployeeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class BlacklistService {

    private final BlacklistRepository blacklistRepository;
    private final BlacklistHistoryRepository historyRepository;
    private final EmployeeRepository employeeRepository;
    private final CurrentUserService currentUserService;
    private final RoleService roleService;

    // === CRUD ===

    public BlacklistEntryDto create(CreateBlacklistRequest request) {
        User currentUser = currentUserService.getCurrentUser();

        // Проверка роли
        if (!canManageBlacklist(currentUser)) {
            throw new AccessDeniedException("No permission to manage blacklist");
        }

        // Проверка категории
        BlacklistReasonCategory category;
        try {
            category = BlacklistReasonCategory.valueOf(request.getReasonCategory());
        } catch (IllegalArgumentException e) {
            throw new BusinessException("Invalid reason category: " + request.getReasonCategory());
        }

        // Связь с сотрудником (опционально)
        Employee employee = null;
        if (request.getEmployeeId() != null) {
            employee = employeeRepository.findById(request.getEmployeeId())
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found"));

            // Проверка — уже в ЧС?
            if (blacklistRepository.existsByEmployeeIdAndIsActiveTrue(request.getEmployeeId())) {
                throw new BusinessException("Employee is already in blacklist");
            }
        }

        // Проверка по email (если указан)
        if (request.getEmail() != null && !request.getEmail().isBlank()) {
            if (blacklistRepository.existsByEmailIgnoreCaseAndDzoIdAndIsActiveTrue(
                    request.getEmail(), currentUser.getDzo().getId())) {
                throw new BusinessException("Person with this email is already in blacklist");
            }
        }

        BlacklistEntry entry = BlacklistEntry.builder()
            .dzo(currentUser.getDzo())
            .employee(employee)
            .fullName(request.getFullName())
            .email(request.getEmail())
            .phone(request.getPhone())
            .reason(request.getReason())
            .reasonCategory(category)
            .source(request.getSource())
            .addedBy(currentUser)
            .expiresAt(request.getExpiresAt())
            .isActive(true)
            .build();

        entry = blacklistRepository.save(entry);

        recordHistory(entry, "ADD", "Добавлен в чёрный список: " + request.getReason());

        return toDto(entry);
    }

    public BlacklistEntryDto update(Long id, UpdateBlacklistRequest request) {
        BlacklistEntry entry = getEntryWithAccessCheck(id);
        User currentUser = currentUserService.getCurrentUser();

        if (!canManageBlacklist(currentUser)) {
            throw new AccessDeniedException("No permission to manage blacklist");
        }

        StringBuilder changes = new StringBuilder();

        if (request.getFullName() != null && !request.getFullName().equals(entry.getFullName())) {
            changes.append("ФИО: ").append(entry.getFullName()).append(" → ").append(request.getFullName()).append("; ");
            entry.setFullName(request.getFullName());
        }

        if (request.getEmail() != null && !request.getEmail().equals(entry.getEmail())) {
            changes.append("Email: ").append(entry.getEmail()).append(" → ").append(request.getEmail()).append("; ");
            entry.setEmail(request.getEmail());
        }

        if (request.getPhone() != null && !request.getPhone().equals(entry.getPhone())) {
            entry.setPhone(request.getPhone());
        }

        if (request.getReason() != null && !request.getReason().equals(entry.getReason())) {
            changes.append("Причина обновлена; ");
            entry.setReason(request.getReason());
        }

        if (request.getReasonCategory() != null) {
            BlacklistReasonCategory category = BlacklistReasonCategory.valueOf(request.getReasonCategory());
            if (category != entry.getReasonCategory()) {
                changes.append("Категория: ").append(entry.getReasonCategory()).append(" → ").append(category).append("; ");
                entry.setReasonCategory(category);
            }
        }

        if (request.getSource() != null) {
            entry.setSource(request.getSource());
        }

        if (request.getExpiresAt() != null) {
            entry.setExpiresAt(request.getExpiresAt());
        }

        entry = blacklistRepository.save(entry);

        if (changes.length() > 0) {
            recordHistory(entry, "UPDATE", changes.toString());
        }

        return toDto(entry);
    }

    public BlacklistEntryDto getById(Long id) {
        BlacklistEntry entry = getEntryWithAccessCheck(id);
        return toDto(entry);
    }

    @Transactional(readOnly = true)
    public Page<BlacklistEntryDto> getAll(Boolean isActive, String search,
                                          String reasonCategory, Pageable pageable) {
        User currentUser = currentUserService.getCurrentUser();
        Long dzoId = getDzoIdForUser(currentUser);

        Page<BlacklistEntry> page;

        if (search != null && !search.isBlank()) {
            // Полнотекстовый поиск
            page = blacklistRepository.searchFullText(dzoId,
                isActive != null ? isActive : true, search, pageable);
        } else if (reasonCategory != null && !reasonCategory.isBlank()) {
            // Фильтр по категории
            BlacklistReasonCategory category = BlacklistReasonCategory.valueOf(reasonCategory);
            page = blacklistRepository.findByDzoIdAndReasonCategoryAndIsActive(
                dzoId, category, isActive != null ? isActive : true, pageable);
        } else if (isActive != null) {
            page = blacklistRepository.findByDzoIdAndIsActive(dzoId, isActive, pageable);
        } else {
            page = blacklistRepository.findByDzoId(dzoId, pageable);
        }

        return page.map(this::toDto);
    }

    // === Снятие с ЧС ===

    public BlacklistEntryDto removeFromBlacklist(Long id, RemoveFromBlacklistRequest request) {
        BlacklistEntry entry = getEntryWithAccessCheck(id);
        User currentUser = currentUserService.getCurrentUser();

        if (!canManageBlacklist(currentUser)) {
            throw new AccessDeniedException("No permission to manage blacklist");
        }

        if (!entry.getIsActive()) {
            throw new BusinessException("Entry is already removed from blacklist");
        }

        entry.setIsActive(false);
        entry.setRemovedBy(currentUser);
        entry.setRemovedAt(LocalDateTime.now());
        entry.setRemovalReason(request.getReason());

        entry = blacklistRepository.save(entry);

        recordHistory(entry, "REMOVE", "Снят с чёрного списка: " + request.getReason());

        return toDto(entry);
    }

    // === Восстановление в ЧС ===

    public BlacklistEntryDto reactivate(Long id, String reason) {
        BlacklistEntry entry = getEntryWithAccessCheck(id);
        User currentUser = currentUserService.getCurrentUser();

        if (!canManageBlacklist(currentUser)) {
            throw new AccessDeniedException("No permission to manage blacklist");
        }

        if (entry.getIsActive()) {
            throw new BusinessException("Entry is already active");
        }

        entry.setIsActive(true);
        entry.setRemovedBy(null);
        entry.setRemovedAt(null);
        entry.setRemovalReason(null);

        entry = blacklistRepository.save(entry);

        recordHistory(entry, "REACTIVATE", reason != null ? reason : "Восстановлен в чёрном списке");

        return toDto(entry);
    }

    // === Проверка кандидата ===

    @Transactional(readOnly = true)
    public BlacklistCheckResult checkCandidate(Long employeeId, String email) {
        User currentUser = currentUserService.getCurrentUser();
        Long dzoId = getDzoIdForUser(currentUser);

        List<BlacklistEntry> entries = blacklistRepository.findActiveEntriesForEmployee(
            dzoId, employeeId, email, LocalDateTime.now());

        if (entries.isEmpty()) {
            return BlacklistCheckResult.builder()
                .inBlacklist(false)
                .entries(List.of())
                .message("Кандидат не найден в чёрном списке")
                .build();
        }

        return BlacklistCheckResult.builder()
            .inBlacklist(true)
            .entries(entries.stream().map(this::toDto).collect(Collectors.toList()))
            .message("ВНИМАНИЕ: Кандидат найден в чёрном списке!")
            .build();
    }

    // === Проверка сотрудника (для заявок) ===

    @Transactional(readOnly = true)
    public boolean isEmployeeInBlacklist(Long employeeId, Long dzoId) {
        Employee employee = employeeRepository.findById(employeeId).orElse(null);
        if (employee == null) return false;

        List<BlacklistEntry> entries = blacklistRepository.findActiveEntriesForEmployee(
            dzoId, employeeId, employee.getEmail(), LocalDateTime.now());

        return !entries.isEmpty();
    }

    // === История ===

    @Transactional(readOnly = true)
    public List<BlacklistHistoryDto> getHistory(Long id) {
        getEntryWithAccessCheck(id); // Проверка доступа

        return historyRepository.findByBlacklistEntryIdOrderByChangedAtDesc(id)
            .stream()
            .map(this::toHistoryDto)
            .collect(Collectors.toList());
    }

    // === Статистика ===

    @Transactional(readOnly = true)
    public BlacklistStatsDto getStats() {
        User currentUser = currentUserService.getCurrentUser();
        Long dzoId = getDzoIdForUser(currentUser);

        long totalActive = blacklistRepository.countByDzoIdAndIsActiveTrue(dzoId);

        Map<String, Long> byCategory = new HashMap<>();
        List<Object[]> categoryStats = blacklistRepository.countByReasonCategoryForDzo(dzoId);
        for (Object[] row : categoryStats) {
            BlacklistReasonCategory cat = (BlacklistReasonCategory) row[0];
            Long count = (Long) row[1];
            byCategory.put(cat.name(), count);
        }

        return BlacklistStatsDto.builder()
            .totalActive(totalActive)
            .totalInactive(0) // TODO: добавить подсчёт
            .byCategory(byCategory)
            .build();
    }

    // === Список категорий ===

    public List<Map<String, String>> getReasonCategories() {
        return java.util.Arrays.stream(BlacklistReasonCategory.values())
            .map(c -> Map.of(
                "code", c.name(),
                "displayName", c.getDisplayName(),
                "description", c.getDescription()
            ))
            .collect(Collectors.toList());
    }

    // === Автоматическое снятие истёкших записей (для scheduled task) ===

    public int deactivateExpiredEntries() {
        List<BlacklistEntry> expired = blacklistRepository.findExpiredEntries(LocalDateTime.now());

        for (BlacklistEntry entry : expired) {
            entry.setIsActive(false);
            entry.setRemovalReason("Автоматическое снятие по истечении срока");
            blacklistRepository.save(entry);
            recordHistory(entry, "REMOVE", "Автоматическое снятие по истечении срока действия");
        }

        return expired.size();
    }

    // === Вспомогательные методы ===

    private BlacklistEntry getEntryWithAccessCheck(Long id) {
        BlacklistEntry entry = blacklistRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Blacklist entry not found: " + id));

        User currentUser = currentUserService.getCurrentUser();
        if (!currentUser.isSystemAdmin() &&
            !roleService.canAccessDzo(currentUser, entry.getDzo().getId())) {
            throw new AccessDeniedException("No access to this blacklist entry");
        }

        return entry;
    }

    private boolean canManageBlacklist(User user) {
        return user.hasRole(Role.RECRUITER)
            || user.hasRole(Role.HR_BP)
            || user.hasRole(Role.DZO_ADMIN)
            || user.hasRole(Role.SYSTEM_ADMIN);
    }

    private Long getDzoIdForUser(User user) {
        if (user.isSystemAdmin()) {
            // TODO: для SYSTEM_ADMIN нужно передавать dzoId в параметрах
            return user.getDzo() != null ? user.getDzo().getId() : null;
        }
        return user.getDzo().getId();
    }

    private void recordHistory(BlacklistEntry entry, String action, String comment) {
        User currentUser = currentUserService.getCurrentUser();

        BlacklistHistory history = BlacklistHistory.builder()
            .blacklistEntry(entry)
            .changedBy(currentUser)
            .action(action)
            .comment(comment)
            .build();

        historyRepository.save(history);
    }

    private BlacklistEntryDto toDto(BlacklistEntry entry) {
        return BlacklistEntryDto.builder()
            .id(entry.getId())
            .dzoId(entry.getDzo().getId())
            .dzoName(entry.getDzo().getName())
            .employeeId(entry.getEmployee() != null ? entry.getEmployee().getId() : null)
            .employeeName(entry.getEmployee() != null ? entry.getEmployee().getFullName() : null)
            .fullName(entry.getFullName())
            .email(entry.getEmail())
            .phone(entry.getPhone())
            .reason(entry.getReason())
            .reasonCategory(entry.getReasonCategory().name())
            .reasonCategoryDisplayName(entry.getReasonCategory().getDisplayName())
            .source(entry.getSource())
            .isActive(entry.getIsActive())
            .addedById(entry.getAddedBy().getId())
            .addedByName(entry.getAddedBy().getUsername())
            .addedAt(entry.getAddedAt())
            .expiresAt(entry.getExpiresAt())
            .isExpired(entry.isExpired())
            .removedById(entry.getRemovedBy() != null ? entry.getRemovedBy().getId() : null)
            .removedByName(entry.getRemovedBy() != null ? entry.getRemovedBy().getUsername() : null)
            .removedAt(entry.getRemovedAt())
            .removalReason(entry.getRemovalReason())
            .createdAt(entry.getCreatedAt())
            .updatedAt(entry.getUpdatedAt())
            .build();
    }

    private BlacklistHistoryDto toHistoryDto(BlacklistHistory history) {
        return BlacklistHistoryDto.builder()
            .id(history.getId())
            .blacklistEntryId(history.getBlacklistEntry().getId())
            .changedById(history.getChangedBy().getId())
            .changedByName(history.getChangedBy().getUsername())
            .changedAt(history.getChangedAt())
            .action(history.getAction())
            .comment(history.getComment())
            .build();
    }
}
