# Фаза 6: Чёрный список кандидатов

## Цель

Реализовать модуль "Чёрный список" для ведения реестра кандидатов, которых не следует рассматривать для найма или перевода. Функционал включает добавление в ЧС, поиск, просмотр истории, снятие с ЧС.

**Расположение проекта:** `E:\Birzha`

**Зависимости:** 
- Фаза 1 (Мультитенантность) ✅
- Фаза 2 (Ролевая модель) ✅

---

## Бизнес-требования

### Согласно ТЗ "Биржа талантов 3.0"

1. **Назначение:** Централизованный реестр кандидатов с негативной историей
2. **Данные:** ФИО, контакты, причина, дата добавления, кто добавил
3. **Проверка:** При создании заявки система должна проверять наличие сотрудника в ЧС
4. **Доступ:** RECRUITER, HR_BP, DZO_ADMIN, SYSTEM_ADMIN
5. **Операции:** Добавление, поиск, просмотр, снятие с ЧС (с указанием причины)

### Use Cases

1. **Рекрутер добавляет кандидата в ЧС** после неудачного собеседования или негативного опыта
2. **При создании заявки** система автоматически проверяет, есть ли сотрудник в ЧС
3. **HR BP просматривает ЧС** для проверки кандидата перед согласованием
4. **Администратор снимает кандидата с ЧС** если обстоятельства изменились

---

## Задачи

### 1. Создать Entity BlacklistEntry

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/BlacklistEntry.java`

```java
package com.company.resourcemanager.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "blacklist", indexes = {
    @Index(name = "idx_blacklist_dzo", columnList = "dzo_id"),
    @Index(name = "idx_blacklist_email", columnList = "email"),
    @Index(name = "idx_blacklist_full_name", columnList = "full_name"),
    @Index(name = "idx_blacklist_is_active", columnList = "is_active"),
    @Index(name = "idx_blacklist_employee", columnList = "employee_id")
})
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BlacklistEntry {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dzo_id", nullable = false)
    private Dzo dzo;

    // Связь с сотрудником (опционально — может быть внешний кандидат)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "employee_id")
    private Employee employee;

    // ФИО (обязательно, даже если есть employee)
    @Column(name = "full_name", nullable = false)
    private String fullName;

    // Email (для поиска дубликатов)
    @Column(name = "email")
    private String email;

    // Телефон
    @Column(name = "phone")
    private String phone;

    // Причина добавления в ЧС (обязательно)
    @Column(name = "reason", nullable = false, columnDefinition = "TEXT")
    private String reason;

    // Категория причины
    @Enumerated(EnumType.STRING)
    @Column(name = "reason_category", nullable = false)
    private BlacklistReasonCategory reasonCategory;

    // Источник информации (откуда узнали о проблеме)
    @Column(name = "source")
    private String source;

    // Активен ли (false = снят с ЧС)
    @Column(name = "is_active", nullable = false)
    @Builder.Default
    private Boolean isActive = true;

    // Кто добавил
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "added_by", nullable = false)
    private User addedBy;

    // Когда добавлен
    @Column(name = "added_at", nullable = false)
    @Builder.Default
    private LocalDateTime addedAt = LocalDateTime.now();

    // Срок действия (null = бессрочно)
    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    // Кто снял с ЧС
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "removed_by")
    private User removedBy;

    // Когда снят
    @Column(name = "removed_at")
    private LocalDateTime removedAt;

    // Причина снятия
    @Column(name = "removal_reason")
    private String removalReason;

    // Дополнительные данные (JSON)
    @Column(name = "metadata", columnDefinition = "TEXT")
    private String metadata;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at", nullable = false)
    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    // Проверка истёк ли срок
    public boolean isExpired() {
        return expiresAt != null && LocalDateTime.now().isAfter(expiresAt);
    }

    // Эффективно активен (активен И не истёк)
    public boolean isEffectivelyActive() {
        return isActive && !isExpired();
    }
}
```

### 2. Создать Enum BlacklistReasonCategory

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/BlacklistReasonCategory.java`

