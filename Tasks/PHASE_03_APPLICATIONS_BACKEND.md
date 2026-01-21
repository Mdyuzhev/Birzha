# Фаза 3: Заявки — Backend

## Цель

Создать backend-часть модуля заявок на развитие и ротацию сотрудников. Это основная сущность системы согласно ТЗ "Биржа талантов 3.0".

**Расположение проекта:** `E:\Birzha`

**Зависимости:** 
- Фаза 1 (Мультитенантность) ✅
- Фаза 2 (Ролевая модель) ✅

---

## Контекст из ТЗ

Заявка на развитие и ротацию проходит этапы:

| Этап | Исполнитель | Статусы |
|------|-------------|---------|
| Регистрация | Руководитель/HR BP | Свободен для рассмотрения |
| Обработка | Рекрутер | В работе, На собеседовании |
| Согласование HR BP | HR BP | Согласован/Отклонён HR BP |
| Согласование БОРУП | БОРУП (если >30% ЗП) | Согласован/Отклонён БОРУП |
| Итоговое решение | Рекрутер | Готовится к переводу, Переведён, Увольнение |

---

## Задачи

### 1. Создать enum ApplicationStatus

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/ApplicationStatus.java`

```java
public enum ApplicationStatus {
    // Начальный статус
    DRAFT("Черновик"),
    AVAILABLE_FOR_REVIEW("Свободен для рассмотрения"),
    
    // Обработка рекрутером
    IN_PROGRESS("В работе"),
    INTERVIEW("На собеседовании"),
    
    // Согласование HR BP
    PENDING_HR_BP("Ожидает согласования HR BP"),
    APPROVED_HR_BP("Согласован HR BP"),
    REJECTED_HR_BP("Отклонён HR BP"),
    
    // Согласование БОРУП
    PENDING_BORUP("Ожидает согласования БОРУП"),
    APPROVED_BORUP("Согласован БОРУП"),
    REJECTED_BORUP("Отклонён БОРУП"),
    
    // Итоговые статусы
    PREPARING_TRANSFER("Готовится к переводу"),
    TRANSFERRED("Переведён"),
    DISMISSED("Увольнение"),
    CANCELLED("Отменена");

    private final String displayName;

    ApplicationStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
    
    public boolean isFinal() {
        return this == TRANSFERRED || this == DISMISSED || this == CANCELLED;
    }
    
    public boolean isRejected() {
        return this == REJECTED_HR_BP || this == REJECTED_BORUP;
    }
}
```

### 2. Создать enum DecisionType

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/DecisionType.java`

```java
public enum DecisionType {
    PENDING("Ожидает решения"),
    APPROVED("Согласовано"),
    REJECTED("Отклонено");

    private final String displayName;

    DecisionType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
```

### 3. Создать entity Application

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/Application.java`

```java
@Entity
@Table(name = "applications")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Application {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Связь с ДЗО
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dzo_id", nullable = false)
    private Dzo dzo;

    // Кандидат на ротацию
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    // Кто создал заявку (Руководитель или HR BP)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by", nullable = false)
    private User createdBy;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    // Статус заявки
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private ApplicationStatus status;

    // Целевая позиция
    @Column(length = 255)
    private String targetPosition;

    // Целевой стек (справочник)
    @Column(length = 100)
    private String targetStack;

    // Текущая и целевая ЗП
    @Column(precision = 12, scale = 2)
    private BigDecimal currentSalary;

    @Column(precision = 12, scale = 2)
    private BigDecimal targetSalary;

    // Процент увеличения ЗП (вычисляемое поле)
    @Column(precision = 5, scale = 2)
    private BigDecimal salaryIncreasePercent;

    // Требуется ли согласование БОРУП (>30%)
    @Column(nullable = false)
    private Boolean requiresBorupApproval = false;

    // Прикреплённое резюме (путь к файлу или ID)
    @Column(length = 500)
    private String resumeFilePath;

    // Комментарий при создании
    @Column(columnDefinition = "TEXT")
    private String comment;

    // === Назначенные участники ===

    // Рекрутер, взявший заявку в работу
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recruiter_id")
    private User recruiter;

    private LocalDateTime assignedToRecruiterAt;

    // HR BP отдающей стороны
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hr_bp_id")
    private User hrBp;

    // БОРУП (если требуется)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "borup_id")
    private User borup;

    // === Решения согласующих ===

    // Решение HR BP
    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private DecisionType hrBpDecision;

    @Column(columnDefinition = "TEXT")
    private String hrBpComment;

    private LocalDateTime hrBpDecisionAt;

    // Решение БОРУП
    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private DecisionType borupDecision;

    @Column(columnDefinition = "TEXT")
    private String borupComment;

    private LocalDateTime borupDecisionAt;

    // === Итоговое решение ===

    @Column(columnDefinition = "TEXT")
    private String finalComment;

    private LocalDate transferDate;

    private LocalDateTime completedAt;

    // === Callbacks ===

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (status == null) {
            status = ApplicationStatus.DRAFT;
        }
        calculateSalaryIncrease();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
        calculateSalaryIncrease();
    }

    private void calculateSalaryIncrease() {
        if (currentSalary != null && targetSalary != null && 
            currentSalary.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal increase = targetSalary.subtract(currentSalary)
                .divide(currentSalary, 4, RoundingMode.HALF_UP)
                .multiply(new BigDecimal("100"));
            this.salaryIncreasePercent = increase.setScale(2, RoundingMode.HALF_UP);
            this.requiresBorupApproval = increase.compareTo(new BigDecimal("30")) > 0;
        }
    }
}
```

### 4. Создать entity ApplicationHistory

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/ApplicationHistory.java`

