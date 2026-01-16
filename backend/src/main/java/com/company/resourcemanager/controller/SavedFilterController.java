package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.CreateSavedFilterRequest;
import com.company.resourcemanager.dto.SavedFilterDto;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.repository.UserRepository;
import com.company.resourcemanager.service.SavedFilterService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/saved-filters")
@RequiredArgsConstructor
public class SavedFilterController {

    private final SavedFilterService filterService;
    private final UserRepository userRepository;

    @GetMapping
    public ResponseEntity<List<SavedFilterDto>> getUserFilters() {
        Long userId = getCurrentUserId();
        return ResponseEntity.ok(filterService.getUserFilters(userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<SavedFilterDto> getFilter(@PathVariable Long id) {
        Long userId = getCurrentUserId();
        SavedFilterDto filter = filterService.getFilterById(id, userId);
        if (filter == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(filter);
    }

    @GetMapping("/default")
    public ResponseEntity<SavedFilterDto> getDefaultFilter() {
        Long userId = getCurrentUserId();
        SavedFilterDto filter = filterService.getDefaultFilter(userId);
        if (filter == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(filter);
    }

    @PostMapping
    public ResponseEntity<?> createFilter(@Valid @RequestBody CreateSavedFilterRequest request) {
        Long userId = getCurrentUserId();
        try {
            SavedFilterDto created = filterService.createFilter(request, userId);
            return ResponseEntity.ok(created);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateFilter(
            @PathVariable Long id,
            @Valid @RequestBody CreateSavedFilterRequest request) {
        Long userId = getCurrentUserId();
        try {
            SavedFilterDto updated = filterService.updateFilter(id, request, userId);
            return ResponseEntity.ok(updated);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteFilter(@PathVariable Long id) {
        Long userId = getCurrentUserId();
        try {
            filterService.deleteFilter(id, userId);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/{id}/set-default")
    public ResponseEntity<?> setAsDefault(@PathVariable Long id) {
        Long userId = getCurrentUserId();
        try {
            SavedFilterDto updated = filterService.setAsDefault(id, userId);
            return ResponseEntity.ok(updated);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
    }

    @PostMapping("/{id}/toggle-global")
    public ResponseEntity<?> toggleGlobal(@PathVariable Long id) {
        Long userId = getCurrentUserId();
        try {
            SavedFilterDto updated = filterService.toggleGlobal(id, userId);
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
