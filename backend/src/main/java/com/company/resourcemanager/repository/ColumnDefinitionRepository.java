package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.ColumnDefinition;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ColumnDefinitionRepository extends JpaRepository<ColumnDefinition, Long> {
    List<ColumnDefinition> findAllByOrderBySortOrderAsc();
}
