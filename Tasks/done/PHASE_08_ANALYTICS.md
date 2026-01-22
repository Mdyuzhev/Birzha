# Фаза 8: Аналитика по заявкам

**Статус:** 📋 Специфицировано
**Приоритет:** P2 (Средний)
**Трудозатраты:** ~25-30 часов
**Зависимости:** Фазы 1-5 (заявки должны работать)

---

## Цель

Создать аналитический модуль для визуализации данных по заявкам на ротацию/развитие сотрудников. Модуль должен предоставлять метрики, графики и отчёты для принятия управленческих решений.

---

## Требуемые метрики

### 1. Общая статистика
- Общее количество заявок
- Количество заявок по статусам (воронка)
- Количество заявок в работе
- Количество завершённых (переведён/уволен/отменён)

### 2. Метрики эффективности
- Среднее время согласования (от создания до перевода)
- Среднее время на каждом этапе workflow
- % одобренных HR BP
- % одобренных БОРУП
- % отклонённых (по причинам)
- Конверсия воронки (создано → согласовано → переведено)

### 3. Метрики по срезам
- Распределение по стекам (targetStack)
- Распределение по ДЗО
- Топ рекрутеров по количеству закрытых заявок
- Средний % увеличения ЗП

### 4. Временные метрики
- Динамика создания заявок по месяцам
- Динамика завершения заявок по месяцам
- Тренды по статусам

---

## Backend

### Файл 1: AnalyticsService.java

**Путь:** `backend/src/main/java/com/company/resourcemanager/service/AnalyticsService.java`

