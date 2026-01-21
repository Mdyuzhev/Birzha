package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.BlacklistHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BlacklistHistoryRepository extends JpaRepository<BlacklistHistory, Long> {

    List<BlacklistHistory> findByBlacklistEntryIdOrderByChangedAtDesc(Long blacklistEntryId);

    List<BlacklistHistory> findByBlacklistEntryIdAndAction(Long blacklistEntryId, String action);
}
