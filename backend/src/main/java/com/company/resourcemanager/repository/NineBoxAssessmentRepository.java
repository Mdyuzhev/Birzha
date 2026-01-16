package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.NineBoxAssessment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NineBoxAssessmentRepository extends JpaRepository<NineBoxAssessment, Long> {

    Optional<NineBoxAssessment> findByEmployeeId(Long employeeId);

    boolean existsByEmployeeId(Long employeeId);

    @Query("SELECT n FROM NineBoxAssessment n JOIN FETCH n.employee JOIN FETCH n.assessedBy ORDER BY n.assessedAt DESC")
    List<NineBoxAssessment> findAllWithDetails();

    @Query("SELECT n FROM NineBoxAssessment n JOIN FETCH n.employee JOIN FETCH n.assessedBy WHERE n.boxPosition = :boxPosition")
    List<NineBoxAssessment> findByBoxPosition(Integer boxPosition);

    @Query("SELECT n.boxPosition, COUNT(n) FROM NineBoxAssessment n GROUP BY n.boxPosition")
    List<Object[]> countByBoxPosition();

    @Query(value = """
        SELECT e.custom_fields->>'department' as department, n.box_position, COUNT(*)
        FROM nine_box_assessments n
        JOIN employees e ON n.employee_id = e.id
        WHERE e.custom_fields->>'department' IS NOT NULL
        GROUP BY e.custom_fields->>'department', n.box_position
        ORDER BY department, box_position
        """, nativeQuery = true)
    List<Object[]> getStatsByDepartment();

    @Query(value = """
        SELECT e.custom_fields->>'position' as position, n.box_position, COUNT(*)
        FROM nine_box_assessments n
        JOIN employees e ON n.employee_id = e.id
        WHERE e.custom_fields->>'position' IS NOT NULL
        GROUP BY e.custom_fields->>'position', n.box_position
        ORDER BY position, box_position
        """, nativeQuery = true)
    List<Object[]> getStatsByPosition();
}