```java
package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.analytics.*;
import com.company.resourcemanager.entity.ApplicationStatus;
import com.company.resourcemanager.repository.ApplicationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class AnalyticsService {
    
    private final ApplicationRepository applicationRepository;
    private final CurrentUserService currentUserService;
    
    /**
     * Общая статистика по заявкам
     */
    public ApplicationsSummaryDto getApplicationsSummary(AnalyticsFilterRequest filter) {
        Long dzoId = resolveDzoId(filter);
        LocalDateTime startDate = resolveStartDate(filter);
        LocalDateTime endDate = resolveEndDate(filter);
        
        // Считаем по статусам
        Map<String, Long> byStatus = new HashMap<>();
        applicationRepository.countByStatusForPeriod(dzoId, startDate, endDate)
            .forEach(row -> byStatus.put(
                ((ApplicationStatus) row[0]).name(), 
                (Long) row[1]
            ));
        
        long total = byStatus.values().stream().mapToLong(Long::longValue).sum();
        
        long inProgress = 
            byStatus.getOrDefault("AVAILABLE_FOR_REVIEW", 0L) +
            byStatus.getOrDefault("IN_PROGRESS", 0L) +
            byStatus.getOrDefault("INTERVIEW", 0L) +
            byStatus.getOrDefault("PENDING_HR_BP", 0L) +
            byStatus.getOrDefault("PENDING_BORUP", 0L) +
            byStatus.getOrDefault("PREPARING_TRANSFER", 0L);
            
        long completed = 
            byStatus.getOrDefault("TRANSFERRED", 0L) +
            byStatus.getOrDefault("DISMISSED", 0L);
            
        long rejected = 
            byStatus.getOrDefault("REJECTED_HR_BP", 0L) +
            byStatus.getOrDefault("REJECTED_BORUP", 0L);
            
        long cancelled = byStatus.getOrDefault("CANCELLED", 0L);
        
        return ApplicationsSummaryDto.builder()
            .total(total)
            .inProgress(inProgress)
            .completed(completed)
            .rejected(rejected)
            .cancelled(cancelled)
            .byStatus(byStatus)
            .build();
    }
    
    /**
     * Распределение по стекам
     */
    public List<StackDistributionDto> getStackDistribution(AnalyticsFilterRequest filter) {
        Long dzoId = resolveDzoId(filter);
        LocalDateTime startDate = resolveStartDate(filter);
        LocalDateTime endDate = resolveEndDate(filter);
        
        List<StackDistributionDto> result = new ArrayList<>();
        applicationRepository.countByStackForPeriod(dzoId, startDate, endDate)
            .forEach(row -> result.add(StackDistributionDto.builder()
                .stack((String) row[0])
                .count((Long) row[1])
                .build()
            ));
        
        return result;
    }
    
    /**
     * Распределение по ДЗО
     */
    public List<DzoDistributionDto> getDzoDistribution(AnalyticsFilterRequest filter) {
        LocalDateTime startDate = resolveStartDate(filter);
        LocalDateTime endDate = resolveEndDate(filter);
        
        List<DzoDistributionDto> result = new ArrayList<>();
        applicationRepository.countByDzoForPeriod(startDate, endDate)
            .forEach(row -> result.add(DzoDistributionDto.builder()
                .dzoId((Long) row[0])
                .dzoName((String) row[1])
                .count((Long) row[2])
                .build()
            ));
        
        return result;
    }
    
    /**
     * Воронка конверсии
     */
    public FunnelDto getConversionFunnel(AnalyticsFilterRequest filter) {
        Long dzoId = resolveDzoId(filter);
        LocalDateTime startDate = resolveStartDate(filter);
        LocalDateTime endDate = resolveEndDate(filter);
        
        long created = applicationRepository.countCreatedForPeriod(dzoId, startDate, endDate);
        long sentToHrBp = applicationRepository.countReachedStatusForPeriod(
            dzoId, List.of(
                ApplicationStatus.PENDING_HR_BP, 
                ApplicationStatus.APPROVED_HR_BP,
                ApplicationStatus.REJECTED_HR_BP,
                ApplicationStatus.PENDING_BORUP,
                ApplicationStatus.APPROVED_BORUP,
                ApplicationStatus.REJECTED_BORUP,
                ApplicationStatus.PREPARING_TRANSFER,
                ApplicationStatus.TRANSFERRED,
                ApplicationStatus.DISMISSED
            ), startDate, endDate);
        long approvedHrBp = applicationRepository.countReachedStatusForPeriod(
            dzoId, List.of(
                ApplicationStatus.APPROVED_HR_BP,
                ApplicationStatus.PENDING_BORUP,
                ApplicationStatus.APPROVED_BORUP,
                ApplicationStatus.PREPARING_TRANSFER,
                ApplicationStatus.TRANSFERRED,
                ApplicationStatus.DISMISSED
            ), startDate, endDate);
        long transferred = applicationRepository.countByStatusForPeriod(
            dzoId, ApplicationStatus.TRANSFERRED, startDate, endDate);
        
        return FunnelDto.builder()
            .created(created)
            .sentToHrBp(sentToHrBp)
            .approvedHrBp(approvedHrBp)
            .transferred(transferred)
            .conversionCreatedToHrBp(created > 0 ? (double) sentToHrBp / created * 100 : 0)
            .conversionHrBpToApproved(sentToHrBp > 0 ? (double) approvedHrBp / sentToHrBp * 100 : 0)
            .conversionApprovedToTransferred(approvedHrBp > 0 ? (double) transferred / approvedHrBp * 100 : 0)
            .overallConversion(created > 0 ? (double) transferred / created * 100 : 0)
            .build();
    }
    
    /**
     * Среднее время согласования
     */
    public ApprovalTimeDto getAverageApprovalTime(AnalyticsFilterRequest filter) {
        Long dzoId = resolveDzoId(filter);
        LocalDateTime startDate = resolveStartDate(filter);
        LocalDateTime endDate = resolveEndDate(filter);
        
        Double avgTotalDays = applicationRepository.avgDaysToComplete(dzoId, startDate, endDate);
        Double avgToHrBpDays = applicationRepository.avgDaysToHrBp(dzoId, startDate, endDate);
        Double avgHrBpDecisionDays = applicationRepository.avgDaysHrBpDecision(dzoId, startDate, endDate);
        Double avgToBorupDays = applicationRepository.avgDaysToBorup(dzoId, startDate, endDate);
        Double avgBorupDecisionDays = applicationRepository.avgDaysBorupDecision(dzoId, startDate, endDate);
        
        return ApprovalTimeDto.builder()
            .avgTotalDays(avgTotalDays != null ? avgTotalDays : 0)
            .avgToHrBpDays(avgToHrBpDays != null ? avgToHrBpDays : 0)
            .avgHrBpDecisionDays(avgHrBpDecisionDays != null ? avgHrBpDecisionDays : 0)
            .avgToBorupDays(avgToBorupDays != null ? avgToBorupDays : 0)
            .avgBorupDecisionDays(avgBorupDecisionDays != null ? avgBorupDecisionDays : 0)
            .build();
    }
    
    /**
     * Топ рекрутеров
     */
    public List<RecruiterStatsDto> getTopRecruiters(AnalyticsFilterRequest filter, int limit) {
        Long dzoId = resolveDzoId(filter);
        LocalDateTime startDate = resolveStartDate(filter);
        LocalDateTime endDate = resolveEndDate(filter);
        
        List<RecruiterStatsDto> result = new ArrayList<>();
        applicationRepository.topRecruitersByCompleted(dzoId, startDate, endDate, limit)
            .forEach(row -> result.add(RecruiterStatsDto.builder()
                .recruiterId((Long) row[0])
                .recruiterName((String) row[1])
                .completedCount((Long) row[2])
                .inProgressCount((Long) row[3])
                .avgDaysToComplete(row[4] != null ? (Double) row[4] : 0)
                .build()
            ));
        
        return result;
    }
    
    /**
     * Динамика по месяцам
     */
    public List<MonthlyTrendDto> getMonthlyTrend(AnalyticsFilterRequest filter) {
        Long dzoId = resolveDzoId(filter);
        LocalDateTime startDate = resolveStartDate(filter);
        LocalDateTime endDate = resolveEndDate(filter);
        
        List<MonthlyTrendDto> result = new ArrayList<>();
        applicationRepository.monthlyTrend(dzoId, startDate, endDate)
            .forEach(row -> result.add(MonthlyTrendDto.builder()
                .year((Integer) row[0])
                .month((Integer) row[1])
                .created((Long) row[2])
                .completed((Long) row[3])
                .rejected((Long) row[4])
                .build()
            ));
        
        return result;
    }
    
    /**
     * Статистика по зарплатам
     */
    public SalaryStatsDto getSalaryStats(AnalyticsFilterRequest filter) {
        Long dzoId = resolveDzoId(filter);
        LocalDateTime startDate = resolveStartDate(filter);
        LocalDateTime endDate = resolveEndDate(filter);
        
        Object[] stats = applicationRepository.salaryStats(dzoId, startDate, endDate);
        
        return SalaryStatsDto.builder()
            .avgCurrentSalary(stats[0] != null ? ((Number) stats[0]).doubleValue() : 0)
            .avgTargetSalary(stats[1] != null ? ((Number) stats[1]).doubleValue() : 0)
            .avgIncreasePercent(stats[2] != null ? ((Number) stats[2]).doubleValue() : 0)
            .maxIncreasePercent(stats[3] != null ? ((Number) stats[3]).doubleValue() : 0)
            .countRequiringBorup((Long) stats[4])
            .build();
    }
    
    // === Вспомогательные методы ===
    
    private Long resolveDzoId(AnalyticsFilterRequest filter) {
        if (filter != null && filter.getDzoId() != null) {
            return filter.getDzoId();
        }
        // Для не-системных админов — только их ДЗО
        return currentUserService.getCurrentUser().isSystemAdmin() 
            ? null 
            : currentUserService.getCurrentDzoId();
    }
    
    private LocalDateTime resolveStartDate(AnalyticsFilterRequest filter) {
        if (filter != null && filter.getStartDate() != null) {
            return filter.getStartDate().atStartOfDay();
        }
        // По умолчанию — последние 12 месяцев
        return LocalDate.now().minusMonths(12).atStartOfDay();
    }
    
    private LocalDateTime resolveEndDate(AnalyticsFilterRequest filter) {
        if (filter != null && filter.getEndDate() != null) {
            return filter.getEndDate().atTime(23, 59, 59);
        }
        return LocalDateTime.now();
    }
}
```

---

### Файл 2: AnalyticsController.java

**Путь:** `backend/src/main/java/com/company/resourcemanager/controller/AnalyticsController.java`

