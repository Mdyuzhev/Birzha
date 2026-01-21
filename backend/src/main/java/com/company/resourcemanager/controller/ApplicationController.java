package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.*;
import com.company.resourcemanager.entity.ApplicationStatus;
import com.company.resourcemanager.service.ApplicationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

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
    @PreAuthorize("hasAnyAuthority('MANAGER', 'HR_BP')")
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
    @PreAuthorize("hasAnyAuthority('MANAGER', 'HR_BP')")
    public ResponseEntity<Page<ApplicationDto>> getMyApplications(
            @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable) {
        return ResponseEntity.ok(applicationService.getMyApplications(pageable));
    }

    @GetMapping("/assigned")
    @PreAuthorize("hasAuthority('RECRUITER')")
    public ResponseEntity<Page<ApplicationDto>> getAssignedToMe(
            @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable) {
        return ResponseEntity.ok(applicationService.getAssignedToMe(pageable));
    }

    @GetMapping("/pending-approval")
    @PreAuthorize("hasAnyAuthority('HR_BP', 'BORUP')")
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
    @PreAuthorize("hasAnyAuthority('SYSTEM_ADMIN', 'DZO_ADMIN', 'RECRUITER')")
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
