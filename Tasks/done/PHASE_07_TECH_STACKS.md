# Фаза 7: Справочник технологических стеков

## Цель

Реализовать справочник технологических стеков с иерархией (Направление → Стек) и workflow добавления новых стеков через согласование.

**Расположение проекта:** `E:\Birzha`

---

## Бизнес-требования

1. **Иерархия**: Направление (Backend, Frontend, Mobile...) → Стеки (Java, Python, React...)
2. **Workflow**: Предложение стека → Согласование админом → Публикация
3. **Использование**: При создании заявки выбирается целевой стек
4. **Статусы стеков**: PENDING, ACTIVE, DEPRECATED, REJECTED

---

## Задачи

### 1. Миграция V23 — таблицы

**Файл:** `backend/src/main/resources/db/migration/V23__create_tech_stacks_tables.sql`

```sql
-- Направления (категории)
CREATE TABLE tech_directions (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon VARCHAR(50),
    color VARCHAR(20),
    sort_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Стеки
CREATE TABLE tech_stacks (
    id BIGSERIAL PRIMARY KEY,
    direction_id BIGINT NOT NULL REFERENCES tech_directions(id) ON DELETE CASCADE,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    technologies JSONB DEFAULT '[]'::jsonb,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    sort_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_by BIGINT REFERENCES users(id),
    approved_by BIGINT REFERENCES users(id),
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(direction_id, code)
);

CREATE INDEX idx_tech_directions_code ON tech_directions(code);
CREATE INDEX idx_tech_stacks_direction ON tech_stacks(direction_id);
CREATE INDEX idx_tech_stacks_status ON tech_stacks(status);
CREATE INDEX idx_tech_stacks_code ON tech_stacks(code);
```

### 2. Миграция V24 — начальные данные

**Файл:** `backend/src/main/resources/db/migration/V24__seed_tech_stacks.sql`

```sql
-- Направления
INSERT INTO tech_directions (code, name, icon, color, sort_order) VALUES
('BACKEND', 'Backend', 'server', '#3498db', 1),
('FRONTEND', 'Frontend', 'monitor', '#e74c3c', 2),
('MOBILE', 'Mobile', 'smartphone', '#9b59b6', 3),
('DEVOPS', 'DevOps', 'cloud', '#1abc9c', 4),
('DATA', 'Data & Analytics', 'database', '#f39c12', 5),
('QA', 'QA', 'check-circle', '#2ecc71', 6),
('MANAGEMENT', 'Management', 'users', '#34495e', 7);

-- Backend стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='BACKEND'), 'JAVA', 'Java', '["Spring Boot","Hibernate","Kafka"]', 1),
((SELECT id FROM tech_directions WHERE code='BACKEND'), 'PYTHON', 'Python', '["Django","FastAPI","Celery"]', 2),
((SELECT id FROM tech_directions WHERE code='BACKEND'), 'DOTNET', '.NET', '["ASP.NET Core","Entity Framework"]', 3),
((SELECT id FROM tech_directions WHERE code='BACKEND'), 'GO', 'Go', '["Gin","GORM","gRPC"]', 4),
((SELECT id FROM tech_directions WHERE code='BACKEND'), 'NODEJS', 'Node.js', '["Express","NestJS","TypeORM"]', 5);

-- Frontend стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='FRONTEND'), 'REACT', 'React', '["Redux","Next.js","TypeScript"]', 1),
((SELECT id FROM tech_directions WHERE code='FRONTEND'), 'VUE', 'Vue.js', '["Vuex","Pinia","Nuxt.js"]', 2),
((SELECT id FROM tech_directions WHERE code='FRONTEND'), 'ANGULAR', 'Angular', '["RxJS","NgRx","TypeScript"]', 3);

-- Mobile стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='MOBILE'), 'IOS', 'iOS', '["Swift","UIKit","SwiftUI"]', 1),
((SELECT id FROM tech_directions WHERE code='MOBILE'), 'ANDROID', 'Android', '["Kotlin","Jetpack Compose"]', 2),
((SELECT id FROM tech_directions WHERE code='MOBILE'), 'FLUTTER', 'Flutter', '["Dart","BLoC"]', 3);

-- DevOps стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='DEVOPS'), 'KUBERNETES', 'Kubernetes', '["Helm","ArgoCD","Istio"]', 1),
((SELECT id FROM tech_directions WHERE code='DEVOPS'), 'AWS', 'AWS', '["EC2","EKS","Lambda","S3"]', 2),
((SELECT id FROM tech_directions WHERE code='DEVOPS'), 'CICD', 'CI/CD', '["GitLab CI","Jenkins","GitHub Actions"]', 3);

-- Data стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='DATA'), 'DATA_ENGINEERING', 'Data Engineering', '["Spark","Airflow","Kafka"]', 1),
((SELECT id FROM tech_directions WHERE code='DATA'), 'DATA_SCIENCE', 'Data Science', '["Python","TensorFlow","PyTorch"]', 2),
((SELECT id FROM tech_directions WHERE code='DATA'), 'ANALYTICS', 'Analytics', '["SQL","Tableau","Power BI"]', 3);

-- QA стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='QA'), 'QA_MANUAL', 'Manual QA', '["Jira","TestRail","Postman"]', 1),
((SELECT id FROM tech_directions WHERE code='QA'), 'QA_AUTO', 'Automation QA', '["Selenium","Cypress","Playwright"]', 2);

-- Management стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='MANAGEMENT'), 'PM', 'Project Management', '["Jira","MS Project","Agile"]', 1),
((SELECT id FROM tech_directions WHERE code='MANAGEMENT'), 'PRODUCT', 'Product Management', '["Miro","Figma","Analytics"]', 2),
((SELECT id FROM tech_directions WHERE code='MANAGEMENT'), 'TEAMLEAD', 'Team Lead', '["1-on-1","Code Review","Mentoring"]', 3);
```

