package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.RecordLock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface RecordLockRepository extends JpaRepository<RecordLock, Long> {

    Optional<RecordLock> findByEntityTypeAndEntityId(String entityType, Long entityId);

    Optional<RecordLock> findByEntityTypeAndEntityIdAndLockedById(String entityType, Long entityId, Long userId);

    @Modifying
    @Query("DELETE FROM RecordLock rl WHERE rl.expiresAt < :now")
    void deleteExpiredLocks(LocalDateTime now);

    @Modifying
    @Query("DELETE FROM RecordLock rl WHERE rl.entityType = :entityType AND rl.entityId = :entityId AND rl.lockedBy.id = :userId")
    void deleteByEntityTypeAndEntityIdAndLockedById(String entityType, Long entityId, Long userId);
}