```java
package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.analytics.*;
import com.company.resourcemanager.service.AnalyticsService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/analytics")
@RequiredArgsConstructor
public class AnalyticsController {
    
    private final AnalyticsService analyticsService;
    
    /**
     * Общая сводка по заявкам
     */
    @GetMapping("/summary")
    @PreAuthorize("hasAnyRole('SYSTEM_ADMIN', 'DZO_ADMIN', 'RECRUITER', 'HR_BP', 'BORUP')")
    public ResponseEntity<ApplicationsSummaryDto> getSummary(
            @RequestParam(required = false) Long dzoId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        
        AnalyticsFilterRequest filter = new AnalyticsFilterRequest(dzoId, startDate, endDate);
        return ResponseEntity.ok(analyticsService.getApplicationsSummary(filter));
    }
    
    /**
     * Распределение по стекам
     */
    @GetMapping("/by-stack")
    @PreAuthorize("hasAnyRole('SYSTEM_ADMIN', 'DZO_ADMIN', 'RECRUITER', 'HR_BP', 'BORUP')")
    public ResponseEntity<List<StackDistributionDto>> getByStack(
            @RequestParam(required = false) Long dzoId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        
        AnalyticsFilterRequest filter = new AnalyticsFilterRequest(dzoId, startDate, endDate);
        return ResponseEntity.ok(analyticsService.getStackDistribution(filter));
    }
    
    /**
     * Распределение по ДЗО
     */
    @GetMapping("/by-dzo")
    @PreAuthorize("hasRole('SYSTEM_ADMIN')")
    public ResponseEntity<List<DzoDistributionDto>> getByDzo(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        
        AnalyticsFilterRequest filter = new AnalyticsFilterRequest(null, startDate, endDate);
        return ResponseEntity.ok(analyticsService.getDzoDistribution(filter));
    }
    
    /**
     * Воронка конверсии
     */
    @GetMapping("/funnel")
    @PreAuthorize("hasAnyRole('SYSTEM_ADMIN', 'DZO_ADMIN', 'RECRUITER', 'HR_BP', 'BORUP')")
    public ResponseEntity<FunnelDto> getFunnel(
            @RequestParam(required = false) Long dzoId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        
        AnalyticsFilterRequest filter = new AnalyticsFilterRequest(dzoId, startDate, endDate);
        return ResponseEntity.ok(analyticsService.getConversionFunnel(filter));
    }
    
    /**
     * Среднее время согласования
     */
    @GetMapping("/approval-time")
    @PreAuthorize("hasAnyRole('SYSTEM_ADMIN', 'DZO_ADMIN', 'RECRUITER', 'HR_BP', 'BORUP')")
    public ResponseEntity<ApprovalTimeDto> getApprovalTime(
            @RequestParam(required = false) Long dzoId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        
        AnalyticsFilterRequest filter = new AnalyticsFilterRequest(dzoId, startDate, endDate);
        return ResponseEntity.ok(analyticsService.getAverageApprovalTime(filter));
    }
    
    /**
     * Топ рекрутеров
     */
    @GetMapping("/top-recruiters")
    @PreAuthorize("hasAnyRole('SYSTEM_ADMIN', 'DZO_ADMIN')")
    public ResponseEntity<List<RecruiterStatsDto>> getTopRecruiters(
            @RequestParam(required = false) Long dzoId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(defaultValue = "10") int limit) {
        
        AnalyticsFilterRequest filter = new AnalyticsFilterRequest(dzoId, startDate, endDate);
        return ResponseEntity.ok(analyticsService.getTopRecruiters(filter, limit));
    }
    
    /**
     * Динамика по месяцам
     */
    @GetMapping("/monthly-trend")
    @PreAuthorize("hasAnyRole('SYSTEM_ADMIN', 'DZO_ADMIN', 'RECRUITER', 'HR_BP', 'BORUP')")
    public ResponseEntity<List<MonthlyTrendDto>> getMonthlyTrend(
            @RequestParam(required = false) Long dzoId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        
        AnalyticsFilterRequest filter = new AnalyticsFilterRequest(dzoId, startDate, endDate);
        return ResponseEntity.ok(analyticsService.getMonthlyTrend(filter));
    }
    
    /**
     * Статистика по зарплатам
     */
    @GetMapping("/salary-stats")
    @PreAuthorize("hasAnyRole('SYSTEM_ADMIN', 'DZO_ADMIN', 'HR_BP', 'BORUP')")
    public ResponseEntity<SalaryStatsDto> getSalaryStats(
            @RequestParam(required = false) Long dzoId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        
        AnalyticsFilterRequest filter = new AnalyticsFilterRequest(dzoId, startDate, endDate);
        return ResponseEntity.ok(analyticsService.getSalaryStats(filter));
    }
}
```

---

### Файл 3: DTO классы

**Путь:** `backend/src/main/java/com/company/resourcemanager/dto/analytics/`

#### AnalyticsFilterRequest.java
```java
package com.company.resourcemanager.dto.analytics;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AnalyticsFilterRequest {
    private Long dzoId;
    private LocalDate startDate;
    private LocalDate endDate;
}
```

#### ApplicationsSummaryDto.java
```java
package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;
import java.util.Map;

@Data
@Builder
public class ApplicationsSummaryDto {
    private long total;
    private long inProgress;
    private long completed;
    private long rejected;
    private long cancelled;
    private Map<String, Long> byStatus;
}
```

#### StackDistributionDto.java
```java
package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class StackDistributionDto {
    private String stack;
    private long count;
}
```

#### DzoDistributionDto.java
```java
package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class DzoDistributionDto {
    private Long dzoId;
    private String dzoName;
    private long count;
}
```

#### FunnelDto.java
```java
package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class FunnelDto {
    private long created;
    private long sentToHrBp;
    private long approvedHrBp;
    private long transferred;
    
    private double conversionCreatedToHrBp;
    private double conversionHrBpToApproved;
    private double conversionApprovedToTransferred;
    private double overallConversion;
}
```

#### ApprovalTimeDto.java
```java
package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ApprovalTimeDto {
    private double avgTotalDays;
    private double avgToHrBpDays;
    private double avgHrBpDecisionDays;
    private double avgToBorupDays;
    private double avgBorupDecisionDays;
}
```

#### RecruiterStatsDto.java
```java
package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RecruiterStatsDto {
    private Long recruiterId;
    private String recruiterName;
    private long completedCount;
    private long inProgressCount;
    private double avgDaysToComplete;
}
```