### 3. Entity TechDirection

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/TechDirection.java`

```java
package com.company.resourcemanager.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "tech_directions")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TechDirection {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "code", nullable = false, unique = true)
    private String code;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "description")
    private String description;

    @Column(name = "icon")
    private String icon;

    @Column(name = "color")
    private String color;

    @Column(name = "sort_order")
    @Builder.Default
    private Integer sortOrder = 0;

    @Column(name = "is_active")
    @Builder.Default
    private Boolean isActive = true;

    @OneToMany(mappedBy = "direction", fetch = FetchType.LAZY)
    @Builder.Default
    private List<TechStack> stacks = new ArrayList<>();

    @Column(name = "created_at", updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
```

### 4. Entity TechStack

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/TechStack.java`

```java
package com.company.resourcemanager.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "tech_stacks")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TechStack {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "direction_id", nullable = false)
    private TechDirection direction;

    @Column(name = "code", nullable = false)
    private String code;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "description")
    private String description;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "technologies", columnDefinition = "jsonb")
    private List<String> technologies;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    @Builder.Default
    private TechStackStatus status = TechStackStatus.ACTIVE;

    @Column(name = "sort_order")
    @Builder.Default
    private Integer sortOrder = 0;

    @Column(name = "is_active")
    @Builder.Default
    private Boolean isActive = true;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private User createdBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "approved_by")
    private User approvedBy;

    @Column(name = "approved_at")
    private LocalDateTime approvedAt;

    @Column(name = "rejection_reason")
    private String rejectionReason;

    @Column(name = "created_at", updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
```

### 5. Enum TechStackStatus

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/TechStackStatus.java`

```java
package com.company.resourcemanager.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum TechStackStatus {
    PROPOSED("Предложен"),
    ACTIVE("Активен"),
    DEPRECATED("Устаревший"),
    REJECTED("Отклонён");

    private final String displayName;
}
```

### 6. TechDirectionRepository

**Файл:** `backend/src/main/java/com/company/resourcemanager/repository/TechDirectionRepository.java`

```java
package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.TechDirection;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface TechDirectionRepository extends JpaRepository<TechDirection, Long> {
    Optional<TechDirection> findByCode(String code);
    List<TechDirection> findByIsActiveTrueOrderBySortOrderAsc();
}
```

### 7. TechStackRepository

**Файл:** `backend/src/main/java/com/company/resourcemanager/repository/TechStackRepository.java`

```java
package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.TechStack;
import com.company.resourcemanager.entity.TechStackStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;
import java.util.Optional;

public interface TechStackRepository extends JpaRepository<TechStack, Long> {
    
    List<TechStack> findByDirectionIdAndIsActiveTrueOrderBySortOrderAsc(Long directionId);
    
    List<TechStack> findByStatusAndIsActiveTrueOrderByDirectionSortOrderAscSortOrderAsc(TechStackStatus status);
    
    List<TechStack> findByStatusOrderByCreatedAtDesc(TechStackStatus status);
    
    Optional<TechStack> findByCode(String code);
    
    boolean existsByDirectionIdAndCode(Long directionId, String code);
    
    @Query("SELECT s FROM TechStack s WHERE s.status = 'ACTIVE' AND s.isActive = true " +
           "AND (LOWER(s.name) LIKE LOWER(CONCAT('%', :q, '%')) OR LOWER(s.code) LIKE LOWER(CONCAT('%', :q, '%')))")
    List<TechStack> search(String q);
    
    long countByStatus(TechStackStatus status);
}
```

### 8. DTO

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/techstack/TechDirectionDto.java`

```java
package com.company.resourcemanager.dto.techstack;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class TechDirectionDto {
    private Long id;
    private String code;
    private String name;
    private String description;
    private String icon;
    private String color;
    private Integer sortOrder;
    private List<TechStackDto> stacks;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/techstack/TechStackDto.java`

```java
package com.company.resourcemanager.dto.techstack;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class TechStackDto {
    private Long id;
    private Long directionId;
    private String directionCode;
    private String directionName;
    private String code;
    private String name;
    private String description;
    private List<String> technologies;
    private String status;
    private String statusDisplayName;
    private Integer sortOrder;
    private Long createdById;
    private String createdByName;
    private LocalDateTime createdAt;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/techstack/CreateTechStackRequest.java`

```java
package com.company.resourcemanager.dto.techstack;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.util.List;

@Data
public class CreateTechStackRequest {
    @NotNull
    private Long directionId;
    @NotBlank
    private String code;
    @NotBlank
    private String name;
    private String description;
    private List<String> technologies;
    private Integer sortOrder;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/techstack/ProposeStackRequest.java`

```java
package com.company.resourcemanager.dto.techstack;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.util.List;

@Data
public class ProposeStackRequest {
    @NotNull
    private Long directionId;
    @NotBlank
    private String name;
    @NotBlank
    private String justification;
    private List<String> technologies;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/techstack/RejectStackRequest.java`

```java
package com.company.resourcemanager.dto.techstack;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RejectStackRequest {
    @NotBlank
    private String reason;
}
```

### 9. TechStackService

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/TechStackService.java`

```java
package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.techstack.*;
import com.company.resourcemanager.entity.*;
import com.company.resourcemanager.exception.BusinessException;
import com.company.resourcemanager.exception.ResourceNotFoundException;
import com.company.resourcemanager.repository.TechDirectionRepository;
import com.company.resourcemanager.repository.TechStackRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class TechStackService {
    
    private final TechDirectionRepository directionRepository;
    private final TechStackRepository stackRepository;
    private final CurrentUserService currentUserService;

    // === DIRECTIONS ===
    
    @Transactional(readOnly = true)
    public List<TechDirectionDto> getAllDirections(boolean includeStacks) {
        List<TechDirection> directions = directionRepository.findByIsActiveTrueOrderBySortOrderAsc();
        return directions.stream()
            .map(d -> toDirectionDto(d, includeStacks))
            .collect(Collectors.toList());
    }

    // === STACKS READ ===
    
    @Transactional(readOnly = true)
    public List<TechStackDto> getSelectableStacks() {
        return stackRepository.findByStatusAndIsActiveTrueOrderByDirectionSortOrderAscSortOrderAsc(TechStackStatus.ACTIVE)
            .stream().map(this::toStackDto).collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public List<TechStackDto> getStacksByDirection(Long directionId) {
        return stackRepository.findByDirectionIdAndIsActiveTrueOrderBySortOrderAsc(directionId)
            .stream().map(this::toStackDto).collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public TechStackDto getStackById(Long id) {
        TechStack stack = stackRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Stack not found"));
        return toStackDto(stack);
    }
    
    @Transactional(readOnly = true)
    public List<TechStackDto> search(String q) {
        return stackRepository.search(q).stream().map(this::toStackDto).collect(Collectors.toList());
    }

    // === ADMIN CRUD ===
    
    public TechStackDto createStack(CreateTechStackRequest request) {
        checkAdmin();
        
        TechDirection direction = directionRepository.findById(request.getDirectionId())
            .orElseThrow(() -> new ResourceNotFoundException("Direction not found"));
        
        if (stackRepository.existsByDirectionIdAndCode(direction.getId(), request.getCode().toUpperCase())) {
            throw new BusinessException("Stack with this code already exists");
        }
        
        TechStack stack = TechStack.builder()
            .direction(direction)
            .code(request.getCode().toUpperCase())
            .name(request.getName())
            .description(request.getDescription())
            .technologies(request.getTechnologies())
            .sortOrder(request.getSortOrder() != null ? request.getSortOrder() : 0)
            .status(TechStackStatus.ACTIVE)
            .createdBy(currentUserService.getCurrentUser())
            .approvedBy(currentUserService.getCurrentUser())
            .approvedAt(LocalDateTime.now())
            .build();
        
        return toStackDto(stackRepository.save(stack));
    }

    // === WORKFLOW ===
    
    public TechStackDto proposeStack(ProposeStackRequest request) {
        TechDirection direction = directionRepository.findById(request.getDirectionId())
            .orElseThrow(() -> new ResourceNotFoundException("Direction not found"));
        
        String tempCode = "PROP_" + System.currentTimeMillis();
        
        TechStack stack = TechStack.builder()
            .direction(direction)
            .code(tempCode)
            .name(request.getName())
            .description(request.getJustification())
            .technologies(request.getTechnologies())
            .status(TechStackStatus.PROPOSED)
            .createdBy(currentUserService.getCurrentUser())
            .build();
        
        return toStackDto(stackRepository.save(stack));
    }
    
    @Transactional(readOnly = true)
    public List<TechStackDto> getPendingStacks() {
        return stackRepository.findByStatusOrderByCreatedAtDesc(TechStackStatus.PROPOSED)
            .stream().map(this::toStackDto).collect(Collectors.toList());
    }
    
    public TechStackDto approveStack(Long id, String code) {
        checkAdmin();
        
        TechStack stack = stackRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Stack not found"));
        
        if (stack.getStatus() != TechStackStatus.PROPOSED) {
            throw new BusinessException("Only proposed stacks can be approved");
        }
        
        String finalCode = (code != null && !code.isBlank()) ? code.toUpperCase() : generateCode(stack.getName());
        
        if (stackRepository.existsByDirectionIdAndCode(stack.getDirection().getId(), finalCode)) {
            throw new BusinessException("Stack with code " + finalCode + " already exists");
        }
        
        stack.setCode(finalCode);
        stack.setStatus(TechStackStatus.ACTIVE);
        stack.setApprovedBy(currentUserService.getCurrentUser());
        stack.setApprovedAt(LocalDateTime.now());
        
        return toStackDto(stackRepository.save(stack));
    }
    
    public TechStackDto rejectStack(Long id, RejectStackRequest request) {
        checkAdmin();
        
        TechStack stack = stackRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Stack not found"));
        
        if (stack.getStatus() != TechStackStatus.PROPOSED) {
            throw new BusinessException("Only proposed stacks can be rejected");
        }
        
        stack.setStatus(TechStackStatus.REJECTED);
        stack.setRejectionReason(request.getReason());
        stack.setIsActive(false);
        
        return toStackDto(stackRepository.save(stack));
    }
    
    public TechStackDto deprecateStack(Long id) {
        checkAdmin();
        
        TechStack stack = stackRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Stack not found"));
        
        stack.setStatus(TechStackStatus.DEPRECATED);
        return toStackDto(stackRepository.save(stack));
    }

    // === HELPERS ===
    
    private void checkAdmin() {
        User user = currentUserService.getCurrentUser();
        if (!user.hasRole(Role.SYSTEM_ADMIN) && !user.hasRole(Role.DZO_ADMIN)) {
            throw new AccessDeniedException("Admin access required");
        }
    }
    
    private String generateCode(String name) {
        return name.toUpperCase().replaceAll("[^A-Z0-9]", "_").replaceAll("_+", "_");
    }
    
    private TechDirectionDto toDirectionDto(TechDirection d, boolean includeStacks) {
        TechDirectionDto.TechDirectionDtoBuilder builder = TechDirectionDto.builder()
            .id(d.getId())
            .code(d.getCode())
            .name(d.getName())
            .description(d.getDescription())
            .icon(d.getIcon())
            .color(d.getColor())
            .sortOrder(d.getSortOrder());
        
        if (includeStacks) {
            List<TechStack> stacks = stackRepository.findByDirectionIdAndIsActiveTrueOrderBySortOrderAsc(d.getId());
            builder.stacks(stacks.stream()
                .filter(s -> s.getStatus() == TechStackStatus.ACTIVE)
                .map(this::toStackDto)
                .collect(Collectors.toList()));
        }
        return builder.build();
    }
    
    private TechStackDto toStackDto(TechStack s) {
        return TechStackDto.builder()
            .id(s.getId())
            .directionId(s.getDirection().getId())
            .directionCode(s.getDirection().getCode())
            .directionName(s.getDirection().getName())
            .code(s.getCode())
            .name(s.getName())
            .description(s.getDescription())
            .technologies(s.getTechnologies())
            .status(s.getStatus().name())
            .statusDisplayName(s.getStatus().getDisplayName())
            .sortOrder(s.getSortOrder())
            .createdById(s.getCreatedBy() != null ? s.getCreatedBy().getId() : null)
            .createdByName(s.getCreatedBy() != null ? s.getCreatedBy().getUsername() : null)
            .createdAt(s.getCreatedAt())
            .build();
    }
}
```

### 10. TechStackController

**Файл:** `backend/src/main/java/com/company/resourcemanager/controller/TechStackController.java`

```java
package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.techstack.*;
import com.company.resourcemanager.service.TechStackService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tech-stacks")
@RequiredArgsConstructor
public class TechStackController {
    
    private final TechStackService service;

    // === READ (все пользователи) ===
    
    @GetMapping("/directions")
    public ResponseEntity<List<TechDirectionDto>> getDirections(
            @RequestParam(defaultValue = "true") boolean includeStacks) {
        return ResponseEntity.ok(service.getAllDirections(includeStacks));
    }
    
    @GetMapping
    public ResponseEntity<List<TechStackDto>> getSelectableStacks() {
        return ResponseEntity.ok(service.getSelectableStacks());
    }
    
    @GetMapping("/by-direction/{directionId}")
    public ResponseEntity<List<TechStackDto>> getByDirection(@PathVariable Long directionId) {
        return ResponseEntity.ok(service.getStacksByDirection(directionId));
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<TechStackDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok(service.getStackById(id));
    }
    
    @GetMapping("/search")
    public ResponseEntity<List<TechStackDto>> search(@RequestParam String q) {
        return ResponseEntity.ok(service.search(q));
    }

    // === ADMIN CRUD ===
    
    @PostMapping
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN')")
    public ResponseEntity<TechStackDto> create(@Valid @RequestBody CreateTechStackRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.createStack(request));
    }

    // === WORKFLOW ===
    
    @PostMapping("/propose")
    public ResponseEntity<TechStackDto> propose(@Valid @RequestBody ProposeStackRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.proposeStack(request));
    }
    
    @GetMapping("/pending")
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN')")
    public ResponseEntity<List<TechStackDto>> getPending() {
        return ResponseEntity.ok(service.getPendingStacks());
    }
    
    @PostMapping("/{id}/approve")
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN')")
    public ResponseEntity<TechStackDto> approve(
            @PathVariable Long id,
            @RequestParam(required = false) String code) {
        return ResponseEntity.ok(service.approveStack(id, code));
    }
    
    @PostMapping("/{id}/reject")
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN')")
    public ResponseEntity<TechStackDto> reject(
            @PathVariable Long id,
            @Valid @RequestBody RejectStackRequest request) {
        return ResponseEntity.ok(service.rejectStack(id, request));
    }
    
    @PostMapping("/{id}/deprecate")
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN')")
    public ResponseEntity<TechStackDto> deprecate(@PathVariable Long id) {
        return ResponseEntity.ok(service.deprecateStack(id));
    }
}
```

---

## Файлы для создания

| # | Файл | Описание |
|---|------|----------|
| 1 | `V23__create_tech_stacks_tables.sql` | Таблицы tech_directions и tech_stacks |
| 2 | `V24__seed_tech_stacks.sql` | Начальные данные (7 направлений, 20 стеков) |
| 3 | `TechDirection.java` | Entity направления |
| 4 | `TechStack.java` | Entity стека |
| 5 | `TechStackStatus.java` | Enum статусов |
| 6 | `TechDirectionRepository.java` | Repository направлений |
| 7 | `TechStackRepository.java` | Repository стеков |
| 8 | `TechDirectionDto.java` | DTO направления |
| 9 | `TechStackDto.java` | DTO стека |
| 10 | `CreateTechStackRequest.java` | Request создания |
| 11 | `ProposeStackRequest.java` | Request предложения |
| 12 | `RejectStackRequest.java` | Request отклонения |
| 13 | `TechStackService.java` | Сервис |
| 14 | `TechStackController.java` | Контроллер |

---

## API Endpoints

| Метод | URL | Роль | Описание |
|-------|-----|------|----------|
| GET | /api/tech-stacks/directions | ALL | Список направлений |
| GET | /api/tech-stacks | ALL | Активные стеки для выбора |
| GET | /api/tech-stacks/by-direction/{id} | ALL | Стеки направления |
| GET | /api/tech-stacks/{id} | ALL | Один стек |
| GET | /api/tech-stacks/search?q= | ALL | Поиск |
| POST | /api/tech-stacks | ADMIN | Создать стек |
| POST | /api/tech-stacks/propose | ALL | Предложить стек |
| GET | /api/tech-stacks/pending | ADMIN | На согласовании |
| POST | /api/tech-stacks/{id}/approve | ADMIN | Одобрить |
| POST | /api/tech-stacks/{id}/reject | ADMIN | Отклонить |
| POST | /api/tech-stacks/{id}/deprecate | ADMIN | Пометить устаревшим |

---

## Тестирование

```bash
TOKEN=$(curl -s -X POST http://localhost:31081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | jq -r '.token')

# Направления со стеками
curl http://localhost:31081/api/tech-stacks/directions \
  -H "Authorization: Bearer $TOKEN"

# Стеки для выбора
curl http://localhost:31081/api/tech-stacks \
  -H "Authorization: Bearer $TOKEN"

# Предложить стек
curl -X POST http://localhost:31081/api/tech-stacks/propose \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"directionId":1,"name":"Rust","justification":"Нужен для системного программирования"}'

# На согласовании
curl http://localhost:31081/api/tech-stacks/pending \
  -H "Authorization: Bearer $TOKEN"

# Одобрить
curl -X POST "http://localhost:31081/api/tech-stacks/25/approve?code=RUST" \
  -H "Authorization: Bearer $TOKEN"
```

---

## После завершения

1. Обновить `DEVELOPMENT_PLAN.md` — Фаза 7 ✅
2. Обновить `Project_map.md` — добавить TechStack, TechDirection
3. Перейти к Фазе 8 (Аналитика)
