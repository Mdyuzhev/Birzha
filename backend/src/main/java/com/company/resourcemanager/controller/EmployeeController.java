package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.*;
import com.company.resourcemanager.service.EmployeeService;
import com.company.resourcemanager.service.ExcelExportService;
import com.company.resourcemanager.entity.Employee;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/employees")
@RequiredArgsConstructor
public class EmployeeController {

    private final EmployeeService employeeService;
    private final ExcelExportService excelExportService;

    @GetMapping
    public ResponseEntity<Page<EmployeeDto>> getAll(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String fullName,
            @RequestParam(required = false) String email,
            @RequestParam Map<String, String> allParams,
            @PageableDefault(size = 20) Pageable pageable) {

        Map<String, String> filters = new HashMap<>();
        if (search != null) filters.put("search", search);
        if (fullName != null) filters.put("fullName", fullName);
        if (email != null) filters.put("email", email);

        // Extract customFields[key] and dateFilters[key] from all params
        Map<String, String> customFields = new HashMap<>();
        Map<String, String> dateFilters = new HashMap<>();

        for (Map.Entry<String, String> entry : allParams.entrySet()) {
            String key = entry.getKey();
            if (key.startsWith("customFields[") && key.endsWith("]")) {
                String fieldName = key.substring(13, key.length() - 1);
                customFields.put(fieldName, entry.getValue());
            } else if (key.startsWith("dateFilters[") && key.endsWith("]")) {
                String fieldName = key.substring(12, key.length() - 1);
                dateFilters.put(fieldName, entry.getValue());
            }
        }

        return ResponseEntity.ok(employeeService.findAll(filters,
                customFields.isEmpty() ? null : customFields,
                dateFilters.isEmpty() ? null : dateFilters,
                pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<EmployeeDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok(employeeService.findById(id));
    }

    @PostMapping
    public ResponseEntity<EmployeeDto> create(@Valid @RequestBody CreateEmployeeRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(employeeService.create(request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<EmployeeDto> update(
            @PathVariable Long id,
            @Valid @RequestBody UpdateEmployeeRequest request) {
        return ResponseEntity.ok(employeeService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        employeeService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/history")
    public ResponseEntity<List<EmployeeHistoryDto>> getHistory(@PathVariable Long id) {
        return ResponseEntity.ok(employeeService.getHistory(id));
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> exportToExcel(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String fullName,
            @RequestParam(required = false) String email,
            @RequestParam(defaultValue = "false") boolean all,
            @RequestParam Map<String, String> allParams) throws IOException {

        Specification<Employee> spec = null;

        if (!all) {
            spec = Specification.where(null);

            if (search != null && !search.isEmpty()) {
                String searchLower = search.toLowerCase();
                spec = spec.and((root, query, cb) ->
                        cb.or(
                                cb.like(cb.lower(root.get("fullName")), "%" + searchLower + "%"),
                                cb.like(cb.lower(root.get("email")), "%" + searchLower + "%")
                        ));
            }
            if (fullName != null && !fullName.isEmpty()) {
                spec = spec.and((root, query, cb) ->
                        cb.like(cb.lower(root.get("fullName")), "%" + fullName.toLowerCase() + "%"));
            }
            if (email != null && !email.isEmpty()) {
                spec = spec.and((root, query, cb) ->
                        cb.like(cb.lower(root.get("email")), "%" + email.toLowerCase() + "%"));
            }

            // Extract customFields and dateFilters
            for (Map.Entry<String, String> entry : allParams.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();
                if (value == null || value.isEmpty()) continue;

                if (key.startsWith("customFields[") && key.endsWith("]")) {
                    String fieldName = key.substring(13, key.length() - 1);
                    String[] values = value.split(",");
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
                } else if (key.startsWith("dateFilters[") && key.endsWith("]")) {
                    String fieldName = key.substring(12, key.length() - 1);
                    String[] parts = value.split(":", 2);
                    if (parts.length == 2) {
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
            }
        }

        byte[] excelBytes = excelExportService.exportEmployees(spec);

        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm"));
        String filename = "employees_" + timestamp + ".xlsx";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
        headers.setContentDispositionFormData("attachment", filename);
        headers.setContentLength(excelBytes.length);

        return new ResponseEntity<>(excelBytes, headers, HttpStatus.OK);
    }
}