```java
@Entity
@Table(name = "application_history")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ApplicationHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "application_id", nullable = false)
    private Application application;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "changed_by", nullable = false)
    private User changedBy;

    @Column(nullable = false)
    private LocalDateTime changedAt;

    @Enumerated(EnumType.STRING)
    @Column(length = 50)
    private ApplicationStatus oldStatus;

    @Enumerated(EnumType.STRING)
    @Column(length = 50)
    private ApplicationStatus newStatus;

    @Column(length = 100)
    private String action;  // CREATE, STATUS_CHANGE, ASSIGN_RECRUITER, HR_BP_DECISION, etc.

    @Column(columnDefinition = "TEXT")
    private String comment;

    @Column(columnDefinition = "TEXT")
    private String details;  // JSON с дополнительными данными

    @PrePersist
    protected void onCreate() {
        changedAt = LocalDateTime.now();
    }
}
```

### 5. Создать Flyway миграцию для таблицы applications

**Файл:** `backend/src/main/resources/db/migration/V19__create_applications_table.sql`

```sql
-- Таблица заявок на развитие и ротацию
CREATE TABLE applications (
    id BIGSERIAL PRIMARY KEY,
    
    -- Связи
    dzo_id BIGINT NOT NULL REFERENCES dzos(id),
    employee_id BIGINT NOT NULL REFERENCES employees(id),
    created_by BIGINT NOT NULL REFERENCES users(id),
    
    -- Временные метки
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Статус
    status VARCHAR(50) NOT NULL DEFAULT 'DRAFT',
    
    -- Данные заявки
    target_position VARCHAR(255),
    target_stack VARCHAR(100),
    current_salary DECIMAL(12, 2),
    target_salary DECIMAL(12, 2),
    salary_increase_percent DECIMAL(5, 2),
    requires_borup_approval BOOLEAN NOT NULL DEFAULT false,
    resume_file_path VARCHAR(500),
    comment TEXT,
    
    -- Назначенные участники
    recruiter_id BIGINT REFERENCES users(id),
    assigned_to_recruiter_at TIMESTAMP,
    hr_bp_id BIGINT REFERENCES users(id),
    borup_id BIGINT REFERENCES users(id),
    
    -- Решение HR BP
    hr_bp_decision VARCHAR(20),
    hr_bp_comment TEXT,
    hr_bp_decision_at TIMESTAMP,
    
    -- Решение БОРУП
    borup_decision VARCHAR(20),
    borup_comment TEXT,
    borup_decision_at TIMESTAMP,
    
    -- Итог
    final_comment TEXT,
    transfer_date DATE,
    completed_at TIMESTAMP
);

-- Индексы
CREATE INDEX idx_applications_dzo ON applications(dzo_id);
CREATE INDEX idx_applications_employee ON applications(employee_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_applications_created_by ON applications(created_by);
CREATE INDEX idx_applications_recruiter ON applications(recruiter_id);
CREATE INDEX idx_applications_hr_bp ON applications(hr_bp_id);
CREATE INDEX idx_applications_created_at ON applications(created_at DESC);

-- Составной индекс для фильтрации
CREATE INDEX idx_applications_dzo_status ON applications(dzo_id, status);
```

