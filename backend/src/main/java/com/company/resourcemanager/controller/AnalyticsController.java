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
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN', 'RECRUITER', 'HR_BP', 'BORUP')")
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
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN', 'RECRUITER', 'HR_BP', 'BORUP')")
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
    @PreAuthorize("hasAuthority('SYSTEM_ADMIN')")
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
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN', 'RECRUITER', 'HR_BP', 'BORUP')")
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
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN', 'RECRUITER', 'HR_BP', 'BORUP')")
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
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN')")
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
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN', 'RECRUITER', 'HR_BP', 'BORUP')")
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
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN', 'HR_BP', 'BORUP')")
    public ResponseEntity<SalaryStatsDto> getSalaryStats(
            @RequestParam(required = false) Long dzoId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {

        AnalyticsFilterRequest filter = new AnalyticsFilterRequest(dzoId, startDate, endDate);
        return ResponseEntity.ok(analyticsService.getSalaryStats(filter));
    }
}
