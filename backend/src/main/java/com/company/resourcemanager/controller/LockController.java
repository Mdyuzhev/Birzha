package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.LockInfoDto;
import com.company.resourcemanager.dto.LockRequest;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.repository.UserRepository;
import com.company.resourcemanager.service.LockService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/locks")
@RequiredArgsConstructor
public class LockController {

    private final LockService lockService;
    private final UserRepository userRepository;

    @PostMapping("/acquire")
    public ResponseEntity<LockInfoDto> acquireLock(@Valid @RequestBody LockRequest request) {
        Long userId = getCurrentUserId();
        LockInfoDto lock = lockService.acquireLock(request.getEntityType(), request.getEntityId(), userId);
        return ResponseEntity.ok(lock);
    }

    @PostMapping("/renew")
    public ResponseEntity<LockInfoDto> renewLock(@Valid @RequestBody LockRequest request) {
        Long userId = getCurrentUserId();
        LockInfoDto lock = lockService.renewLock(request.getEntityType(), request.getEntityId(), userId);
        return ResponseEntity.ok(lock);
    }

    @PostMapping("/release")
    public ResponseEntity<Void> releaseLock(@Valid @RequestBody LockRequest request) {
        Long userId = getCurrentUserId();
        lockService.releaseLock(request.getEntityType(), request.getEntityId(), userId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/status")
    public ResponseEntity<LockInfoDto> getLockStatus(
            @RequestParam String entityType,
            @RequestParam Long entityId) {
        Long userId = getCurrentUserId();
        LockInfoDto lock = lockService.getLockStatus(entityType, entityId, userId);
        return ResponseEntity.ok(lock);
    }

    private Long getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        User user = userRepository.findByUsername(username).orElse(null);
        return user != null ? user.getId() : null;
    }
}