#### MonthlyTrendDto.java
```java
package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MonthlyTrendDto {
    private int year;
    private int month;
    private long created;
    private long completed;
    private long rejected;
}
```

#### SalaryStatsDto.java
```java
package com.company.resourcemanager.dto.analytics;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SalaryStatsDto {
    private double avgCurrentSalary;
    private double avgTargetSalary;
    private double avgIncreasePercent;
    private double maxIncreasePercent;
    private long countRequiringBorup;
}
```

---

### Файл 4: Дополнения в ApplicationRepository.java

**Путь:** `backend/src/main/java/com/company/resourcemanager/repository/ApplicationRepository.java`

Добавить методы:

```java
// === Аналитика ===

@Query("""
    SELECT a.status, COUNT(a) FROM Application a
    WHERE (:dzoId IS NULL OR a.dzo.id = :dzoId)
    AND a.createdAt >= :startDate AND a.createdAt <= :endDate
    GROUP BY a.status
    """)
List<Object[]> countByStatusForPeriod(
    @Param("dzoId") Long dzoId,
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate
);

@Query("""
    SELECT a.targetStack, COUNT(a) FROM Application a
    WHERE (:dzoId IS NULL OR a.dzo.id = :dzoId)
    AND a.createdAt >= :startDate AND a.createdAt <= :endDate
    AND a.targetStack IS NOT NULL
    GROUP BY a.targetStack
    ORDER BY COUNT(a) DESC
    """)
List<Object[]> countByStackForPeriod(
    @Param("dzoId") Long dzoId,
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate
);

@Query("""
    SELECT a.dzo.id, a.dzo.name, COUNT(a) FROM Application a
    WHERE a.createdAt >= :startDate AND a.createdAt <= :endDate
    GROUP BY a.dzo.id, a.dzo.name
    ORDER BY COUNT(a) DESC
    """)
List<Object[]> countByDzoForPeriod(
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate
);

@Query("""
    SELECT COUNT(a) FROM Application a
    WHERE (:dzoId IS NULL OR a.dzo.id = :dzoId)
    AND a.createdAt >= :startDate AND a.createdAt <= :endDate
    """)
long countCreatedForPeriod(
    @Param("dzoId") Long dzoId,
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate
);

@Query("""
    SELECT COUNT(a) FROM Application a
    WHERE (:dzoId IS NULL OR a.dzo.id = :dzoId)
    AND a.status IN :statuses
    AND a.createdAt >= :startDate AND a.createdAt <= :endDate
    """)
long countReachedStatusForPeriod(
    @Param("dzoId") Long dzoId,
    @Param("statuses") List<ApplicationStatus> statuses,
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate
);

@Query("""
    SELECT COUNT(a) FROM Application a
    WHERE (:dzoId IS NULL OR a.dzo.id = :dzoId)
    AND a.status = :status
    AND a.createdAt >= :startDate AND a.createdAt <= :endDate
    """)
long countByStatusForPeriod(
    @Param("dzoId") Long dzoId,
    @Param("status") ApplicationStatus status,
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate
);

@Query(value = """
    SELECT AVG(EXTRACT(EPOCH FROM (completed_at - created_at)) / 86400)
    FROM applications
    WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
    AND completed_at IS NOT NULL
    AND created_at >= :startDate AND created_at <= :endDate
    """, nativeQuery = true)
Double avgDaysToComplete(
    @Param("dzoId") Long dzoId,
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate
);

@Query(value = """
    SELECT AVG(EXTRACT(EPOCH FROM (hr_bp_decision_at - created_at)) / 86400)
    FROM applications
    WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
    AND hr_bp_decision_at IS NOT NULL
    AND created_at >= :startDate AND created_at <= :endDate
    """, nativeQuery = true)
Double avgDaysToHrBp(
    @Param("dzoId") Long dzoId,
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate
);

@Query(value = """
    SELECT AVG(EXTRACT(EPOCH FROM (hr_bp_decision_at - assigned_to_recruiter_at)) / 86400)
    FROM applications
    WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
    AND hr_bp_decision_at IS NOT NULL AND assigned_to_recruiter_at IS NOT NULL
    AND created_at >= :startDate AND created_at <= :endDate
    """, nativeQuery = true)
Double avgDaysHrBpDecision(
    @Param("dzoId") Long dzoId,
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate
);

@Query(value = """
    SELECT AVG(EXTRACT(EPOCH FROM (borup_decision_at - hr_bp_decision_at)) / 86400)
    FROM applications
    WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
    AND borup_decision_at IS NOT NULL
    AND created_at >= :startDate AND created_at <= :endDate
    """, nativeQuery = true)
Double avgDaysToBorup(
    @Param("dzoId") Long dzoId,
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate
);

@Query(value = """
    SELECT AVG(EXTRACT(EPOCH FROM (borup_decision_at - hr_bp_decision_at)) / 86400)
    FROM applications
    WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
    AND borup_decision_at IS NOT NULL AND hr_bp_decision_at IS NOT NULL
    AND created_at >= :startDate AND created_at <= :endDate
    """, nativeQuery = true)
Double avgDaysBorupDecision(
    @Param("dzoId") Long dzoId,
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate
);

@Query(value = """
    SELECT 
        u.id,
        u.username,
        COUNT(CASE WHEN a.status IN ('TRANSFERRED', 'DISMISSED') THEN 1 END) as completed,
        COUNT(CASE WHEN a.status NOT IN ('TRANSFERRED', 'DISMISSED', 'CANCELLED') THEN 1 END) as in_progress,
        AVG(CASE WHEN a.completed_at IS NOT NULL 
            THEN EXTRACT(EPOCH FROM (a.completed_at - a.assigned_to_recruiter_at)) / 86400 END) as avg_days
    FROM applications a
    JOIN users u ON a.recruiter_id = u.id
    WHERE (:dzoId IS NULL OR a.dzo_id = :dzoId)
    AND a.created_at >= :startDate AND a.created_at <= :endDate
    GROUP BY u.id, u.username
    ORDER BY completed DESC
    LIMIT :limit
    """, nativeQuery = true)
List<Object[]> topRecruitersByCompleted(
    @Param("dzoId") Long dzoId,
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate,
    @Param("limit") int limit
);

@Query(value = """
    SELECT 
        EXTRACT(YEAR FROM created_at) as year,
        EXTRACT(MONTH FROM created_at) as month,
        COUNT(*) as created,
        COUNT(CASE WHEN status IN ('TRANSFERRED', 'DISMISSED') THEN 1 END) as completed,
        COUNT(CASE WHEN status IN ('REJECTED_HR_BP', 'REJECTED_BORUP') THEN 1 END) as rejected
    FROM applications
    WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
    AND created_at >= :startDate AND created_at <= :endDate
    GROUP BY EXTRACT(YEAR FROM created_at), EXTRACT(MONTH FROM created_at)
    ORDER BY year, month
    """, nativeQuery = true)
List<Object[]> monthlyTrend(
    @Param("dzoId") Long dzoId,
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate
);

@Query(value = """
    SELECT 
        AVG(current_salary),
        AVG(target_salary),
        AVG(salary_increase_percent),
        MAX(salary_increase_percent),
        COUNT(CASE WHEN requires_borup_approval = true THEN 1 END)
    FROM applications
    WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
    AND created_at >= :startDate AND created_at <= :endDate
    AND current_salary IS NOT NULL AND target_salary IS NOT NULL
    """, nativeQuery = true)
Object[] salaryStats(
    @Param("dzoId") Long dzoId,
    @Param("startDate") LocalDateTime startDate,
    @Param("endDate") LocalDateTime endDate
);
```

