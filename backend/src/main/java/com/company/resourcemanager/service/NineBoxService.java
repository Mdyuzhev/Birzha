package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.*;
import com.company.resourcemanager.entity.*;
import com.company.resourcemanager.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NineBoxService {

    private final NineBoxAssessmentRepository repository;
    private final EmployeeRepository employeeRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<NineBoxAssessmentDTO> getAll() {
        return repository.findAllWithDetails().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public Optional<NineBoxAssessmentDTO> getByEmployeeId(Long employeeId) {
        return repository.findByEmployeeId(employeeId).map(this::toDTO);
    }

    @Transactional(readOnly = true)
    public List<NineBoxAssessmentDTO> getByBoxPosition(Integer boxPosition) {
        return repository.findByBoxPosition(boxPosition).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public NineBoxAssessmentDTO createOrUpdate(NineBoxCreateDTO dto, String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Employee employee = employeeRepository.findById(dto.getEmployeeId())
                .orElseThrow(() -> new RuntimeException("Employee not found"));

        NineBoxAssessment assessment = repository.findByEmployeeId(dto.getEmployeeId())
                .orElse(new NineBoxAssessment());

        assessment.setEmployee(employee);
        assessment.setAssessedBy(user);
        assessment.setQ1Results(dto.getQ1Results());
        assessment.setQ2Goals(dto.getQ2Goals());
        assessment.setQ3Quality(dto.getQ3Quality());
        assessment.setQ4Growth(dto.getQ4Growth());
        assessment.setQ5Leadership(dto.getQ5Leadership());
        assessment.setComment(dto.getComment());

        NineBoxAssessment saved = repository.save(assessment);
        return toDTO(saved);
    }

    @Transactional
    public void delete(Long id) {
        repository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public Map<String, Object> getStatistics() {
        Map<String, Object> stats = new HashMap<>();

        // Общее распределение по боксам
        Map<Integer, Long> boxDistribution = new HashMap<>();
        for (int i = 1; i <= 9; i++) {
            boxDistribution.put(i, 0L);
        }
        repository.countByBoxPosition().forEach(row -> {
            Integer box = (Integer) row[0];
            Long count = (Long) row[1];
            boxDistribution.put(box, count);
        });
        stats.put("boxDistribution", boxDistribution);

        // По подразделениям
        Map<String, Map<Integer, Long>> byDepartment = new LinkedHashMap<>();
        repository.getStatsByDepartment().forEach(row -> {
            String dept = (String) row[0];
            Integer box = (Integer) row[1];
            Long count = ((Number) row[2]).longValue();
            byDepartment.computeIfAbsent(dept, k -> new HashMap<>()).put(box, count);
        });
        stats.put("byDepartment", byDepartment);

        // По должностям
        Map<String, Map<Integer, Long>> byPosition = new LinkedHashMap<>();
        repository.getStatsByPosition().forEach(row -> {
            String pos = (String) row[0];
            Integer box = (Integer) row[1];
            Long count = ((Number) row[2]).longValue();
            byPosition.computeIfAbsent(pos, k -> new HashMap<>()).put(box, count);
        });
        stats.put("byPosition", byPosition);

        // Общее количество оценок
        stats.put("totalAssessments", repository.count());

        return stats;
    }

    private NineBoxAssessmentDTO toDTO(NineBoxAssessment entity) {
        Map<String, Object> customFields = entity.getEmployee().getCustomFields();

        return NineBoxAssessmentDTO.builder()
                .id(entity.getId())
                .employeeId(entity.getEmployee().getId())
                .employeeFullName(entity.getEmployee().getFullName())
                .employeeDepartment(customFields != null ? (String) customFields.get("department") : null)
                .employeePosition(customFields != null ? (String) customFields.get("position") : null)
                .assessedById(entity.getAssessedBy().getId())
                .assessedByUsername(entity.getAssessedBy().getUsername())
                .assessedAt(entity.getAssessedAt())
                .q1Results(entity.getQ1Results())
                .q2Goals(entity.getQ2Goals())
                .q3Quality(entity.getQ3Quality())
                .q4Growth(entity.getQ4Growth())
                .q5Leadership(entity.getQ5Leadership())
                .performanceScore(entity.getPerformanceScore())
                .potentialScore(entity.getPotentialScore())
                .boxPosition(entity.getBoxPosition())
                .boxName(NineBoxAssessmentDTO.getBoxName(entity.getBoxPosition()))
                .comment(entity.getComment())
                .build();
    }
}
