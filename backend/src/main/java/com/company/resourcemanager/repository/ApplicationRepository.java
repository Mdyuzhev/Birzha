package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.Application;
import com.company.resourcemanager.entity.ApplicationStatus;
import com.company.resourcemanager.entity.DecisionType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ApplicationRepository extends JpaRepository<Application, Long> {

    // По ДЗО
    Page<Application> findByDzoId(Long dzoId, Pageable pageable);
    List<Application> findByDzoId(Long dzoId);
    long countByDzoId(Long dzoId);

    // По статусу
    Page<Application> findByDzoIdAndStatus(Long dzoId, ApplicationStatus status, Pageable pageable);
    List<Application> findByDzoIdAndStatusIn(Long dzoId, List<ApplicationStatus> statuses);
    long countByDzoIdAndStatus(Long dzoId, ApplicationStatus status);

    // По сотруднику
    List<Application> findByEmployeeId(Long employeeId);
    Optional<Application> findByEmployeeIdAndStatusNotIn(Long employeeId, List<ApplicationStatus> finalStatuses);

    // По создателю (для Руководителя)
    Page<Application> findByCreatedById(Long userId, Pageable pageable);
    List<Application> findByCreatedByIdAndDzoId(Long userId, Long dzoId);

    // По рекрутеру
    Page<Application> findByRecruiterId(Long recruiterId, Pageable pageable);
    List<Application> findByRecruiterIdAndStatusIn(Long recruiterId, List<ApplicationStatus> statuses);

    // По HR BP
    Page<Application> findByHrBpIdAndStatus(Long hrBpId, ApplicationStatus status, Pageable pageable);
    List<Application> findByHrBpIdAndHrBpDecision(Long hrBpId, DecisionType decision);

    // По БОРУП
    Page<Application> findByBorupIdAndStatus(Long borupId, ApplicationStatus status, Pageable pageable);

    // Для дашборда
    @Query("SELECT a.status, COUNT(a) FROM Application a WHERE a.dzo.id = :dzoId GROUP BY a.status")
    List<Object[]> countByStatusForDzo(@Param("dzoId") Long dzoId);

    @Query("SELECT a.targetStack, COUNT(a) FROM Application a WHERE a.dzo.id = :dzoId GROUP BY a.targetStack")
    List<Object[]> countByStackForDzo(@Param("dzoId") Long dzoId);

    // Поиск
    @Query("SELECT a FROM Application a WHERE a.dzo.id = :dzoId AND " +
           "(LOWER(a.employee.fullName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(a.targetPosition) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(a.targetStack) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Application> searchByDzo(@Param("dzoId") Long dzoId, @Param("search") String search, Pageable pageable);
}
