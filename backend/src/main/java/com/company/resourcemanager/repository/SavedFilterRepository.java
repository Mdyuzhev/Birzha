package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.SavedFilter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SavedFilterRepository extends JpaRepository<SavedFilter, Long> {

    List<SavedFilter> findByUserIdOrderByNameAsc(Long userId);

    @Query("SELECT sf FROM SavedFilter sf WHERE sf.user.id = :userId OR sf.isGlobal = true ORDER BY sf.name")
    List<SavedFilter> findByUserIdOrGlobalOrderByNameAsc(Long userId);

    Optional<SavedFilter> findByIdAndUserId(Long id, Long userId);

    Optional<SavedFilter> findByUserIdAndName(Long userId, String name);

    Optional<SavedFilter> findByUserIdAndIsDefaultTrue(Long userId);

    boolean existsByUserIdAndName(Long userId, String name);

    @Modifying
    @Query("UPDATE SavedFilter sf SET sf.isDefault = false WHERE sf.user.id = :userId")
    void clearDefaultForUser(Long userId);
}