---

## Frontend

### Файл 5: API модуль analytics.js

**Путь:** `frontend/src/api/analytics.js`

```javascript
import client from './client'

export const analyticsApi = {
  // Общая сводка
  getSummary(params = {}) {
    return client.get('/analytics/summary', { params })
  },

  // По стекам
  getByStack(params = {}) {
    return client.get('/analytics/by-stack', { params })
  },

  // По ДЗО (только для системного админа)
  getByDzo(params = {}) {
    return client.get('/analytics/by-dzo', { params })
  },

  // Воронка конверсии
  getFunnel(params = {}) {
    return client.get('/analytics/funnel', { params })
  },

  // Время согласования
  getApprovalTime(params = {}) {
    return client.get('/analytics/approval-time', { params })
  },

  // Топ рекрутеров
  getTopRecruiters(params = {}) {
    return client.get('/analytics/top-recruiters', { params })
  },

  // Динамика по месяцам
  getMonthlyTrend(params = {}) {
    return client.get('/analytics/monthly-trend', { params })
  },

  // Статистика по зарплатам
  getSalaryStats(params = {}) {
    return client.get('/analytics/salary-stats', { params })
  }
}
```

---

### Файл 6: Pinia store analytics.js

**Путь:** `frontend/src/stores/analytics.js`

```javascript
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { analyticsApi } from '@/api/analytics'

export const useAnalyticsStore = defineStore('analytics', () => {
  const loading = ref(false)
  const error = ref(null)
  
  const summary = ref(null)
  const stackDistribution = ref([])
  const dzoDistribution = ref([])
  const funnel = ref(null)
  const approvalTime = ref(null)
  const topRecruiters = ref([])
  const monthlyTrend = ref([])
  const salaryStats = ref(null)

  async function fetchSummary(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getSummary(params)
      summary.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchStackDistribution(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getByStack(params)
      stackDistribution.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchDzoDistribution(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getByDzo(params)
      dzoDistribution.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchFunnel(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getFunnel(params)
      funnel.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchApprovalTime(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getApprovalTime(params)
      approvalTime.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchTopRecruiters(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getTopRecruiters(params)
      topRecruiters.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchMonthlyTrend(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getMonthlyTrend(params)
      monthlyTrend.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchSalaryStats(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getSalaryStats(params)
      salaryStats.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchAll(params = {}) {
    loading.value = true
    try {
      await Promise.all([
        fetchSummary(params),
        fetchStackDistribution(params),
        fetchFunnel(params),
        fetchApprovalTime(params),
        fetchMonthlyTrend(params),
        fetchSalaryStats(params)
      ])
    } catch (e) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  function clearError() {
    error.value = null
  }

  return {
    loading,
    error,
    summary,
    stackDistribution,
    dzoDistribution,
    funnel,
    approvalTime,
    topRecruiters,
    monthlyTrend,
    salaryStats,
    fetchSummary,
    fetchStackDistribution,
    fetchDzoDistribution,
    fetchFunnel,
    fetchApprovalTime,
    fetchTopRecruiters,
    fetchMonthlyTrend,
    fetchSalaryStats,
    fetchAll,
    clearError
  }
})
```

---

### Файл 7: AnalyticsView.vue

**Путь:** `frontend/src/views/AnalyticsView.vue`