### 6. Создать Flyway миграцию для таблицы application_history

**Файл:** `backend/src/main/resources/db/migration/V20__create_application_history_table.sql`

```sql
-- История изменений заявок
CREATE TABLE application_history (
    id BIGSERIAL PRIMARY KEY,
    application_id BIGINT NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    changed_by BIGINT NOT NULL REFERENCES users(id),
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    action VARCHAR(100) NOT NULL,
    comment TEXT,
    details TEXT  -- JSON
);

-- Индексы
CREATE INDEX idx_app_history_application ON application_history(application_id);
CREATE INDEX idx_app_history_changed_at ON application_history(changed_at DESC);
```

### 7. Создать ApplicationRepository

**Файл:** `backend/src/main/java/com/company/resourcemanager/repository/ApplicationRepository.java`

```java
public interface ApplicationRepository extends JpaRepository<Application, Long> {
    
    // По ДЗО
    Page<Application> findByDzoId(Long dzoId, Pageable pageable);
    List<Application> findByDzoId(Long dzoId);
    long countByDzoId(Long dzoId);
    
    // По статусу
    Page<Application> findByDzoIdAndStatus(Long dzoId, ApplicationStatus status, Pageable pageable);
    List<Application> findByDzoIdAndStatusIn(Long dzoId, List<ApplicationStatus> statuses);
    long countByDzoIdAndStatus(Long dzoId, ApplicationStatus status);
    
    // По сотруднику
    List<Application> findByEmployeeId(Long employeeId);
    Optional<Application> findByEmployeeIdAndStatusNotIn(Long employeeId, List<ApplicationStatus> finalStatuses);
    
    // По создателю (для Руководителя)
    Page<Application> findByCreatedById(Long userId, Pageable pageable);
    List<Application> findByCreatedByIdAndDzoId(Long userId, Long dzoId);
    
    // По рекрутеру
    Page<Application> findByRecruiterId(Long recruiterId, Pageable pageable);
    List<Application> findByRecruiterIdAndStatusIn(Long recruiterId, List<ApplicationStatus> statuses);
    
    // По HR BP
    Page<Application> findByHrBpIdAndStatus(Long hrBpId, ApplicationStatus status, Pageable pageable);
    List<Application> findByHrBpIdAndHrBpDecision(Long hrBpId, DecisionType decision);
    
    // По БОРУП
    Page<Application> findByBorupIdAndStatus(Long borupId, ApplicationStatus status, Pageable pageable);
    
    // Для дашборда
    @Query("SELECT a.status, COUNT(a) FROM Application a WHERE a.dzo.id = :dzoId GROUP BY a.status")
    List<Object[]> countByStatusForDzo(@Param("dzoId") Long dzoId);
    
    @Query("SELECT a.targetStack, COUNT(a) FROM Application a WHERE a.dzo.id = :dzoId GROUP BY a.targetStack")
    List<Object[]> countByStackForDzo(@Param("dzoId") Long dzoId);
    
    // Поиск
    @Query("SELECT a FROM Application a WHERE a.dzo.id = :dzoId AND " +
           "(LOWER(a.employee.fullName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(a.targetPosition) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(a.targetStack) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Application> searchByDzo(@Param("dzoId") Long dzoId, @Param("search") String search, Pageable pageable);
}
```

### 8. Создать ApplicationHistoryRepository

**Файл:** `backend/src/main/java/com/company/resourcemanager/repository/ApplicationHistoryRepository.java`

```java
public interface ApplicationHistoryRepository extends JpaRepository<ApplicationHistory, Long> {
    List<ApplicationHistory> findByApplicationIdOrderByChangedAtDesc(Long applicationId);
    List<ApplicationHistory> findByApplicationIdAndAction(Long applicationId, String action);
}
```

### 9. Создать DTO классы

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/ApplicationDto.java`

```java
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
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/CreateApplicationRequest.java`

```java
@Data
public class CreateApplicationRequest {
    @NotNull(message = "Employee ID is required")
    private Long employeeId;
    
