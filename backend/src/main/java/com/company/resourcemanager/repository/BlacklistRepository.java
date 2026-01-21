package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.BlacklistEntry;
import com.company.resourcemanager.entity.BlacklistReasonCategory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface BlacklistRepository extends JpaRepository<BlacklistEntry, Long> {

    // === Поиск по ДЗО ===

    Page<BlacklistEntry> findByDzoId(Long dzoId, Pageable pageable);

    Page<BlacklistEntry> findByDzoIdAndIsActive(Long dzoId, Boolean isActive, Pageable pageable);

    // === Поиск по сотруднику ===

    Optional<BlacklistEntry> findByEmployeeIdAndIsActiveTrue(Long employeeId);

    List<BlacklistEntry> findByEmployeeId(Long employeeId);

    boolean existsByEmployeeIdAndIsActiveTrue(Long employeeId);

    // === Поиск по email ===

    Optional<BlacklistEntry> findByEmailIgnoreCaseAndDzoIdAndIsActiveTrue(String email, Long dzoId);

    List<BlacklistEntry> findByEmailIgnoreCaseAndIsActiveTrue(String email);

    boolean existsByEmailIgnoreCaseAndDzoIdAndIsActiveTrue(String email, Long dzoId);

    // === Поиск по ФИО ===

    @Query("SELECT b FROM BlacklistEntry b WHERE b.dzo.id = :dzoId AND b.isActive = true " +
           "AND LOWER(b.fullName) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<BlacklistEntry> findByFullNameContainingAndDzoIdAndIsActiveTrue(
            @Param("name") String name, @Param("dzoId") Long dzoId);

    // === Полнотекстовый поиск ===

    @Query(value = "SELECT * FROM blacklist b WHERE b.dzo_id = :dzoId AND b.is_active = :isActive " +
           "AND to_tsvector('russian', b.full_name || ' ' || COALESCE(b.email, '') || ' ' || COALESCE(b.reason, '')) " +
           "@@ plainto_tsquery('russian', :search)",
           countQuery = "SELECT COUNT(*) FROM blacklist b WHERE b.dzo_id = :dzoId AND b.is_active = :isActive " +
           "AND to_tsvector('russian', b.full_name || ' ' || COALESCE(b.email, '') || ' ' || COALESCE(b.reason, '')) " +
           "@@ plainto_tsquery('russian', :search)",
           nativeQuery = true)
    Page<BlacklistEntry> searchFullText(@Param("dzoId") Long dzoId,
                                        @Param("isActive") Boolean isActive,
                                        @Param("search") String search,
                                        Pageable pageable);

    // === Фильтрация по категории ===

    Page<BlacklistEntry> findByDzoIdAndReasonCategoryAndIsActive(
            Long dzoId, BlacklistReasonCategory category, Boolean isActive, Pageable pageable);

    // === Истекшие записи ===

    @Query("SELECT b FROM BlacklistEntry b WHERE b.isActive = true AND b.expiresAt IS NOT NULL " +
           "AND b.expiresAt < :now")
    List<BlacklistEntry> findExpiredEntries(@Param("now") LocalDateTime now);

    // === Статистика ===

    @Query("SELECT b.reasonCategory, COUNT(b) FROM BlacklistEntry b " +
           "WHERE b.dzo.id = :dzoId AND b.isActive = true GROUP BY b.reasonCategory")
    List<Object[]> countByReasonCategoryForDzo(@Param("dzoId") Long dzoId);

    long countByDzoIdAndIsActiveTrue(Long dzoId);

    // === Проверка при создании заявки ===

    @Query("SELECT b FROM BlacklistEntry b WHERE b.dzo.id = :dzoId AND b.isActive = true " +
           "AND (b.expiresAt IS NULL OR b.expiresAt > :now) " +
           "AND (b.employee.id = :employeeId OR LOWER(b.email) = LOWER(:email))")
    List<BlacklistEntry> findActiveEntriesForEmployee(@Param("dzoId") Long dzoId,
                                                      @Param("employeeId") Long employeeId,
                                                      @Param("email") String email,
                                                      @Param("now") LocalDateTime now);
}
