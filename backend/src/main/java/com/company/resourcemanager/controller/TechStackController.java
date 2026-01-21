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
