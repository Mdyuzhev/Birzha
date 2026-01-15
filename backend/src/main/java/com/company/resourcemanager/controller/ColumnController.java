package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.ColumnDefinitionDto;
import com.company.resourcemanager.dto.CreateColumnRequest;
import com.company.resourcemanager.entity.ColumnDefinition;
import com.company.resourcemanager.repository.ColumnDefinitionRepository;
import com.company.resourcemanager.repository.DictionaryRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/columns")
@RequiredArgsConstructor
public class ColumnController {

    private final ColumnDefinitionRepository columnRepository;
    private final DictionaryRepository dictionaryRepository;

    @GetMapping
    public ResponseEntity<List<ColumnDefinitionDto>> getAllColumns() {
        List<ColumnDefinitionDto> columns = columnRepository.findAllByOrderBySortOrderAsc()
                .stream()
                .map(ColumnDefinitionDto::fromEntity)
                .collect(Collectors.toList());
        return ResponseEntity.ok(columns);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ColumnDefinitionDto> getColumn(@PathVariable Long id) {
        return columnRepository.findById(id)
                .map(ColumnDefinitionDto::fromEntity)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ColumnDefinitionDto> createColumn(@Valid @RequestBody CreateColumnRequest request) {
        ColumnDefinition column = ColumnDefinition.builder()
                .name(request.getName())
                .displayName(request.getDisplayName())
                .fieldType(ColumnDefinition.FieldType.valueOf(request.getFieldType()))
                .sortOrder(request.getSortOrder() != null ? request.getSortOrder() : 0)
                .isRequired(request.getIsRequired() != null ? request.getIsRequired() : false)
                .build();

        if (request.getDictionaryId() != null) {
            dictionaryRepository.findById(request.getDictionaryId())
                    .ifPresent(column::setDictionary);
        }

        ColumnDefinition saved = columnRepository.save(column);
        return ResponseEntity.ok(ColumnDefinitionDto.fromEntity(saved));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ColumnDefinitionDto> updateColumn(@PathVariable Long id, @Valid @RequestBody CreateColumnRequest request) {
        return columnRepository.findById(id)
                .map(column -> {
                    column.setDisplayName(request.getDisplayName());
                    column.setFieldType(ColumnDefinition.FieldType.valueOf(request.getFieldType()));
                    column.setSortOrder(request.getSortOrder() != null ? request.getSortOrder() : 0);
                    column.setIsRequired(request.getIsRequired() != null ? request.getIsRequired() : false);

                    if (request.getDictionaryId() != null) {
                        dictionaryRepository.findById(request.getDictionaryId())
                                .ifPresent(column::setDictionary);
                    } else {
                        column.setDictionary(null);
                    }

                    ColumnDefinition saved = columnRepository.save(column);
                    return ResponseEntity.ok(ColumnDefinitionDto.fromEntity(saved));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteColumn(@PathVariable Long id) {
        if (!columnRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        columnRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/reorder")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<ColumnDefinitionDto>> reorderColumns(@RequestBody List<Long> ids) {
        for (int i = 0; i < ids.size(); i++) {
            final int order = i;
            columnRepository.findById(ids.get(i))
                    .ifPresent(column -> {
                        column.setSortOrder(order);
                        columnRepository.save(column);
                    });
        }
        return getAllColumns();
    }
}
