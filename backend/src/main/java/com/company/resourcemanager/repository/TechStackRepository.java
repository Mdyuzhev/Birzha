package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.TechStack;
import com.company.resourcemanager.entity.TechStackStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;
import java.util.Optional;

public interface TechStackRepository extends JpaRepository<TechStack, Long> {

    List<TechStack> findByDirectionIdAndIsActiveTrueOrderBySortOrderAsc(Long directionId);

    @Query("SELECT s FROM TechStack s WHERE s.status = :status AND s.isActive = true " +
           "ORDER BY s.direction.sortOrder ASC, s.sortOrder ASC")
    List<TechStack> findByStatusAndIsActiveTrueOrderByDirectionSortOrderAscSortOrderAsc(TechStackStatus status);

    List<TechStack> findByStatusOrderByCreatedAtDesc(TechStackStatus status);

    Optional<TechStack> findByCode(String code);

    boolean existsByDirectionIdAndCode(Long directionId, String code);

    @Query("SELECT s FROM TechStack s WHERE s.status = 'ACTIVE' AND s.isActive = true " +
           "AND (LOWER(s.name) LIKE LOWER(CONCAT('%', :q, '%')) OR LOWER(s.code) LIKE LOWER(CONCAT('%', :q, '%')))")
    List<TechStack> search(String q);

    long countByStatus(TechStackStatus status);
}
