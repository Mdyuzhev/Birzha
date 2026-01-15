package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.EmployeeHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import org.springframework.data.domain.Pageable;
import java.util.List;

@Repository
public interface EmployeeHistoryRepository extends JpaRepository<EmployeeHistory, Long> {
    List<EmployeeHistory> findByEmployeeIdOrderByChangedAtDesc(Long employeeId);

    List<EmployeeHistory> findAllByOrderByChangedAtDesc(Pageable pageable);
}
