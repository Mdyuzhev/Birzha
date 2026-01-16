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
        return presetRepository.findByUserIdOrGlobalOrderByNameAsc(userId)
                .stream()
                .map(preset -> toDto(preset, userId))
                .collect(Collectors.toList());
    }

    public ColumnPresetDto getPresetById(Long id, Long userId) {
        return presetRepository.findById(id)
                .filter(preset -> preset.getUser().getId().equals(userId) || Boolean.TRUE.equals(preset.getIsGlobal()))
                .map(preset -> toDto(preset, userId))
                .orElse(null);
    }

    public ColumnPresetDto getDefaultPreset(Long userId) {
        return presetRepository.findByUserIdAndIsDefaultTrue(userId)
                .map(preset -> toDto(preset, userId))
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
                .isGlobal(request.getIsGlobal())
                .build();

        ColumnPreset saved = presetRepository.save(preset);
        return toDto(saved, userId);
    }

    @Transactional
    public ColumnPresetDto updatePreset(Long id, CreateColumnPresetRequest request, Long userId) {
        ColumnPreset preset = presetRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new IllegalArgumentException("Борд не найден или недоступен для редактирования"));

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
        preset.setIsGlobal(request.getIsGlobal());

        ColumnPreset saved = presetRepository.save(preset);
        return toDto(saved, userId);
    }

    @Transactional
    public void deletePreset(Long id, Long userId) {
        ColumnPreset preset = presetRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new IllegalArgumentException("Борд не найден или недоступен для удаления"));
        presetRepository.delete(preset);
    }

    @Transactional
    public ColumnPresetDto setAsDefault(Long id, Long userId) {
        ColumnPreset preset = presetRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new IllegalArgumentException("Борд не найден"));

        presetRepository.clearDefaultForUser(userId);
        preset.setIsDefault(true);

        ColumnPreset saved = presetRepository.save(preset);
        return toDto(saved, userId);
    }

    @Transactional
    public ColumnPresetDto toggleGlobal(Long id, Long userId) {
        ColumnPreset preset = presetRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new IllegalArgumentException("Борд не найден или недоступен"));

        preset.setIsGlobal(!Boolean.TRUE.equals(preset.getIsGlobal()));
        ColumnPreset saved = presetRepository.save(preset);
        return toDto(saved, userId);
    }

    private ColumnPresetDto toDto(ColumnPreset preset, Long currentUserId) {
        Long ownerId = preset.getUser().getId();
        return ColumnPresetDto.builder()
                .id(preset.getId())
                .name(preset.getName())
                .columnConfig(preset.getColumnConfig())
                .isDefault(preset.getIsDefault())
                .isGlobal(preset.getIsGlobal())
                .ownerId(ownerId)
                .ownerName(preset.getUser().getUsername())
                .isOwner(ownerId.equals(currentUserId))
                .createdAt(preset.getCreatedAt())
                .updatedAt(preset.getUpdatedAt())
                .build();
    }
}
