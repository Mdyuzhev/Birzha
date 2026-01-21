package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.Dzo;
import com.company.resourcemanager.entity.HrBpAssignment;
import com.company.resourcemanager.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface HrBpAssignmentRepository extends JpaRepository<HrBpAssignment, Long> {

    List<HrBpAssignment> findByUserId(Long userId);

    List<HrBpAssignment> findByDzoId(Long dzoId);

    Optional<HrBpAssignment> findByUserIdAndDzoId(Long userId, Long dzoId);

    boolean existsByUserIdAndDzoId(Long userId, Long dzoId);

    void deleteByUserIdAndDzoId(Long userId, Long dzoId);

    void deleteByUserId(Long userId);

    void deleteByDzoId(Long dzoId);

    @Query("SELECT a.dzo FROM HrBpAssignment a WHERE a.user.id = :userId")
    List<Dzo> findDzosByUserId(@Param("userId") Long userId);

    @Query("SELECT a.user FROM HrBpAssignment a WHERE a.dzo.id = :dzoId")
    List<User> findUsersByDzoId(@Param("dzoId") Long dzoId);
}
