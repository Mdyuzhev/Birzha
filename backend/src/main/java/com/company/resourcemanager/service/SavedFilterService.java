package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.CreateSavedFilterRequest;
import com.company.resourcemanager.dto.SavedFilterDto;
import com.company.resourcemanager.entity.SavedFilter;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.repository.SavedFilterRepository;
import com.company.resourcemanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SavedFilterService {

    private final SavedFilterRepository filterRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<SavedFilterDto> getUserFilters(Long userId) {
        return filterRepository.findByUserIdOrGlobalOrderByNameAsc(userId)
                .stream()
                .map(filter -> toDto(filter, userId))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public SavedFilterDto getFilterById(Long id, Long userId) {
        return filterRepository.findById(id)
                .filter(filter -> filter.getUser().getId().equals(userId) || Boolean.TRUE.equals(filter.getIsGlobal()))
                .map(filter -> toDto(filter, userId))
                .orElse(null);
    }

    @Transactional(readOnly = true)
    public SavedFilterDto getDefaultFilter(Long userId) {
        return filterRepository.findByUserIdAndIsDefaultTrue(userId)
                .map(filter -> toDto(filter, userId))
                .orElse(null);
    }

    @Transactional
    public SavedFilterDto createFilter(CreateSavedFilterRequest request, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (filterRepository.existsByUserIdAndName(userId, request.getName())) {
            throw new IllegalArgumentException("Фильтр с таким названием уже существует");
        }

        if (Boolean.TRUE.equals(request.getIsDefault())) {
            filterRepository.clearDefaultForUser(userId);
        }

        SavedFilter filter = SavedFilter.builder()
                .user(user)
                .name(request.getName())
                .filterConfig(request.getFilterConfig())
                .isDefault(request.getIsDefault())
                .isGlobal(request.getIsGlobal())
                .build();

        SavedFilter saved = filterRepository.save(filter);
        return toDto(saved, userId);
    }

    @Transactional
    public SavedFilterDto updateFilter(Long id, CreateSavedFilterRequest request, Long userId) {
        SavedFilter filter = filterRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new IllegalArgumentException("Фильтр не найден или недоступен для редактирования"));

        if (!filter.getName().equals(request.getName()) &&
            filterRepository.existsByUserIdAndName(userId, request.getName())) {
            throw new IllegalArgumentException("Фильтр с таким названием уже существует");
        }

        if (Boolean.TRUE.equals(request.getIsDefault())) {
            filterRepository.clearDefaultForUser(userId);
        }

        filter.setName(request.getName());
        filter.setFilterConfig(request.getFilterConfig());
        filter.setIsDefault(request.getIsDefault());
        filter.setIsGlobal(request.getIsGlobal());

        SavedFilter saved = filterRepository.save(filter);
        return toDto(saved, userId);
    }

    @Transactional
    public void deleteFilter(Long id, Long userId) {
        SavedFilter filter = filterRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new IllegalArgumentException("Фильтр не найден или недоступен для удаления"));
        filterRepository.delete(filter);
    }

    @Transactional
    public SavedFilterDto setAsDefault(Long id, Long userId) {
        SavedFilter filter = filterRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new IllegalArgumentException("Фильтр не найден"));

        filterRepository.clearDefaultForUser(userId);
        filter.setIsDefault(true);

        SavedFilter saved = filterRepository.save(filter);
        return toDto(saved, userId);
    }

    @Transactional
    public SavedFilterDto toggleGlobal(Long id, Long userId) {
        SavedFilter filter = filterRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new IllegalArgumentException("Фильтр не найден или недоступен"));

        filter.setIsGlobal(!Boolean.TRUE.equals(filter.getIsGlobal()));
        SavedFilter saved = filterRepository.save(filter);
        return toDto(saved, userId);
    }

    private SavedFilterDto toDto(SavedFilter filter, Long currentUserId) {
        Long ownerId = filter.getUser().getId();
        return SavedFilterDto.builder()
                .id(filter.getId())
                .name(filter.getName())
                .filterConfig(filter.getFilterConfig())
                .isDefault(filter.getIsDefault())
                .isGlobal(filter.getIsGlobal())
                .ownerId(ownerId)
                .ownerName(filter.getUser().getUsername())
                .isOwner(ownerId.equals(currentUserId))
                .createdAt(filter.getCreatedAt())
                .updatedAt(filter.getUpdatedAt())
                .build();
    }
}
