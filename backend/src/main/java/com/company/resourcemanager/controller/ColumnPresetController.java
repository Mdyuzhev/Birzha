package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.ColumnPresetDto;
import com.company.resourcemanager.dto.CreateColumnPresetRequest;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.repository.UserRepository;
import com.company.resourcemanager.service.ColumnPresetService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/column-presets")
@RequiredArgsConstructor
public class ColumnPresetController {

    private final ColumnPresetService presetService;
    private final UserRepository userRepository;

    @GetMapping
    public ResponseEntity<List<ColumnPresetDto>> getUserPresets() {
        Long userId = getCurrentUserId();
        return ResponseEntity.ok(presetService.getUserPresets(userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ColumnPresetDto> getPreset(@PathVariable Long id) {
        Long userId = getCurrentUserId();
        ColumnPresetDto preset = presetService.getPresetById(id, userId);
        if (preset == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(preset);
    }

    @GetMapping("/default")
    public ResponseEntity<ColumnPresetDto> getDefaultPreset() {
        Long userId = getCurrentUserId();
        ColumnPresetDto preset = presetService.getDefaultPreset(userId);
        if (preset == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(preset);
    }

    @PostMapping
    public ResponseEntity<?> createPreset(@Valid @RequestBody CreateColumnPresetRequest request) {
        Long userId = getCurrentUserId();
        try {
            ColumnPresetDto created = presetService.createPreset(request, userId);
            return ResponseEntity.ok(created);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updatePreset(
            @PathVariable Long id,
            @Valid @RequestBody CreateColumnPresetRequest request) {
        Long userId = getCurrentUserId();
        try {
            ColumnPresetDto updated = presetService.updatePreset(id, request, userId);
            return ResponseEntity.ok(updated);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePreset(@PathVariable Long id) {
        Long userId = getCurrentUserId();
        try {
            presetService.deletePreset(id, userId);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/{id}/set-default")
    public ResponseEntity<?> setAsDefault(@PathVariable Long id) {
        Long userId = getCurrentUserId();
        try {
            ColumnPresetDto updated = presetService.setAsDefault(id, userId);
            return ResponseEntity.ok(updated);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
    }

    private Long getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        User user = userRepository.findByUsername(username).orElse(null);
        return user != null ? user.getId() : null;
    }

    private record ErrorResponse(String message) {}
}
