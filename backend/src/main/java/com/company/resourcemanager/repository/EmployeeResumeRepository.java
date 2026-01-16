package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.EmployeeResume;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EmployeeResumeRepository extends JpaRepository<EmployeeResume, Long> {

    Optional<EmployeeResume> findByEmployeeId(Long employeeId);

    boolean existsByEmployeeId(Long employeeId);

    @Query("SELECT r FROM EmployeeResume r JOIN r.employee e WHERE LOWER(e.fullName) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<EmployeeResume> searchByEmployeeName(@Param("query") String query);

    @Query("SELECT r FROM EmployeeResume r JOIN FETCH r.employee")
    List<EmployeeResume> findAllWithEmployees();

    void deleteByEmployeeId(Long employeeId);
}
