package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.*;
import com.company.resourcemanager.entity.Employee;
import com.company.resourcemanager.entity.EmployeeHistory;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.exception.ResourceNotFoundException;
import com.company.resourcemanager.repository.EmployeeHistoryRepository;
import com.company.resourcemanager.repository.EmployeeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class EmployeeService {

    private final EmployeeRepository employeeRepository;
    private final EmployeeHistoryRepository historyRepository;
    private final AuthService authService;
    private final CustomFieldsValidator customFieldsValidator;
    private final FullNameValidator fullNameValidator;
    private final CurrentUserService currentUserService;

    public Page<EmployeeDto> findAll(Map<String, String> filters, Map<String, String> customFields,
                                       Map<String, String> dateFilters, Pageable pageable) {
        Specification<Employee> spec = Specification.where(null);

        // Фильтрация по ДЗО (если пользователь не системный админ)
        if (!currentUserService.isSystemAdmin()) {
            Long dzoId = currentUserService.getCurrentDzoId();
            if (dzoId != null) {
                spec = spec.and((root, query, cb) -> cb.equal(root.get("dzo").get("id"), dzoId));
            }
        }

        if (filters != null) {
            for (Map.Entry<String, String> entry : filters.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();

                if (value == null || value.isEmpty()) continue;

                if ("search".equals(key)) {
                    spec = spec.and((root, query, cb) ->
                            cb.or(
                                    cb.like(cb.lower(root.get("fullName")), "%" + value.toLowerCase() + "%"),
                                    cb.like(cb.lower(root.get("email")), "%" + value.toLowerCase() + "%")
                            ));
                } else if ("fullName".equals(key)) {
                    spec = spec.and((root, query, cb) ->
                            cb.like(cb.lower(root.get("fullName")), "%" + value.toLowerCase() + "%"));
                } else if ("email".equals(key)) {
                    spec = spec.and((root, query, cb) ->
                            cb.like(cb.lower(root.get("email")), "%" + value.toLowerCase() + "%"));
                }
            }
        }

        // Фильтрация по customFields (JSONB) - множественные значения через запятую
        if (customFields != null) {
            for (Map.Entry<String, String> entry : customFields.entrySet()) {
                String fieldName = entry.getKey();
                String fieldValue = entry.getValue();

                if (fieldValue == null || fieldValue.isEmpty()) continue;

                String[] values = fieldValue.split(",");
                spec = spec.and((root, query, cb) -> {
                    if (values.length == 1) {
                        return cb.equal(
                            cb.function("jsonb_extract_path_text", String.class,
                                root.get("customFields"), cb.literal(fieldName)),
                            values[0].trim()
                        );
                    } else {
                        jakarta.persistence.criteria.Predicate[] predicates =
                            new jakarta.persistence.criteria.Predicate[values.length];
                        for (int i = 0; i < values.length; i++) {
                            final String val = values[i].trim();
                            predicates[i] = cb.equal(
                                cb.function("jsonb_extract_path_text", String.class,
                                    root.get("customFields"), cb.literal(fieldName)),
                                val
                            );
                        }
                        return cb.or(predicates);
                    }
                });
            }
        }

        // Фильтрация по датам: формат "condition:value" (before, after, equals)
        if (dateFilters != null) {
            for (Map.Entry<String, String> entry : dateFilters.entrySet()) {
                String fieldName = entry.getKey();
                String filterValue = entry.getValue();

                if (filterValue == null || filterValue.isEmpty()) continue;

                String[] parts = filterValue.split(":", 2);
                if (parts.length != 2) continue;

                String condition = parts[0];
                String dateValue = parts[1];

                spec = spec.and((root, query, cb) -> {
                    var jsonValue = cb.function("jsonb_extract_path_text", String.class,
                        root.get("customFields"), cb.literal(fieldName));

                    return switch (condition) {
                        case "before" -> cb.lessThan(jsonValue, dateValue);
                        case "after" -> cb.greaterThan(jsonValue, dateValue);
                        case "equals" -> cb.equal(jsonValue, dateValue);
                        default -> cb.conjunction();
                    };
                });
            }
        }

        return employeeRepository.findAll(spec, pageable).map(this::toDto);
    }

    public EmployeeDto findById(Long id) {
        Employee employee = employeeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with id: " + id));
        return toDto(employee);
    }

    @Transactional
    public EmployeeDto create(CreateEmployeeRequest request) {
        // Валидация ФИО
        fullNameValidator.validate(request.getFullName());
        // Валидация customFields
        customFieldsValidator.validate(request.getCustomFields());

        User currentUser = currentUserService.getCurrentUser();

        Employee employee = Employee.builder()
                .fullName(request.getFullName())
                .email(request.getEmail())
                .customFields(request.getCustomFields() != null ? request.getCustomFields() : new HashMap<>())
                .dzo(currentUser.getDzo())
                .build();

        employee = employeeRepository.save(employee);
        return toDto(employee);
    }

    @Transactional
    public EmployeeDto update(Long id, UpdateEmployeeRequest request) {
        // Валидация ФИО
        fullNameValidator.validate(request.getFullName());
        // Валидация customFields
        customFieldsValidator.validate(request.getCustomFields());

        Employee employee = employeeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with id: " + id));

        User currentUser = authService.getCurrentUserEntity();

        if (!Objects.equals(employee.getFullName(), request.getFullName())) {
            saveHistory(employee, currentUser, "fullName", employee.getFullName(), request.getFullName());
            employee.setFullName(request.getFullName());
        }

        if (!Objects.equals(employee.getEmail(), request.getEmail())) {
            saveHistory(employee, currentUser, "email", employee.getEmail(), request.getEmail());
            employee.setEmail(request.getEmail());
        }

        if (request.getCustomFields() != null) {
            Map<String, Object> oldFields = employee.getCustomFields() != null ? employee.getCustomFields() : new HashMap<>();
            Map<String, Object> newFields = request.getCustomFields();

            for (Map.Entry<String, Object> entry : newFields.entrySet()) {
                String fieldName = entry.getKey();
                Object newValue = entry.getValue();
                Object oldValue = oldFields.get(fieldName);

                if (!Objects.equals(oldValue, newValue)) {
                    saveHistory(employee, currentUser, fieldName,
                            oldValue != null ? oldValue.toString() : null,
                            newValue != null ? newValue.toString() : null);
                }
            }

            employee.setCustomFields(newFields);
        }

        employee = employeeRepository.save(employee);
        return toDto(employee);
    }

    @Transactional
    public void delete(Long id) {
        if (!employeeRepository.existsById(id)) {
            throw new ResourceNotFoundException("Employee not found with id: " + id);
        }
        employeeRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public List<EmployeeHistoryDto> getHistory(Long employeeId) {
        if (!employeeRepository.existsById(employeeId)) {
            throw new ResourceNotFoundException("Employee not found with id: " + employeeId);
        }

        return historyRepository.findByEmployeeIdOrderByChangedAtDesc(employeeId)
                .stream()
                .map(this::toHistoryDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<EmployeeHistoryDto> getRecentHistory(int limit) {
        return historyRepository.findAllByOrderByChangedAtDesc(
                org.springframework.data.domain.PageRequest.of(0, limit))
                .stream()
                .map(this::toHistoryDto)
                .toList();
    }

    private EmployeeHistoryDto toHistoryDto(EmployeeHistory h) {
        return EmployeeHistoryDto.builder()
                .id(h.getId())
                .employeeId(h.getEmployee().getId())
                .employeeFullName(h.getEmployee().getFullName())
                .changedBy(h.getChangedBy().getUsername())
                .changedAt(h.getChangedAt())
                .fieldName(h.getFieldName())
                .oldValue(h.getOldValue())
                .newValue(h.getNewValue())
                .build();
    }

    private void saveHistory(Employee employee, User changedBy, String fieldName, String oldValue, String newValue) {
        EmployeeHistory history = EmployeeHistory.builder()
                .employee(employee)
                .changedBy(changedBy)
                .fieldName(fieldName)
                .oldValue(oldValue)
                .newValue(newValue)
                .build();
        historyRepository.save(history);
    }

    private EmployeeDto toDto(Employee employee) {
        return EmployeeDto.builder()
                .id(employee.getId())
                .fullName(employee.getFullName())
                .email(employee.getEmail())
                .customFields(employee.getCustomFields())
                .createdAt(employee.getCreatedAt())
                .updatedAt(employee.getUpdatedAt())
                .build();
    }
}