```java
package com.company.resourcemanager.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum BlacklistReasonCategory {
    
    FRAUD("Мошенничество", "Подделка документов, обман"),
    THEFT("Кража", "Хищение имущества или данных"),
    CONFIDENTIALITY_BREACH("Разглашение информации", "Нарушение NDA, утечка данных"),
    MISCONDUCT("Грубое нарушение", "Нарушение трудовой дисциплины"),
    POOR_PERFORMANCE("Низкая эффективность", "Систематическое невыполнение обязанностей"),
    CONFLICT("Конфликтность", "Систематические конфликты с коллегами"),
    NO_SHOW("Неявка", "Не вышел на работу без уважительной причины"),
    FAKE_DOCUMENTS("Поддельные документы", "Предоставление ложных сведений"),
    CRIMINAL("Уголовное дело", "Привлечение к уголовной ответственности"),
    OTHER("Другое", "Иная причина");

    private final String displayName;
    private final String description;
}
```

### 3. Создать Entity BlacklistHistory

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/BlacklistHistory.java`

```java
package com.company.resourcemanager.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "blacklist_history", indexes = {
    @Index(name = "idx_blacklist_history_entry", columnList = "blacklist_entry_id"),
    @Index(name = "idx_blacklist_history_action", columnList = "action")
})
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BlacklistHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "blacklist_entry_id", nullable = false)
    private BlacklistEntry blacklistEntry;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "changed_by", nullable = false)
    private User changedBy;

    @Column(name = "changed_at", nullable = false)
    @Builder.Default
    private LocalDateTime changedAt = LocalDateTime.now();

    @Column(name = "action", nullable = false)
    private String action; // ADD, UPDATE, REMOVE, REACTIVATE

    @Column(name = "comment", columnDefinition = "TEXT")
    private String comment;

    @Column(name = "details", columnDefinition = "TEXT")
    private String details; // JSON с изменениями
}
```

### 4. Создать миграцию V21

**Файл:** `backend/src/main/resources/db/migration/V21__create_blacklist_table.sql`

```sql
-- Таблица чёрного списка
CREATE TABLE blacklist (
    id BIGSERIAL PRIMARY KEY,
    dzo_id BIGINT NOT NULL REFERENCES dzos(id) ON DELETE CASCADE,
    employee_id BIGINT REFERENCES employees(id) ON DELETE SET NULL,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    reason TEXT NOT NULL,
    reason_category VARCHAR(50) NOT NULL,
    source VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT true,
    added_by BIGINT NOT NULL REFERENCES users(id),
    added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    removed_by BIGINT REFERENCES users(id),
    removed_at TIMESTAMP,
    removal_reason TEXT,
    metadata TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Индексы
CREATE INDEX idx_blacklist_dzo ON blacklist(dzo_id);
CREATE INDEX idx_blacklist_email ON blacklist(email);
CREATE INDEX idx_blacklist_full_name ON blacklist(full_name);
CREATE INDEX idx_blacklist_is_active ON blacklist(is_active);
CREATE INDEX idx_blacklist_employee ON blacklist(employee_id);
CREATE INDEX idx_blacklist_reason_category ON blacklist(reason_category);
CREATE INDEX idx_blacklist_added_at ON blacklist(added_at);

-- Полнотекстовый поиск
CREATE INDEX idx_blacklist_fulltext ON blacklist 
    USING gin(to_tsvector('russian', full_name || ' ' || COALESCE(email, '') || ' ' || COALESCE(reason, '')));

COMMENT ON TABLE blacklist IS 'Чёрный список кандидатов';
COMMENT ON COLUMN blacklist.employee_id IS 'Ссылка на сотрудника (если есть в системе)';
COMMENT ON COLUMN blacklist.reason_category IS 'Категория причины: FRAUD, THEFT, MISCONDUCT и др.';
COMMENT ON COLUMN blacklist.expires_at IS 'Срок действия записи (NULL = бессрочно)';
```

### 5. Создать миграцию V22 для истории

**Файл:** `backend/src/main/resources/db/migration/V22__create_blacklist_history_table.sql`

```sql
-- История изменений чёрного списка
CREATE TABLE blacklist_history (
    id BIGSERIAL PRIMARY KEY,
    blacklist_entry_id BIGINT NOT NULL REFERENCES blacklist(id) ON DELETE CASCADE,
    changed_by BIGINT NOT NULL REFERENCES users(id),
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(50) NOT NULL,
    comment TEXT,
    details TEXT
);

CREATE INDEX idx_blacklist_history_entry ON blacklist_history(blacklist_entry_id);
CREATE INDEX idx_blacklist_history_action ON blacklist_history(action);
CREATE INDEX idx_blacklist_history_changed_at ON blacklist_history(changed_at);

COMMENT ON TABLE blacklist_history IS 'История изменений чёрного списка';
COMMENT ON COLUMN blacklist_history.action IS 'Действие: ADD, UPDATE, REMOVE, REACTIVATE';
```

### 6. Создать BlacklistRepository

**Файл:** `backend/src/main/java/com/company/resourcemanager/repository/BlacklistRepository.java`

```java
package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.BlacklistEntry;
import com.company.resourcemanager.entity.BlacklistReasonCategory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface BlacklistRepository extends JpaRepository<BlacklistEntry, Long> {

    // === Поиск по ДЗО ===
    
    Page<BlacklistEntry> findByDzoId(Long dzoId, Pageable pageable);
    
    Page<BlacklistEntry> findByDzoIdAndIsActive(Long dzoId, Boolean isActive, Pageable pageable);
    
    // === Поиск по сотруднику ===
    
    Optional<BlacklistEntry> findByEmployeeIdAndIsActiveTrue(Long employeeId);
    
    List<BlacklistEntry> findByEmployeeId(Long employeeId);
    
    boolean existsByEmployeeIdAndIsActiveTrue(Long employeeId);
    
    // === Поиск по email ===
    
    Optional<BlacklistEntry> findByEmailIgnoreCaseAndDzoIdAndIsActiveTrue(String email, Long dzoId);
    
    List<BlacklistEntry> findByEmailIgnoreCaseAndIsActiveTrue(String email);
    
    boolean existsByEmailIgnoreCaseAndDzoIdAndIsActiveTrue(String email, Long dzoId);
    
    // === Поиск по ФИО ===
    
    @Query("SELECT b FROM BlacklistEntry b WHERE b.dzo.id = :dzoId AND b.isActive = true " +
           "AND LOWER(b.fullName) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<BlacklistEntry> findByFullNameContainingAndDzoIdAndIsActiveTrue(
            @Param("name") String name, @Param("dzoId") Long dzoId);
    
    // === Полнотекстовый поиск ===
    
    @Query(value = "SELECT * FROM blacklist b WHERE b.dzo_id = :dzoId AND b.is_active = :isActive " +
           "AND to_tsvector('russian', b.full_name || ' ' || COALESCE(b.email, '') || ' ' || COALESCE(b.reason, '')) " +
           "@@ plainto_tsquery('russian', :search)",
           countQuery = "SELECT COUNT(*) FROM blacklist b WHERE b.dzo_id = :dzoId AND b.is_active = :isActive " +
           "AND to_tsvector('russian', b.full_name || ' ' || COALESCE(b.email, '') || ' ' || COALESCE(b.reason, '')) " +
           "@@ plainto_tsquery('russian', :search)",
           nativeQuery = true)
    Page<BlacklistEntry> searchFullText(@Param("dzoId") Long dzoId, 
                                        @Param("isActive") Boolean isActive,
                                        @Param("search") String search, 
                                        Pageable pageable);
    
    // === Фильтрация по категории ===
    
    Page<BlacklistEntry> findByDzoIdAndReasonCategoryAndIsActive(
            Long dzoId, BlacklistReasonCategory category, Boolean isActive, Pageable pageable);
    
    // === Истекшие записи ===
    
    @Query("SELECT b FROM BlacklistEntry b WHERE b.isActive = true AND b.expiresAt IS NOT NULL " +
           "AND b.expiresAt < :now")
    List<BlacklistEntry> findExpiredEntries(@Param("now") LocalDateTime now);
    
    // === Статистика ===
    
    @Query("SELECT b.reasonCategory, COUNT(b) FROM BlacklistEntry b " +
           "WHERE b.dzo.id = :dzoId AND b.isActive = true GROUP BY b.reasonCategory")
    List<Object[]> countByReasonCategoryForDzo(@Param("dzoId") Long dzoId);
    
    long countByDzoIdAndIsActiveTrue(Long dzoId);
    
    // === Проверка при создании заявки ===
    
    @Query("SELECT b FROM BlacklistEntry b WHERE b.dzo.id = :dzoId AND b.isActive = true " +
           "AND (b.expiresAt IS NULL OR b.expiresAt > :now) " +
           "AND (b.employee.id = :employeeId OR LOWER(b.email) = LOWER(:email))")
    List<BlacklistEntry> findActiveEntriesForEmployee(@Param("dzoId") Long dzoId,
                                                      @Param("employeeId") Long employeeId,
                                                      @Param("email") String email,
                                                      @Param("now") LocalDateTime now);
}
```

### 7. Создать BlacklistHistoryRepository

**Файл:** `backend/src/main/java/com/company/resourcemanager/repository/BlacklistHistoryRepository.java`

```java
package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.BlacklistHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BlacklistHistoryRepository extends JpaRepository<BlacklistHistory, Long> {

    List<BlacklistHistory> findByBlacklistEntryIdOrderByChangedAtDesc(Long blacklistEntryId);
    
    List<BlacklistHistory> findByBlacklistEntryIdAndAction(Long blacklistEntryId, String action);
}
```

### 8. Создать DTO

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/blacklist/BlacklistEntryDto.java`

```java
package com.company.resourcemanager.dto.blacklist;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Builder
public class BlacklistEntryDto {
    private Long id;
    private Long dzoId;
    private String dzoName;
    private Long employeeId;
    private String employeeName;
    private String fullName;
    private String email;
    private String phone;
    private String reason;
    private String reasonCategory;
    private String reasonCategoryDisplayName;
    private String source;
    private Boolean isActive;
    private Long addedById;
    private String addedByName;
    private LocalDateTime addedAt;
    private LocalDateTime expiresAt;
    private Boolean isExpired;
    private Long removedById;
    private String removedByName;
    private LocalDateTime removedAt;
    private String removalReason;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/blacklist/CreateBlacklistRequest.java`

```java
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
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/blacklist/UpdateBlacklistRequest.java`

```java
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
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/blacklist/RemoveFromBlacklistRequest.java`

```java
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
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/blacklist/BlacklistHistoryDto.java`

```java
package com.company.resourcemanager.dto.blacklist;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Builder
public class BlacklistHistoryDto {
    private Long id;
    private Long blacklistEntryId;
    private Long changedById;
    private String changedByName;
    private LocalDateTime changedAt;
    private String action;
    private String comment;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/blacklist/BlacklistCheckResult.java`

```java
package com.company.resourcemanager.dto.blacklist;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class BlacklistCheckResult {
    private boolean inBlacklist;
    private List<BlacklistEntryDto> entries;
    private String message;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/blacklist/BlacklistStatsDto.java`

```java
package com.company.resourcemanager.dto.blacklist;

import lombok.Builder;
import lombok.Data;
import java.util.Map;

@Data
@Builder
public class BlacklistStatsDto {
    private long totalActive;
    private long totalInactive;
    private Map<String, Long> byCategory;
}
```

### 9. Создать BlacklistService

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/BlacklistService.java`

```java
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
```

### 10. Создать BlacklistController

**Файл:** `backend/src/main/java/com/company/resourcemanager/controller/BlacklistController.java`

```java
package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.blacklist.*;
import com.company.resourcemanager.service.BlacklistService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/blacklist")
@RequiredArgsConstructor
public class BlacklistController {
    
    private final BlacklistService blacklistService;

    // === CRUD ===
    
    @GetMapping
    @PreAuthorize("hasAnyAuthority('RECRUITER', 'HR_BP', 'DZO_ADMIN', 'SYSTEM_ADMIN')")
    public ResponseEntity<Page<BlacklistEntryDto>> getAll(
            @RequestParam(required = false) Boolean isActive,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String reasonCategory,
            @PageableDefault(size = 20) Pageable pageable) {
        return ResponseEntity.ok(blacklistService.getAll(isActive, search, reasonCategory, pageable));
    }
    
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyAuthority('RECRUITER', 'HR_BP', 'DZO_ADMIN', 'SYSTEM_ADMIN')")
    public ResponseEntity<BlacklistEntryDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok(blacklistService.getById(id));
    }
    
    @PostMapping
    @PreAuthorize("hasAnyAuthority('RECRUITER', 'HR_BP', 'DZO_ADMIN', 'SYSTEM_ADMIN')")
    public ResponseEntity<BlacklistEntryDto> create(@Valid @RequestBody CreateBlacklistRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(blacklistService.create(request));
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("hasAnyAuthority('RECRUITER', 'HR_BP', 'DZO_ADMIN', 'SYSTEM_ADMIN')")
    public ResponseEntity<BlacklistEntryDto> update(
            @PathVariable Long id, 
            @Valid @RequestBody UpdateBlacklistRequest request) {
        return ResponseEntity.ok(blacklistService.update(id, request));
    }
    
    // === Снятие с ЧС ===
    
    @PostMapping("/{id}/remove")
    @PreAuthorize("hasAnyAuthority('RECRUITER', 'HR_BP', 'DZO_ADMIN', 'SYSTEM_ADMIN')")
    public ResponseEntity<BlacklistEntryDto> removeFromBlacklist(
            @PathVariable Long id,
            @Valid @RequestBody RemoveFromBlacklistRequest request) {
        return ResponseEntity.ok(blacklistService.removeFromBlacklist(id, request));
    }
    
    // === Восстановление в ЧС ===
    
    @PostMapping("/{id}/reactivate")
    @PreAuthorize("hasAnyAuthority('RECRUITER', 'HR_BP', 'DZO_ADMIN', 'SYSTEM_ADMIN')")
    public ResponseEntity<BlacklistEntryDto> reactivate(
            @PathVariable Long id,
            @RequestParam(required = false) String reason) {
        return ResponseEntity.ok(blacklistService.reactivate(id, reason));
    }
    
    // === Проверка кандидата ===
    
    @GetMapping("/check")
    @PreAuthorize("hasAnyAuthority('RECRUITER', 'HR_BP', 'MANAGER', 'DZO_ADMIN', 'SYSTEM_ADMIN')")
    public ResponseEntity<BlacklistCheckResult> checkCandidate(
            @RequestParam(required = false) Long employeeId,
            @RequestParam(required = false) String email) {
        return ResponseEntity.ok(blacklistService.checkCandidate(employeeId, email));
    }
    
    // === История ===
    
    @GetMapping("/{id}/history")
    @PreAuthorize("hasAnyAuthority('RECRUITER', 'HR_BP', 'DZO_ADMIN', 'SYSTEM_ADMIN')")
    public ResponseEntity<List<BlacklistHistoryDto>> getHistory(@PathVariable Long id) {
        return ResponseEntity.ok(blacklistService.getHistory(id));
    }
    
    // === Статистика ===
    
    @GetMapping("/stats")
    @PreAuthorize("hasAnyAuthority('RECRUITER', 'HR_BP', 'DZO_ADMIN', 'SYSTEM_ADMIN')")
    public ResponseEntity<BlacklistStatsDto> getStats() {
        return ResponseEntity.ok(blacklistService.getStats());
    }
    
    // === Справочник категорий ===
    
    @GetMapping("/categories")
    public ResponseEntity<List<Map<String, String>>> getReasonCategories() {
        return ResponseEntity.ok(blacklistService.getReasonCategories());
    }
}
```

### 11. Интеграция с модулем заявок

**Обновить:** `ApplicationService.java` — добавить проверку ЧС при создании заявки

```java
// В ApplicationService.create() добавить:

@Autowired
private BlacklistService blacklistService;

public ApplicationDto create(CreateApplicationRequest request) {
    User currentUser = currentUserService.getCurrentUser();
    
    // ... существующие проверки ...
    
    // НОВОЕ: Проверка чёрного списка
    if (blacklistService.isEmployeeInBlacklist(request.getEmployeeId(), currentUser.getDzo().getId())) {
        throw new BusinessException("Сотрудник находится в чёрном списке. Создание заявки невозможно.");
    }
    
    // ... остальной код создания ...
}
```

---

## Критерии приёмки

### Backend

- [ ] **Миграции применяются**
  - Таблица `blacklist` создана с индексами
  - Таблица `blacklist_history` создана
  - Полнотекстовый индекс работает

- [ ] **CRUD работает**
  - POST /api/blacklist — создание записи
  - GET /api/blacklist — список с фильтрацией
  - GET /api/blacklist/{id} — одна запись
  - PUT /api/blacklist/{id} — обновление

- [ ] **Workflow работает**
  - POST /{id}/remove — снятие с ЧС с указанием причины
  - POST /{id}/reactivate — восстановление в ЧС

- [ ] **Проверка кандидата работает**
  - GET /check?employeeId=X — проверка по ID сотрудника
  - GET /check?email=X — проверка по email
  - Возвращает флаг inBlacklist и список записей

- [ ] **История записывается**
  - ADD при создании
  - UPDATE при изменении
  - REMOVE при снятии
  - REACTIVATE при восстановлении

- [ ] **Интеграция с заявками**
  - При создании заявки проверяется ЧС
  - Если сотрудник в ЧС — ошибка 400

- [ ] **Права доступа**
  - RECRUITER, HR_BP, DZO_ADMIN, SYSTEM_ADMIN могут управлять
  - MANAGER может только проверять (/check)
  - Данные фильтруются по ДЗО

### Тестирование (curl)

```bash
# Получить токен
TOKEN=$(curl -s -X POST http://localhost:31081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | jq -r '.token')

# Получить список категорий
curl -X GET http://localhost:31081/api/blacklist/categories \
  -H "Authorization: Bearer $TOKEN"

# Добавить в ЧС
curl -X POST http://localhost:31081/api/blacklist \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Иванов Иван Иванович",
    "email": "ivanov@example.com",
    "phone": "+7 999 123-45-67",
    "reason": "Не вышел на работу без предупреждения, не выходил на связь 2 недели",
    "reasonCategory": "NO_SHOW",
    "source": "Отдел разработки"
  }'

# Получить список
curl -X GET "http://localhost:31081/api/blacklist?isActive=true" \
  -H "Authorization: Bearer $TOKEN"

# Поиск
curl -X GET "http://localhost:31081/api/blacklist?search=Иванов" \
  -H "Authorization: Bearer $TOKEN"

# Проверить кандидата
curl -X GET "http://localhost:31081/api/blacklist/check?email=ivanov@example.com" \
  -H "Authorization: Bearer $TOKEN"

# Снять с ЧС
curl -X POST http://localhost:31081/api/blacklist/1/remove \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"reason": "Ошибочное добавление, ситуация прояснилась"}'

# История
curl -X GET http://localhost:31081/api/blacklist/1/history \
  -H "Authorization: Bearer $TOKEN"

# Статистика
curl -X GET http://localhost:31081/api/blacklist/stats \
  -H "Authorization: Bearer $TOKEN"
```

---

## Файлы для создания

```
backend/src/main/java/com/company/resourcemanager/entity/BlacklistEntry.java
backend/src/main/java/com/company/resourcemanager/entity/BlacklistReasonCategory.java
backend/src/main/java/com/company/resourcemanager/entity/BlacklistHistory.java
backend/src/main/java/com/company/resourcemanager/repository/BlacklistRepository.java
backend/src/main/java/com/company/resourcemanager/repository/BlacklistHistoryRepository.java
backend/src/main/java/com/company/resourcemanager/dto/blacklist/BlacklistEntryDto.java
backend/src/main/java/com/company/resourcemanager/dto/blacklist/CreateBlacklistRequest.java
backend/src/main/java/com/company/resourcemanager/dto/blacklist/UpdateBlacklistRequest.java
backend/src/main/java/com/company/resourcemanager/dto/blacklist/RemoveFromBlacklistRequest.java
backend/src/main/java/com/company/resourcemanager/dto/blacklist/BlacklistHistoryDto.java
backend/src/main/java/com/company/resourcemanager/dto/blacklist/BlacklistCheckResult.java
backend/src/main/java/com/company/resourcemanager/dto/blacklist/BlacklistStatsDto.java
backend/src/main/java/com/company/resourcemanager/service/BlacklistService.java
backend/src/main/java/com/company/resourcemanager/controller/BlacklistController.java
backend/src/main/resources/db/migration/V21__create_blacklist_table.sql
backend/src/main/resources/db/migration/V22__create_blacklist_history_table.sql
```

## Файлы для изменения

```
backend/src/main/java/com/company/resourcemanager/service/ApplicationService.java
  — добавить проверку ЧС при создании заявки
```

---

## После завершения

1. Обновить статус Фазы 6 в `E:\Birzha\.claude\DEVELOPMENT_PLAN.md` на ✅ Завершено
2. Обновить `E:\Birzha\.claude\Project_map.md`:
   - Добавить описание BlacklistEntry, BlacklistHistory
   - Добавить API endpoints /api/blacklist
   - Добавить миграции V21, V22
3. Перейти к Фазе 7 (Справочник стеков) или Фазе 6.1 (Blacklist Frontend)