```vue
<template>
  <div class="analytics-view">
    <!-- Фон -->
    <div class="bg-orbs">
      <div class="orb orb-1"></div>
      <div class="orb orb-2"></div>
      <div class="orb orb-3"></div>
    </div>

    <!-- Заголовок -->
    <div class="page-header">
      <div>
        <h1>Аналитика</h1>
        <p class="subtitle">Статистика по заявкам на ротацию и развитие</p>
      </div>
      <div class="header-actions">
        <el-date-picker
          v-model="dateRange"
          type="daterange"
          range-separator="—"
          start-placeholder="Начало"
          end-placeholder="Конец"
          format="DD.MM.YYYY"
          value-format="YYYY-MM-DD"
          @change="handleDateChange"
        />
        <el-select
          v-if="authStore.isSystemAdmin"
          v-model="selectedDzoId"
          placeholder="Все ДЗО"
          clearable
          @change="loadData"
        >
          <el-option
            v-for="dzo in dzos"
            :key="dzo.id"
            :label="dzo.name"
            :value="dzo.id"
          />
        </el-select>
      </div>
    </div>

    <!-- Карточки сводки -->
    <div class="summary-cards">
      <div class="summary-card glass-card">
        <div class="card-icon total">
          <el-icon><Document /></el-icon>
        </div>
        <div class="card-content">
          <div class="card-value">{{ summary?.total || 0 }}</div>
          <div class="card-label">Всего заявок</div>
        </div>
      </div>

      <div class="summary-card glass-card">
        <div class="card-icon in-progress">
          <el-icon><Loading /></el-icon>
        </div>
        <div class="card-content">
          <div class="card-value">{{ summary?.inProgress || 0 }}</div>
          <div class="card-label">В работе</div>
        </div>
      </div>

      <div class="summary-card glass-card">
        <div class="card-icon completed">
          <el-icon><CircleCheck /></el-icon>
        </div>
        <div class="card-content">
          <div class="card-value">{{ summary?.completed || 0 }}</div>
          <div class="card-label">Завершено</div>
        </div>
      </div>

      <div class="summary-card glass-card">
        <div class="card-icon rejected">
          <el-icon><CircleClose /></el-icon>
        </div>
        <div class="card-content">
          <div class="card-value">{{ summary?.rejected || 0 }}</div>
          <div class="card-label">Отклонено</div>
        </div>
      </div>
    </div>

    <!-- Графики -->
    <div class="charts-grid">
      <!-- Воронка конверсии -->
      <div class="chart-card glass-card">
        <h3>Воронка конверсии</h3>
        <div class="funnel-chart" v-if="funnel">
          <div class="funnel-step" :style="{ width: '100%' }">
            <span class="step-value">{{ funnel.created }}</span>
            <span class="step-label">Создано</span>
          </div>
          <div class="funnel-step" :style="{ width: funnelWidth(funnel.sentToHrBp, funnel.created) }">
            <span class="step-value">{{ funnel.sentToHrBp }}</span>
            <span class="step-label">Отправлено HR BP</span>
            <span class="step-percent">{{ funnel.conversionCreatedToHrBp?.toFixed(1) }}%</span>
          </div>
          <div class="funnel-step" :style="{ width: funnelWidth(funnel.approvedHrBp, funnel.created) }">
            <span class="step-value">{{ funnel.approvedHrBp }}</span>
            <span class="step-label">Согласовано HR BP</span>
            <span class="step-percent">{{ funnel.conversionHrBpToApproved?.toFixed(1) }}%</span>
          </div>
          <div class="funnel-step final" :style="{ width: funnelWidth(funnel.transferred, funnel.created) }">
            <span class="step-value">{{ funnel.transferred }}</span>
            <span class="step-label">Переведено</span>
            <span class="step-percent">{{ funnel.overallConversion?.toFixed(1) }}%</span>
          </div>
        </div>
      </div>

      <!-- Время согласования -->
      <div class="chart-card glass-card">
        <h3>Среднее время (дни)</h3>
        <div class="time-metrics" v-if="approvalTime">
          <div class="time-metric">
            <div class="metric-value">{{ approvalTime.avgTotalDays?.toFixed(1) }}</div>
            <div class="metric-label">Общее время</div>
          </div>
          <div class="time-metric">
            <div class="metric-value">{{ approvalTime.avgToHrBpDays?.toFixed(1) }}</div>
            <div class="metric-label">До HR BP</div>
          </div>
          <div class="time-metric">
            <div class="metric-value">{{ approvalTime.avgHrBpDecisionDays?.toFixed(1) }}</div>
            <div class="metric-label">Решение HR BP</div>
          </div>
          <div class="time-metric" v-if="approvalTime.avgBorupDecisionDays > 0">
            <div class="metric-value">{{ approvalTime.avgBorupDecisionDays?.toFixed(1) }}</div>
            <div class="metric-label">Решение БОРУП</div>
          </div>
        </div>
      </div>

      <!-- По стекам -->
      <div class="chart-card glass-card">
        <h3>Распределение по стекам</h3>
        <div class="stack-bars" v-if="stackDistribution.length">
          <div 
            v-for="item in stackDistribution.slice(0, 8)" 
            :key="item.stack" 
            class="stack-bar"
          >
            <div class="bar-label">{{ item.stack || 'Не указан' }}</div>
            <div class="bar-container">
              <div 
                class="bar-fill" 
                :style="{ width: barWidth(item.count) }"
              ></div>
              <span class="bar-value">{{ item.count }}</span>
            </div>
          </div>
        </div>
        <div v-else class="no-data">Нет данных</div>
      </div>

      <!-- Статистика ЗП -->
      <div class="chart-card glass-card">
        <h3>Статистика по зарплатам</h3>
        <div class="salary-metrics" v-if="salaryStats">
          <div class="salary-metric">
            <div class="metric-label">Средняя текущая ЗП</div>
            <div class="metric-value">{{ formatSalary(salaryStats.avgCurrentSalary) }} ₽</div>
          </div>
          <div class="salary-metric">
            <div class="metric-label">Средняя целевая ЗП</div>
            <div class="metric-value">{{ formatSalary(salaryStats.avgTargetSalary) }} ₽</div>
          </div>
          <div class="salary-metric">
            <div class="metric-label">Средний рост</div>
            <div class="metric-value highlight">+{{ salaryStats.avgIncreasePercent?.toFixed(1) }}%</div>
          </div>
          <div class="salary-metric">
            <div class="metric-label">Требуют БОРУП</div>
            <div class="metric-value warning">{{ salaryStats.countRequiringBorup }}</div>
          </div>
        </div>
      </div>

      <!-- Динамика по месяцам -->
      <div class="chart-card glass-card wide">
        <h3>Динамика по месяцам</h3>
        <div class="trend-chart" v-if="monthlyTrend.length">
          <div class="trend-legend">
            <span class="legend-item created"><span class="dot"></span> Создано</span>
            <span class="legend-item completed"><span class="dot"></span> Завершено</span>
            <span class="legend-item rejected"><span class="dot"></span> Отклонено</span>
          </div>
          <div class="trend-bars">
            <div v-for="item in monthlyTrend" :key="`${item.year}-${item.month}`" class="trend-month">
              <div class="bars">
                <div class="bar created" :style="{ height: trendHeight(item.created) }"></div>
                <div class="bar completed" :style="{ height: trendHeight(item.completed) }"></div>
                <div class="bar rejected" :style="{ height: trendHeight(item.rejected) }"></div>
              </div>
              <div class="month-label">{{ formatMonth(item.month) }}</div>
            </div>
          </div>
        </div>
        <div v-else class="no-data">Нет данных</div>
      </div>
    </div>

    <!-- Топ рекрутеров (для админов) -->
    <div v-if="authStore.isAdmin" class="recruiters-section glass-card">
      <h3>Топ рекрутеров</h3>
      <el-table :data="topRecruiters" class="recruiters-table">
        <el-table-column prop="recruiterName" label="Рекрутер" />
        <el-table-column prop="completedCount" label="Завершено" width="120" />
        <el-table-column prop="inProgressCount" label="В работе" width="120" />
        <el-table-column label="Среднее время (дни)" width="180">
          <template #default="{ row }">
            {{ row.avgDaysToComplete?.toFixed(1) || '-' }}
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { Document, Loading, CircleCheck, CircleClose } from '@element-plus/icons-vue'
import { useAnalyticsStore } from '@/stores/analytics'
import { useAuthStore } from '@/stores/auth'
import client from '@/api/client'

const analyticsStore = useAnalyticsStore()
const authStore = useAuthStore()

const dateRange = ref(null)
const selectedDzoId = ref(null)
const dzos = ref([])

const summary = computed(() => analyticsStore.summary)
const funnel = computed(() => analyticsStore.funnel)
const approvalTime = computed(() => analyticsStore.approvalTime)
const stackDistribution = computed(() => analyticsStore.stackDistribution)
const salaryStats = computed(() => analyticsStore.salaryStats)
const monthlyTrend = computed(() => analyticsStore.monthlyTrend)
const topRecruiters = computed(() => analyticsStore.topRecruiters)

const maxStackCount = computed(() => {
  if (!stackDistribution.value.length) return 1
  return Math.max(...stackDistribution.value.map(s => s.count))
})

const maxTrendCount = computed(() => {
  if (!monthlyTrend.value.length) return 1
  return Math.max(...monthlyTrend.value.flatMap(m => [m.created, m.completed, m.rejected]))
})

function getFilterParams() {
  const params = {}
  if (selectedDzoId.value) {
    params.dzoId = selectedDzoId.value
  }
  if (dateRange.value && dateRange.value[0]) {
    params.startDate = dateRange.value[0]
    params.endDate = dateRange.value[1]
  }
  return params
}

async function loadData() {
  const params = getFilterParams()
  await analyticsStore.fetchAll(params)
  
  if (authStore.isAdmin) {
    await analyticsStore.fetchTopRecruiters({ ...params, limit: 10 })
  }
}

async function loadDzos() {
  if (authStore.isSystemAdmin) {
    try {
      const response = await client.get('/dzos')
      dzos.value = response.data
    } catch (e) {
      console.error('Failed to load DZOs:', e)
    }
  }
}

function handleDateChange() {
  loadData()
}

function funnelWidth(value, total) {
  if (!total || !value) return '20%'
  const percent = Math.max(20, (value / total) * 100)
  return `${percent}%`
}

function barWidth(count) {
  return `${(count / maxStackCount.value) * 100}%`
}

function trendHeight(count) {
  if (!count) return '0px'
  return `${Math.max(4, (count / maxTrendCount.value) * 100)}px`
}

function formatSalary(value) {
  if (!value) return '0'
  return new Intl.NumberFormat('ru-RU').format(Math.round(value))
}

function formatMonth(month) {
  const months = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек']
  return months[month - 1] || month
}

onMounted(async () => {
  // Установить диапазон по умолчанию — последние 12 месяцев
  const endDate = new Date()
  const startDate = new Date()
  startDate.setMonth(startDate.getMonth() - 12)
  dateRange.value = [
    startDate.toISOString().split('T')[0],
    endDate.toISOString().split('T')[0]
  ]
  
  await loadDzos()
  await loadData()
})
</script>

<style scoped>
.analytics-view {
  padding: 24px;
  min-height: 100vh;
  position: relative;
}

/* Фон с orbs */
.bg-orbs {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
  overflow: hidden;
  z-index: 0;
}

.orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.4;
  animation: float 20s ease-in-out infinite;
}

.orb-1 {
  width: 400px;
  height: 400px;
  background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
  top: -100px;
  right: -100px;
}

.orb-2 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #3b82f6 0%, #60a5fa 100%);
  bottom: 100px;
  left: -50px;
  animation-delay: -7s;
}

.orb-3 {
  width: 250px;
  height: 250px;
  background: linear-gradient(135deg, #8b5cf6 0%, #c4b5fd 100%);
  top: 50%;
  right: 20%;
  animation-delay: -14s;
}

@keyframes float {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-30px) rotate(5deg); }
}

/* Glass card */
.glass-card {
  background: rgba(30, 30, 50, 0.8);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  position: relative;
  z-index: 1;
}

/* Заголовок */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 24px;
  position: relative;
  z-index: 1;
}

.page-header h1 {
  font-size: 32px;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0;
}

.subtitle {
  color: var(--text-muted);
  margin-top: 4px;
}

.header-actions {
  display: flex;
  gap: 12px;
}

/* Карточки сводки */
.summary-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}

.summary-card {
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
}

.card-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
}

.card-icon.total {
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  color: white;
}

.card-icon.in-progress {
  background: linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%);
  color: white;
}

.card-icon.completed {
  background: linear-gradient(135deg, #10b981 0%, #34d399 100%);
  color: white;
}

.card-icon.rejected {
  background: linear-gradient(135deg, #ef4444 0%, #f87171 100%);
  color: white;
}

.card-value {
  font-size: 28px;
  font-weight: 700;
  color: var(--text-primary);
}

.card-label {
  font-size: 13px;
  color: var(--text-muted);
}

/* Сетка графиков */
.charts-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}

.chart-card {
  padding: 20px;
}

.chart-card.wide {
  grid-column: span 2;
}

.chart-card h3 {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 16px 0;
}

/* Воронка */
.funnel-chart {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.funnel-step {
  background: linear-gradient(90deg, rgba(124, 58, 237, 0.3) 0%, rgba(124, 58, 237, 0.1) 100%);
  border-radius: 8px;
  padding: 12px 16px;
  display: flex;
  align-items: center;
  gap: 12px;
  transition: width 0.3s ease;
}

.funnel-step.final {
  background: linear-gradient(90deg, rgba(16, 185, 129, 0.3) 0%, rgba(16, 185, 129, 0.1) 100%);
}

.step-value {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-primary);
  min-width: 40px;
}

.step-label {
  flex: 1;
  color: var(--text-secondary);
}

.step-percent {
  color: var(--accent);
  font-weight: 600;
}

/* Время */
.time-metrics {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.time-metric {
  text-align: center;
  padding: 16px;
  background: rgba(124, 58, 237, 0.1);
  border-radius: 12px;
}

.metric-value {
  font-size: 28px;
  font-weight: 700;
  color: var(--accent);
}

.metric-label {
  font-size: 12px;
  color: var(--text-muted);
  margin-top: 4px;
}

/* Стеки */
.stack-bars {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.stack-bar {
  display: flex;
  align-items: center;
  gap: 12px;
}

.bar-label {
  width: 100px;
  font-size: 13px;
  color: var(--text-secondary);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.bar-container {
  flex: 1;
  height: 24px;
  background: rgba(124, 58, 237, 0.1);
  border-radius: 4px;
  position: relative;
  overflow: hidden;
}

.bar-fill {
  height: 100%;
  background: linear-gradient(90deg, #7c3aed 0%, #a78bfa 100%);
  border-radius: 4px;
  transition: width 0.3s ease;
}

.bar-value {
  position: absolute;
  right: 8px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 12px;
  font-weight: 600;
  color: var(--text-primary);
}

/* ЗП */
.salary-metrics {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
}

.salary-metric {
  padding: 12px;
  background: rgba(124, 58, 237, 0.1);
  border-radius: 8px;
}

.salary-metric .metric-value {
  font-size: 18px;
}

.salary-metric .metric-value.highlight {
  color: #10b981;
}

.salary-metric .metric-value.warning {
  color: #f59e0b;
}

/* Тренд */
.trend-legend {
  display: flex;
  gap: 20px;
  margin-bottom: 16px;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: var(--text-secondary);
}

.legend-item .dot {
  width: 10px;
  height: 10px;
  border-radius: 2px;
}

.legend-item.created .dot { background: #6366f1; }
.legend-item.completed .dot { background: #10b981; }
.legend-item.rejected .dot { background: #ef4444; }

.trend-bars {
  display: flex;
  gap: 8px;
  align-items: flex-end;
  height: 120px;
}

.trend-month {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.trend-month .bars {
  display: flex;
  gap: 2px;
  align-items: flex-end;
  height: 100px;
}

.trend-month .bar {
  width: 12px;
  border-radius: 2px 2px 0 0;
  transition: height 0.3s ease;
}

.trend-month .bar.created { background: #6366f1; }
.trend-month .bar.completed { background: #10b981; }
.trend-month .bar.rejected { background: #ef4444; }

.month-label {
  font-size: 11px;
  color: var(--text-muted);
  margin-top: 8px;
}

/* Рекрутеры */
.recruiters-section {
  padding: 20px;
}

.recruiters-section h3 {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 16px 0;
}

.no-data {
  text-align: center;
  padding: 40px;
  color: var(--text-muted);
}

/* Responsive */
@media (max-width: 1200px) {
  .summary-cards {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .charts-grid {
    grid-template-columns: 1fr;
  }
  
  .chart-card.wide {
    grid-column: span 1;
  }
}
</style>
```

