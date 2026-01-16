package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.ColumnPresetDto;
import com.company.resourcemanager.dto.CreateColumnPresetRequest;
import com.company.resourcemanager.entity.ColumnPreset;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.repository.ColumnPresetRepository;
import com.company.resourcemanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ColumnPresetService {

    private final ColumnPresetRepository presetRepository;
    private final UserRepository userRepository;

    public List<ColumnPresetDto> getUserPresets(Long userId) {
        return presetRepository.findByUserIdOrderByNameAsc(userId)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    public ColumnPresetDto getPresetById(Long id, Long userId) {
        return presetRepository.findByIdAndUserId(id, userId)
                .map(this::toDto)
                .orElse(null);
    }

    public ColumnPresetDto getDefaultPreset(Long userId) {
        return presetRepository.findByUserIdAndIsDefaultTrue(userId)
                .map(this::toDto)
                .orElse(null);
    }

    @Transactional
    public ColumnPresetDto createPreset(CreateColumnPresetRequest request, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (presetRepository.existsByUserIdAndName(userId, request.getName())) {
            throw new IllegalArgumentException("Борд с таким названием уже существует");
        }

        // Если это default, сбросить предыдущий default
        if (Boolean.TRUE.equals(request.getIsDefault())) {
            presetRepository.clearDefaultForUser(userId);
        }

        ColumnPreset preset = ColumnPreset.builder()
                .user(user)
                .name(request.getName())
                .columnConfig(request.getColumnConfig())
                .isDefault(request.getIsDefault())
                .build();

        ColumnPreset saved = presetRepository.save(preset);
        return toDto(saved);
    }

    @Transactional
    public ColumnPresetDto updatePreset(Long id, CreateColumnPresetRequest request, Long userId) {
        ColumnPreset preset = presetRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new IllegalArgumentException("Борд не найден"));

        // Проверить уникальность имени, если оно меняется
        if (!preset.getName().equals(request.getName()) &&
            presetRepository.existsByUserIdAndName(userId, request.getName())) {
            throw new IllegalArgumentException("Борд с таким названием уже существует");
        }

        // Если это default, сбросить предыдущий default
        if (Boolean.TRUE.equals(request.getIsDefault())) {
            presetRepository.clearDefaultForUser(userId);
        }

        preset.setName(request.getName());
        preset.setColumnConfig(request.getColumnConfig());
        preset.setIsDefault(request.getIsDefault());

        ColumnPreset saved = presetRepository.save(preset);
        return toDto(saved);
    }

    @Transactional
    public void deletePreset(Long id, Long userId) {
        ColumnPreset preset = presetRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new IllegalArgumentException("Борд не найден"));
        presetRepository.delete(preset);
    }

    @Transactional
    public ColumnPresetDto setAsDefault(Long id, Long userId) {
        ColumnPreset preset = presetRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new IllegalArgumentException("Борд не найден"));

        presetRepository.clearDefaultForUser(userId);
        preset.setIsDefault(true);

        ColumnPreset saved = presetRepository.save(preset);
        return toDto(saved);
    }

    private ColumnPresetDto toDto(ColumnPreset preset) {
        return ColumnPresetDto.builder()
                .id(preset.getId())
                .name(preset.getName())
                .columnConfig(preset.getColumnConfig())
                .isDefault(preset.getIsDefault())
                .createdAt(preset.getCreatedAt())
                .updatedAt(preset.getUpdatedAt())
                .build();
    }
}
