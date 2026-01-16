package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.UserSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface UserSessionRepository extends JpaRepository<UserSession, Long> {

    Optional<UserSession> findByUserId(Long userId);

    Optional<UserSession> findBySessionToken(String sessionToken);

    void deleteByUserId(Long userId);

    void deleteBySessionToken(String sessionToken);

    @Modifying
    @Query("DELETE FROM UserSession s WHERE s.lastActivity < :threshold")
    void deleteInactiveSessions(LocalDateTime threshold);

    boolean existsByUserId(Long userId);
}