---

## Зависимости

Для графиков (опционально можно добавить Chart.js или ECharts для более сложных визуализаций):

```bash
npm install echarts vue-echarts
```

---

## API Endpoints

| Метод | URL | Описание | Роли |
|-------|-----|----------|------|
| GET | `/api/analytics/summary` | Общая сводка | ADMIN, RECRUITER, HR_BP, BORUP |
| GET | `/api/analytics/by-stack` | По стекам | ADMIN, RECRUITER, HR_BP, BORUP |
| GET | `/api/analytics/by-dzo` | По ДЗО | SYSTEM_ADMIN |
| GET | `/api/analytics/funnel` | Воронка | ADMIN, RECRUITER, HR_BP, BORUP |
| GET | `/api/analytics/approval-time` | Время согласования | ADMIN, RECRUITER, HR_BP, BORUP |
| GET | `/api/analytics/top-recruiters` | Топ рекрутеров | ADMIN |
| GET | `/api/analytics/monthly-trend` | Динамика | ADMIN, RECRUITER, HR_BP, BORUP |
| GET | `/api/analytics/salary-stats` | Статистика ЗП | ADMIN, HR_BP, BORUP |

---

## Файлы для создания

| # | Путь | Описание |
|---|------|----------|
| 1 | `backend/.../service/AnalyticsService.java` | Сервис аналитики |
| 2 | `backend/.../controller/AnalyticsController.java` | REST контроллер |
| 3 | `backend/.../dto/analytics/AnalyticsFilterRequest.java` | Фильтр запроса |
| 4 | `backend/.../dto/analytics/ApplicationsSummaryDto.java` | Сводка |
| 5 | `backend/.../dto/analytics/StackDistributionDto.java` | По стекам |
| 6 | `backend/.../dto/analytics/DzoDistributionDto.java` | По ДЗО |
| 7 | `backend/.../dto/analytics/FunnelDto.java` | Воронка |
| 8 | `backend/.../dto/analytics/ApprovalTimeDto.java` | Время |
| 9 | `backend/.../dto/analytics/RecruiterStatsDto.java` | Рекрутеры |
| 10 | `backend/.../dto/analytics/MonthlyTrendDto.java` | Тренд |
| 11 | `backend/.../dto/analytics/SalaryStatsDto.java` | ЗП статистика |
| 12 | `backend/.../repository/ApplicationRepository.java` | Добавить методы |
| 13 | `frontend/src/api/analytics.js` | API модуль |
| 14 | `frontend/src/stores/analytics.js` | Pinia store |
| 15 | `frontend/src/views/AnalyticsView.vue` | Vue компонент |

---

## Тестирование

1. Создать несколько заявок в разных статусах
2. Пересобрать backend: `docker-compose build backend`
3. Перезапустить: `docker-compose up -d`
4. Открыть `/analytics`
5. Проверить:
   - Карточки сводки показывают корректные числа
   - Воронка отображает конверсию
   - Фильтры по дате работают
   - Фильтр по ДЗО работает (для системного админа)
