package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.CreateDictionaryRequest;
import com.company.resourcemanager.dto.DictionaryDto;
import com.company.resourcemanager.entity.Dictionary;
import com.company.resourcemanager.repository.DictionaryRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/dictionaries")
@RequiredArgsConstructor
public class DictionaryController {

    private final DictionaryRepository dictionaryRepository;

    @GetMapping
    public ResponseEntity<List<DictionaryDto>> getAllDictionaries() {
        List<DictionaryDto> dictionaries = dictionaryRepository.findAll()
                .stream()
                .map(DictionaryDto::fromEntity)
                .collect(Collectors.toList());
        return ResponseEntity.ok(dictionaries);
    }

    @GetMapping("/{id}")
    public ResponseEntity<DictionaryDto> getDictionary(@PathVariable Long id) {
        return dictionaryRepository.findById(id)
                .map(DictionaryDto::fromEntity)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @PreAuthorize("hasAuthority('SYSTEM_ADMIN')")
    public ResponseEntity<DictionaryDto> createDictionary(@Valid @RequestBody CreateDictionaryRequest request) {
        Dictionary dictionary = Dictionary.builder()
                .name(request.getName())
                .displayName(request.getDisplayName())
                .values(request.getValues() != null ? request.getValues() : new ArrayList<>())
                .build();

        Dictionary saved = dictionaryRepository.save(dictionary);
        return ResponseEntity.ok(DictionaryDto.fromEntity(saved));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('SYSTEM_ADMIN')")
    public ResponseEntity<DictionaryDto> updateDictionary(@PathVariable Long id, @Valid @RequestBody CreateDictionaryRequest request) {
        return dictionaryRepository.findById(id)
                .map(dictionary -> {
                    dictionary.setName(request.getName());
                    dictionary.setDisplayName(request.getDisplayName());
                    dictionary.setValues(request.getValues() != null ? request.getValues() : new ArrayList<>());
                    Dictionary saved = dictionaryRepository.save(dictionary);
                    return ResponseEntity.ok(DictionaryDto.fromEntity(saved));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('SYSTEM_ADMIN')")
    public ResponseEntity<Void> deleteDictionary(@PathVariable Long id) {
        if (!dictionaryRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        dictionaryRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