    @Size(max = 255)
    private String targetPosition;
    
    @Size(max = 100)
    private String targetStack;
    
    @DecimalMin(value = "0.0")
    private BigDecimal currentSalary;
    
    @DecimalMin(value = "0.0")
    private BigDecimal targetSalary;
    
    private String comment;
    
    // Опционально: сразу назначить HR BP
    private Long hrBpId;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/UpdateApplicationRequest.java`

```java
@Data
public class UpdateApplicationRequest {
    @Size(max = 255)
    private String targetPosition;
    
    @Size(max = 100)
    private String targetStack;
    
    @DecimalMin(value = "0.0")
    private BigDecimal currentSalary;
    
    @DecimalMin(value = "0.0")
    private BigDecimal targetSalary;
    
    private String comment;
    
    private Long hrBpId;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/ApplicationHistoryDto.java`

```java
@Data
@Builder
public class ApplicationHistoryDto {
    private Long id;
    private Long applicationId;
    private Long changedById;
    private String changedByName;
    private LocalDateTime changedAt;
    private String oldStatus;
    private String newStatus;
    private String action;
    private String comment;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/ApplicationFilterRequest.java`

```java
@Data
public class ApplicationFilterRequest {
    private List<String> statuses;
    private String targetStack;
    private Long recruiterId;
    private Long hrBpId;
    private String search;
    private LocalDate createdFrom;
    private LocalDate createdTo;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/ApplicationStatsDto.java`

```java
@Data
@Builder
public class ApplicationStatsDto {
    private Map<String, Long> byStatus;
    private Map<String, Long> byStack;
    private Long total;
    private Long inProgress;
    private Long pendingApproval;
    private Long completed;
}
```

### 10. Создать ApplicationService

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/ApplicationService.java`

```java
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

    // === CRUD операции ===

    public ApplicationDto create(CreateApplicationRequest request) {
        User currentUser = currentUserService.getCurrentUser();
        
        // Проверка прав: только Руководитель или HR BP могут создавать заявки
        if (!currentUser.hasRole(Role.MANAGER) && !currentUser.hasRole(Role.HR_BP)) {
            throw new AccessDeniedException("Only MANAGER or HR_BP can create applications");
        }
        
        Employee employee = employeeRepository.findById(request.getEmployeeId())
            .orElseThrow(() -> new ResourceNotFoundException("Employee not found"));
        
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
                .forEach(row -> byStatus.put((String) row[0], (Long) row[1]));
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
```

### 11. Создать ApplicationController

**Файл:** `backend/src/main/java/com/company/resourcemanager/controller/ApplicationController.java`

```java
@RestController
@RequestMapping("/api/applications")
@RequiredArgsConstructor
public class ApplicationController {
    private final ApplicationService applicationService;

    @GetMapping
    public ResponseEntity<Page<ApplicationDto>> getAll(
            @RequestParam(required = false) List<String> statuses,
            @RequestParam(required = false) String targetStack,
            @RequestParam(required = false) Long recruiterId,
            @RequestParam(required = false) String search,
            @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable) {
        
        ApplicationFilterRequest filter = new ApplicationFilterRequest();
        filter.setStatuses(statuses);
        filter.setTargetStack(targetStack);
        filter.setRecruiterId(recruiterId);
        filter.setSearch(search);
        
        return ResponseEntity.ok(applicationService.getAll(filter, pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApplicationDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok(applicationService.getById(id));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('MANAGER', 'HR_BP')")
    public ResponseEntity<ApplicationDto> create(@Valid @RequestBody CreateApplicationRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(applicationService.create(request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApplicationDto> update(
            @PathVariable Long id, 
            @Valid @RequestBody UpdateApplicationRequest request) {
        return ResponseEntity.ok(applicationService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        applicationService.delete(id);
        return ResponseEntity.noContent().build();
    }

    // === Мои заявки ===

    @GetMapping("/my")
    @PreAuthorize("hasAnyRole('MANAGER', 'HR_BP')")
    public ResponseEntity<Page<ApplicationDto>> getMyApplications(
            @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable) {
        return ResponseEntity.ok(applicationService.getMyApplications(pageable));
    }

    @GetMapping("/assigned")
    @PreAuthorize("hasRole('RECRUITER')")
    public ResponseEntity<Page<ApplicationDto>> getAssignedToMe(
            @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable) {
        return ResponseEntity.ok(applicationService.getAssignedToMe(pageable));
    }

    @GetMapping("/pending-approval")
    @PreAuthorize("hasAnyRole('HR_BP', 'BORUP')")
    public ResponseEntity<Page<ApplicationDto>> getPendingMyApproval(
            @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable) {
        return ResponseEntity.ok(applicationService.getPendingMyApproval(pageable));
    }

    // === История ===

    @GetMapping("/{id}/history")
    public ResponseEntity<List<ApplicationHistoryDto>> getHistory(@PathVariable Long id) {
        return ResponseEntity.ok(applicationService.getHistory(id));
    }

    // === Статистика ===

    @GetMapping("/stats")
    @PreAuthorize("hasAnyRole('SYSTEM_ADMIN', 'DZO_ADMIN', 'RECRUITER')")
    public ResponseEntity<ApplicationStatsDto> getStats() {
        return ResponseEntity.ok(applicationService.getStats());
    }

    // === Статусы ===

    @GetMapping("/statuses")
    public ResponseEntity<List<Map<String, String>>> getStatuses() {
        List<Map<String, String>> statuses = Arrays.stream(ApplicationStatus.values())
            .map(s -> Map.of("code", s.name(), "displayName", s.getDisplayName()))
            .toList();
        return ResponseEntity.ok(statuses);
    }
}
```

### 12. Создать BusinessException

**Файл:** `backend/src/main/java/com/company/resourcemanager/exception/BusinessException.java`

```java
@ResponseStatus(HttpStatus.BAD_REQUEST)
public class BusinessException extends RuntimeException {
    public BusinessException(String message) {
        super(message);
    }
}
```

### 13. Обновить GlobalExceptionHandler

**Файл:** `backend/src/main/java/com/company/resourcemanager/exception/GlobalExceptionHandler.java`

Добавить обработку:

```java
@ExceptionHandler(BusinessException.class)
public ResponseEntity<ErrorResponse> handleBusinessException(BusinessException ex) {
    ErrorResponse error = new ErrorResponse(
        HttpStatus.BAD_REQUEST.value(),
        ex.getMessage(),
        LocalDateTime.now()
    );
    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
}

@ExceptionHandler(AccessDeniedException.class)
public ResponseEntity<ErrorResponse> handleAccessDeniedException(AccessDeniedException ex) {
    ErrorResponse error = new ErrorResponse(
        HttpStatus.FORBIDDEN.value(),
        ex.getMessage(),
        LocalDateTime.now()
    );
    return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error);
}
```

---

## Критерии приёмки

### Backend

- [ ] **Миграции применяются без ошибок**
  - `V19__create_applications_table.sql` создаёт таблицу `applications`
  - `V20__create_application_history_table.sql` создаёт таблицу `application_history`
  - Все индексы созданы

- [ ] **Entity Application содержит все поля**
  - Связи с Dzo, Employee, User (createdBy, recruiter, hrBp, borup)
  - Поля статуса, ЗП, решений
  - Автоматический расчёт salaryIncreasePercent и requiresBorupApproval

- [ ] **Enum ApplicationStatus содержит 14 статусов**
  - DRAFT, AVAILABLE_FOR_REVIEW, IN_PROGRESS, INTERVIEW
  - PENDING_HR_BP, APPROVED_HR_BP, REJECTED_HR_BP
  - PENDING_BORUP, APPROVED_BORUP, REJECTED_BORUP
  - PREPARING_TRANSFER, TRANSFERRED, DISMISSED, CANCELLED

- [ ] **CRUD API работает**
  - `POST /api/applications` — создание (MANAGER, HR_BP)
  - `GET /api/applications` — список с фильтрацией и пагинацией
  - `GET /api/applications/{id}` — одна заявка
  - `PUT /api/applications/{id}` — обновление (только DRAFT, AVAILABLE_FOR_REVIEW)
  - `DELETE /api/applications/{id}` — удаление (только DRAFT)

- [ ] **Специализированные эндпоинты работают**
  - `GET /api/applications/my` — мои заявки (MANAGER, HR_BP)
  - `GET /api/applications/assigned` — назначенные мне (RECRUITER)
  - `GET /api/applications/pending-approval` — ожидающие моего согласования (HR_BP, BORUP)
  - `GET /api/applications/{id}/history` — история изменений
  - `GET /api/applications/stats` — статистика
  - `GET /api/applications/statuses` — список статусов

- [ ] **Бизнес-правила соблюдаются**
  - Нельзя создать вторую активную заявку на сотрудника
  - Нельзя редактировать заявку не в статусе DRAFT/AVAILABLE_FOR_REVIEW
  - Нельзя удалить заявку не в статусе DRAFT
  - Автоматически определяется requiresBorupApproval при ЗП >30%

- [ ] **История записывается**
  - При создании записывается событие CREATE
  - При обновлении записывается событие UPDATE

- [ ] **Проверка доступа работает**
  - Пользователь видит только заявки своего ДЗО
  - SYSTEM_ADMIN видит все заявки

### Тестирование (curl)

```bash
# Создать заявку (от имени MANAGER)
curl -X POST http://localhost:31081/api/applications \
  -H "Authorization: Bearer $MANAGER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "employeeId": 1,
    "targetPosition": "Senior Developer",
    "targetStack": "Java",
    "currentSalary": 100000,
    "targetSalary": 150000,
    "comment": "Отличный кандидат"
  }'

# Ожидаемый ответ: заявка создана, status = AVAILABLE_FOR_REVIEW
# salaryIncreasePercent = 50.00, requiresBorupApproval = true

# Получить список заявок
curl -X GET "http://localhost:31081/api/applications?page=0&size=10" \
  -H "Authorization: Bearer $TOKEN"

# Получить заявку по ID
curl -X GET http://localhost:31081/api/applications/1 \
  -H "Authorization: Bearer $TOKEN"

# Получить историю заявки
curl -X GET http://localhost:31081/api/applications/1/history \
  -H "Authorization: Bearer $TOKEN"

# Получить статистику
curl -X GET http://localhost:31081/api/applications/stats \
  -H "Authorization: Bearer $ADMIN_TOKEN"

# Получить список статусов
curl -X GET http://localhost:31081/api/applications/statuses \
  -H "Authorization: Bearer $TOKEN"
```

---

## Файлы для создания/изменения

### Создать новые файлы:
```
backend/src/main/java/com/company/resourcemanager/entity/ApplicationStatus.java
backend/src/main/java/com/company/resourcemanager/entity/DecisionType.java
backend/src/main/java/com/company/resourcemanager/entity/Application.java
backend/src/main/java/com/company/resourcemanager/entity/ApplicationHistory.java
backend/src/main/java/com/company/resourcemanager/repository/ApplicationRepository.java
backend/src/main/java/com/company/resourcemanager/repository/ApplicationHistoryRepository.java
backend/src/main/java/com/company/resourcemanager/service/ApplicationService.java
backend/src/main/java/com/company/resourcemanager/controller/ApplicationController.java
backend/src/main/java/com/company/resourcemanager/dto/ApplicationDto.java
backend/src/main/java/com/company/resourcemanager/dto/CreateApplicationRequest.java
backend/src/main/java/com/company/resourcemanager/dto/UpdateApplicationRequest.java
backend/src/main/java/com/company/resourcemanager/dto/ApplicationHistoryDto.java
backend/src/main/java/com/company/resourcemanager/dto/ApplicationFilterRequest.java
backend/src/main/java/com/company/resourcemanager/dto/ApplicationStatsDto.java
backend/src/main/java/com/company/resourcemanager/exception/BusinessException.java
backend/src/main/resources/db/migration/V19__create_applications_table.sql
backend/src/main/resources/db/migration/V20__create_application_history_table.sql
```

### Изменить существующие файлы:
```
backend/src/main/java/com/company/resourcemanager/exception/GlobalExceptionHandler.java
```

---

## После завершения

1. Обновить статус Фазы 3 в `E:\Birzha\.claude\DEVELOPMENT_PLAN.md` на ✅ Завершено
2. Обновить `E:\Birzha\.claude\Project_map.md`:
   - Добавить описание entity Application, ApplicationHistory
   - Добавить API endpoints для /api/applications
   - Добавить описание ApplicationService
3. Перейти к Фазе 4 (Заявки — Workflow)
