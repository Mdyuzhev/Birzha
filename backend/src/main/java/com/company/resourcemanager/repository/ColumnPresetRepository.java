package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.ColumnPreset;
import com.company.resourcemanager.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ColumnPresetRepository extends JpaRepository<ColumnPreset, Long> {

    List<ColumnPreset> findByUserOrderByNameAsc(User user);

    List<ColumnPreset> findByUserIdOrderByNameAsc(Long userId);

    // Get user's own presets + global presets from other users
    @Query("SELECT cp FROM ColumnPreset cp WHERE cp.user.id = :userId OR cp.isGlobal = true ORDER BY cp.name")
    List<ColumnPreset> findByUserIdOrGlobalOrderByNameAsc(Long userId);

    Optional<ColumnPreset> findByIdAndUserId(Long id, Long userId);

    Optional<ColumnPreset> findByUserIdAndName(Long userId, String name);

    Optional<ColumnPreset> findByUserIdAndIsDefaultTrue(Long userId);

    boolean existsByUserIdAndName(Long userId, String name);

    @Modifying
    @Query("UPDATE ColumnPreset cp SET cp.isDefault = false WHERE cp.user.id = :userId")
    void clearDefaultForUser(Long userId);
}
