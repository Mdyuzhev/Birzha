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
