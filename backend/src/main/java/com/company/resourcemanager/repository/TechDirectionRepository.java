package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.TechDirection;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface TechDirectionRepository extends JpaRepository<TechDirection, Long> {
    Optional<TechDirection> findByCode(String code);
    List<TechDirection> findByIsActiveTrueOrderBySortOrderAsc();
}
