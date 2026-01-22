package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.Application;
import com.company.resourcemanager.entity.ApplicationStatus;
import com.company.resourcemanager.entity.DecisionType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
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
    Page<Application> findByHrBpId(Long hrBpId, Pageable pageable);
    Page<Application> findByHrBpIdAndStatus(Long hrBpId, ApplicationStatus status, Pageable pageable);
    List<Application> findByHrBpIdAndHrBpDecision(Long hrBpId, DecisionType decision);

    // По БОРУП
    Page<Application> findByBorupId(Long borupId, Pageable pageable);
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

    // === Аналитика ===

    @Query("""
        SELECT a.status, COUNT(a) FROM Application a
        WHERE (:dzoId IS NULL OR a.dzo.id = :dzoId)
        AND a.createdAt >= :startDate AND a.createdAt <= :endDate
        GROUP BY a.status
        """)
    List<Object[]> countByStatusForPeriod(
        @Param("dzoId") Long dzoId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    @Query("""
        SELECT a.targetStack, COUNT(a) FROM Application a
        WHERE (:dzoId IS NULL OR a.dzo.id = :dzoId)
        AND a.createdAt >= :startDate AND a.createdAt <= :endDate
        AND a.targetStack IS NOT NULL
        GROUP BY a.targetStack
        ORDER BY COUNT(a) DESC
        """)
    List<Object[]> countByStackForPeriod(
        @Param("dzoId") Long dzoId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    @Query("""
        SELECT a.dzo.id, a.dzo.name, COUNT(a) FROM Application a
        WHERE a.createdAt >= :startDate AND a.createdAt <= :endDate
        GROUP BY a.dzo.id, a.dzo.name
        ORDER BY COUNT(a) DESC
        """)
    List<Object[]> countByDzoForPeriod(
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    @Query("""
        SELECT COUNT(a) FROM Application a
        WHERE (:dzoId IS NULL OR a.dzo.id = :dzoId)
        AND a.createdAt >= :startDate AND a.createdAt <= :endDate
        """)
    long countCreatedForPeriod(
        @Param("dzoId") Long dzoId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    @Query("""
        SELECT COUNT(a) FROM Application a
        WHERE (:dzoId IS NULL OR a.dzo.id = :dzoId)
        AND a.status IN :statuses
        AND a.createdAt >= :startDate AND a.createdAt <= :endDate
        """)
    long countReachedStatusForPeriod(
        @Param("dzoId") Long dzoId,
        @Param("statuses") List<ApplicationStatus> statuses,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    @Query("""
        SELECT COUNT(a) FROM Application a
        WHERE (:dzoId IS NULL OR a.dzo.id = :dzoId)
        AND a.status = :status
        AND a.createdAt >= :startDate AND a.createdAt <= :endDate
        """)
    long countByStatusForPeriod(
        @Param("dzoId") Long dzoId,
        @Param("status") ApplicationStatus status,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    @Query(value = """
        SELECT AVG(EXTRACT(EPOCH FROM (completed_at - created_at)) / 86400)
        FROM applications
        WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
        AND completed_at IS NOT NULL
        AND created_at >= :startDate AND created_at <= :endDate
        """, nativeQuery = true)
    Double avgDaysToComplete(
        @Param("dzoId") Long dzoId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    @Query(value = """
        SELECT AVG(EXTRACT(EPOCH FROM (hr_bp_decision_at - created_at)) / 86400)
        FROM applications
        WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
        AND hr_bp_decision_at IS NOT NULL
        AND created_at >= :startDate AND created_at <= :endDate
        """, nativeQuery = true)
    Double avgDaysToHrBp(
        @Param("dzoId") Long dzoId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    @Query(value = """
        SELECT AVG(EXTRACT(EPOCH FROM (hr_bp_decision_at - assigned_to_recruiter_at)) / 86400)
        FROM applications
        WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
        AND hr_bp_decision_at IS NOT NULL AND assigned_to_recruiter_at IS NOT NULL
        AND created_at >= :startDate AND created_at <= :endDate
        """, nativeQuery = true)
    Double avgDaysHrBpDecision(
        @Param("dzoId") Long dzoId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    @Query(value = """
        SELECT AVG(EXTRACT(EPOCH FROM (borup_decision_at - hr_bp_decision_at)) / 86400)
        FROM applications
        WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
        AND borup_decision_at IS NOT NULL
        AND created_at >= :startDate AND created_at <= :endDate
        """, nativeQuery = true)
    Double avgDaysToBorup(
        @Param("dzoId") Long dzoId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    @Query(value = """
        SELECT AVG(EXTRACT(EPOCH FROM (borup_decision_at - hr_bp_decision_at)) / 86400)
        FROM applications
        WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
        AND borup_decision_at IS NOT NULL AND hr_bp_decision_at IS NOT NULL
        AND created_at >= :startDate AND created_at <= :endDate
        """, nativeQuery = true)
    Double avgDaysBorupDecision(
        @Param("dzoId") Long dzoId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    @Query(value = """
        SELECT
            u.id,
            u.username,
            COUNT(CASE WHEN a.status IN ('TRANSFERRED', 'DISMISSED') THEN 1 END) as completed,
            COUNT(CASE WHEN a.status NOT IN ('TRANSFERRED', 'DISMISSED', 'CANCELLED') THEN 1 END) as in_progress,
            AVG(CASE WHEN a.completed_at IS NOT NULL
                THEN EXTRACT(EPOCH FROM (a.completed_at - a.assigned_to_recruiter_at)) / 86400 END) as avg_days
        FROM applications a
        JOIN users u ON a.recruiter_id = u.id
        WHERE (:dzoId IS NULL OR a.dzo_id = :dzoId)
        AND a.created_at >= :startDate AND a.created_at <= :endDate
        GROUP BY u.id, u.username
        ORDER BY completed DESC
        LIMIT :limit
        """, nativeQuery = true)
    List<Object[]> topRecruitersByCompleted(
        @Param("dzoId") Long dzoId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate,
        @Param("limit") int limit
    );

    @Query(value = """
        SELECT
            EXTRACT(YEAR FROM created_at) as year,
            EXTRACT(MONTH FROM created_at) as month,
            COUNT(*) as created,
            COUNT(CASE WHEN status IN ('TRANSFERRED', 'DISMISSED') THEN 1 END) as completed,
            COUNT(CASE WHEN status IN ('REJECTED_HR_BP', 'REJECTED_BORUP') THEN 1 END) as rejected
        FROM applications
        WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
        AND created_at >= :startDate AND created_at <= :endDate
        GROUP BY EXTRACT(YEAR FROM created_at), EXTRACT(MONTH FROM created_at)
        ORDER BY year, month
        """, nativeQuery = true)
    List<Object[]> monthlyTrend(
        @Param("dzoId") Long dzoId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    @Query(value = """
        SELECT
            AVG(current_salary),
            AVG(target_salary),
            AVG(salary_increase_percent),
            MAX(salary_increase_percent),
            COUNT(CASE WHEN requires_borup_approval = true THEN 1 END)
        FROM applications
        WHERE (:dzoId IS NULL OR dzo_id = :dzoId)
        AND created_at >= :startDate AND created_at <= :endDate
        AND current_salary IS NOT NULL AND target_salary IS NOT NULL
        """, nativeQuery = true)
    Object[] salaryStats(
        @Param("dzoId") Long dzoId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );
}
