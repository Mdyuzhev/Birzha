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
                .completedCount(((Number) row[2]).longValue())
                .inProgressCount(((Number) row[3]).longValue())
                .avgDaysToComplete(row[4] != null ? ((Number) row[4]).doubleValue() : 0)
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
                .year(((Number) row[0]).intValue())
                .month(((Number) row[1]).intValue())
                .created(((Number) row[2]).longValue())
                .completed(((Number) row[3]).longValue())
                .rejected(((Number) row[4]).longValue())
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
            .countRequiringBorup(((Number) stats[4]).longValue())
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
