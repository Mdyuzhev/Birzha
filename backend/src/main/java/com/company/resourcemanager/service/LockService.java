package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.LockInfoDto;
import com.company.resourcemanager.entity.RecordLock;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.repository.RecordLockRepository;
import com.company.resourcemanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class LockService {

    private static final int LOCK_DURATION_MINUTES = 5;

    private final RecordLockRepository lockRepository;
    private final UserRepository userRepository;

    @Transactional
    public LockInfoDto acquireLock(String entityType, Long entityId, Long userId) {
        // Clean expired locks first
        lockRepository.deleteExpiredLocks(LocalDateTime.now());

        Optional<RecordLock> existingLock = lockRepository.findByEntityTypeAndEntityId(entityType, entityId);

        if (existingLock.isPresent()) {
            RecordLock lock = existingLock.get();
            if (lock.getLockedBy().getId().equals(userId)) {
                // Extend own lock
                lock.setExpiresAt(LocalDateTime.now().plusMinutes(LOCK_DURATION_MINUTES));
                lockRepository.save(lock);
                return toDto(lock, userId, true);
            } else {
                // Locked by someone else
                return toDto(lock, userId, false);
            }
        }

        // Create new lock
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        RecordLock newLock = RecordLock.builder()
                .entityType(entityType)
                .entityId(entityId)
                .lockedBy(user)
                .lockedAt(LocalDateTime.now())
                .expiresAt(LocalDateTime.now().plusMinutes(LOCK_DURATION_MINUTES))
                .build();

        RecordLock saved = lockRepository.save(newLock);
        return toDto(saved, userId, true);
    }

    @Transactional
    public LockInfoDto renewLock(String entityType, Long entityId, Long userId) {
        Optional<RecordLock> existingLock = lockRepository.findByEntityTypeAndEntityIdAndLockedById(entityType, entityId, userId);

        if (existingLock.isPresent()) {
            RecordLock lock = existingLock.get();
            lock.setExpiresAt(LocalDateTime.now().plusMinutes(LOCK_DURATION_MINUTES));
            lockRepository.save(lock);
            return toDto(lock, userId, true);
        }

        // Lock not found or owned by someone else - try to acquire
        return acquireLock(entityType, entityId, userId);
    }

    @Transactional
    public void releaseLock(String entityType, Long entityId, Long userId) {
        lockRepository.deleteByEntityTypeAndEntityIdAndLockedById(entityType, entityId, userId);
    }

    @Transactional(readOnly = true)
    public LockInfoDto getLockStatus(String entityType, Long entityId, Long userId) {
        Optional<RecordLock> existingLock = lockRepository.findByEntityTypeAndEntityId(entityType, entityId);

        if (existingLock.isPresent()) {
            RecordLock lock = existingLock.get();
            if (lock.getExpiresAt().isBefore(LocalDateTime.now())) {
                // Lock expired
                return LockInfoDto.builder()
                        .locked(false)
                        .ownLock(false)
                        .build();
            }
            return toDto(lock, userId, lock.getLockedBy().getId().equals(userId));
        }

        return LockInfoDto.builder()
                .locked(false)
                .ownLock(false)
                .build();
    }

    @Scheduled(fixedRate = 60000) // Every minute
    @Transactional
    public void cleanupExpiredLocks() {
        lockRepository.deleteExpiredLocks(LocalDateTime.now());
        log.debug("Cleaned up expired locks");
    }

    private LockInfoDto toDto(RecordLock lock, Long currentUserId, boolean ownLock) {
        return LockInfoDto.builder()
                .locked(true)
                .lockedById(lock.getLockedBy().getId())
                .lockedByName(lock.getLockedBy().getUsername())
                .lockedAt(lock.getLockedAt())
                .expiresAt(lock.getExpiresAt())
                .ownLock(ownLock)
                .build();
    }
}
