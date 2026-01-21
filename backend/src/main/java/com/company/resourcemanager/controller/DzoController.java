package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.CreateDzoRequest;
import com.company.resourcemanager.dto.DzoDto;
import com.company.resourcemanager.dto.UpdateDzoRequest;
import com.company.resourcemanager.entity.Dzo;
import com.company.resourcemanager.service.DzoService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/dzos")
@RequiredArgsConstructor
public class DzoController {
    private final DzoService dzoService;

    @GetMapping
    public ResponseEntity<List<DzoDto>> getAll() {
        return ResponseEntity.ok(
            dzoService.getAllActive().stream()
                .map(this::toDto)
                .toList()
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<DzoDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok(toDto(dzoService.getById(id)));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('SYSTEM_ADMIN')")
    public ResponseEntity<DzoDto> create(@Valid @RequestBody CreateDzoRequest request) {
        return ResponseEntity.ok(toDto(dzoService.create(request)));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('SYSTEM_ADMIN')")
    public ResponseEntity<DzoDto> update(@PathVariable Long id, @Valid @RequestBody UpdateDzoRequest request) {
        return ResponseEntity.ok(toDto(dzoService.update(id, request)));
    }

    private DzoDto toDto(Dzo dzo) {
        return DzoDto.builder()
            .id(dzo.getId())
            .code(dzo.getCode())
            .name(dzo.getName())
            .emailDomain(dzo.getEmailDomain())
            .isActive(dzo.getIsActive())
            .build();
    }
}
