package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.*;
import com.company.resourcemanager.service.NineBoxService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/nine-box")
@RequiredArgsConstructor
public class NineBoxController {

    private final NineBoxService service;

    @GetMapping
    public ResponseEntity<List<NineBoxAssessmentDTO>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }

    @GetMapping("/employee/{employeeId}")
    public ResponseEntity<NineBoxAssessmentDTO> getByEmployeeId(@PathVariable Long employeeId) {
        return service.getByEmployeeId(employeeId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/box/{boxPosition}")
    public ResponseEntity<List<NineBoxAssessmentDTO>> getByBoxPosition(@PathVariable Integer boxPosition) {
        return ResponseEntity.ok(service.getByBoxPosition(boxPosition));
    }

    @GetMapping("/statistics")
    public ResponseEntity<Map<String, Object>> getStatistics() {
        return ResponseEntity.ok(service.getStatistics());
    }

    @PostMapping
    public ResponseEntity<NineBoxAssessmentDTO> createOrUpdate(
            @Valid @RequestBody NineBoxCreateDTO dto) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(service.createOrUpdate(dto, username));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
