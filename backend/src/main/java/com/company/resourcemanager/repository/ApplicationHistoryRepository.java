package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.ApplicationHistory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ApplicationHistoryRepository extends JpaRepository<ApplicationHistory, Long> {
    List<ApplicationHistory> findByApplicationIdOrderByChangedAtDesc(Long applicationId);
    List<ApplicationHistory> findByApplicationIdAndAction(Long applicationId, String action);
}
