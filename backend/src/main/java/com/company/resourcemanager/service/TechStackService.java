package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.techstack.*;
import com.company.resourcemanager.entity.*;
import com.company.resourcemanager.exception.BusinessException;
import com.company.resourcemanager.exception.ResourceNotFoundException;
import com.company.resourcemanager.repository.TechDirectionRepository;
import com.company.resourcemanager.repository.TechStackRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class TechStackService {

    private final TechDirectionRepository directionRepository;
    private final TechStackRepository stackRepository;
    private final CurrentUserService currentUserService;

    // === DIRECTIONS ===

    @Transactional(readOnly = true)
    public List<TechDirectionDto> getAllDirections(boolean includeStacks) {
        List<TechDirection> directions = directionRepository.findByIsActiveTrueOrderBySortOrderAsc();
        return directions.stream()
            .map(d -> toDirectionDto(d, includeStacks))
            .collect(Collectors.toList());
    }

    // === STACKS READ ===

    @Transactional(readOnly = true)
    public List<TechStackDto> getSelectableStacks() {
        return stackRepository.findByStatusAndIsActiveTrueOrderByDirectionSortOrderAscSortOrderAsc(TechStackStatus.ACTIVE)
            .stream().map(this::toStackDto).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<TechStackDto> getStacksByDirection(Long directionId) {
        return stackRepository.findByDirectionIdAndIsActiveTrueOrderBySortOrderAsc(directionId)
            .stream().map(this::toStackDto).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public TechStackDto getStackById(Long id) {
        TechStack stack = stackRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Stack not found"));
        return toStackDto(stack);
    }

    @Transactional(readOnly = true)
    public List<TechStackDto> search(String q) {
        return stackRepository.search(q).stream().map(this::toStackDto).collect(Collectors.toList());
    }

    // === ADMIN CRUD ===

    public TechStackDto createStack(CreateTechStackRequest request) {
        checkAdmin();

        TechDirection direction = directionRepository.findById(request.getDirectionId())
            .orElseThrow(() -> new ResourceNotFoundException("Direction not found"));

        if (stackRepository.existsByDirectionIdAndCode(direction.getId(), request.getCode().toUpperCase())) {
            throw new BusinessException("Stack with this code already exists");
        }

        TechStack stack = TechStack.builder()
            .direction(direction)
            .code(request.getCode().toUpperCase())
            .name(request.getName())
            .description(request.getDescription())
            .technologies(request.getTechnologies())
            .sortOrder(request.getSortOrder() != null ? request.getSortOrder() : 0)
            .status(TechStackStatus.ACTIVE)
            .createdBy(currentUserService.getCurrentUser())
            .approvedBy(currentUserService.getCurrentUser())
            .approvedAt(LocalDateTime.now())
            .build();

        return toStackDto(stackRepository.save(stack));
    }

    // === WORKFLOW ===

    public TechStackDto proposeStack(ProposeStackRequest request) {
        TechDirection direction = directionRepository.findById(request.getDirectionId())
            .orElseThrow(() -> new ResourceNotFoundException("Direction not found"));

        String tempCode = "PROP_" + System.currentTimeMillis();

        TechStack stack = TechStack.builder()
            .direction(direction)
            .code(tempCode)
            .name(request.getName())
            .description(request.getJustification())
            .technologies(request.getTechnologies())
            .status(TechStackStatus.PROPOSED)
            .createdBy(currentUserService.getCurrentUser())
            .build();

        return toStackDto(stackRepository.save(stack));
    }

    @Transactional(readOnly = true)
    public List<TechStackDto> getPendingStacks() {
        return stackRepository.findByStatusOrderByCreatedAtDesc(TechStackStatus.PROPOSED)
            .stream().map(this::toStackDto).collect(Collectors.toList());
    }

    public TechStackDto approveStack(Long id, String code) {
        checkAdmin();

        TechStack stack = stackRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Stack not found"));

        if (stack.getStatus() != TechStackStatus.PROPOSED) {
            throw new BusinessException("Only proposed stacks can be approved");
        }

        String finalCode = (code != null && !code.isBlank()) ? code.toUpperCase() : generateCode(stack.getName());

        if (stackRepository.existsByDirectionIdAndCode(stack.getDirection().getId(), finalCode)) {
            throw new BusinessException("Stack with code " + finalCode + " already exists");
        }

        stack.setCode(finalCode);
        stack.setStatus(TechStackStatus.ACTIVE);
        stack.setApprovedBy(currentUserService.getCurrentUser());
        stack.setApprovedAt(LocalDateTime.now());

        return toStackDto(stackRepository.save(stack));
    }

    public TechStackDto rejectStack(Long id, RejectStackRequest request) {
        checkAdmin();

        TechStack stack = stackRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Stack not found"));

        if (stack.getStatus() != TechStackStatus.PROPOSED) {
            throw new BusinessException("Only proposed stacks can be rejected");
        }

        stack.setStatus(TechStackStatus.REJECTED);
        stack.setRejectionReason(request.getReason());
        stack.setIsActive(false);

        return toStackDto(stackRepository.save(stack));
    }

    public TechStackDto deprecateStack(Long id) {
        checkAdmin();

        TechStack stack = stackRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Stack not found"));

        stack.setStatus(TechStackStatus.DEPRECATED);
        return toStackDto(stackRepository.save(stack));
    }

    // === HELPERS ===

    private void checkAdmin() {
        User user = currentUserService.getCurrentUser();
        if (!user.hasRole(Role.SYSTEM_ADMIN) && !user.hasRole(Role.DZO_ADMIN)) {
            throw new AccessDeniedException("Admin access required");
        }
    }

    private String generateCode(String name) {
        return name.toUpperCase().replaceAll("[^A-Z0-9]", "_").replaceAll("_+", "_");
    }

    private TechDirectionDto toDirectionDto(TechDirection d, boolean includeStacks) {
        TechDirectionDto.TechDirectionDtoBuilder builder = TechDirectionDto.builder()
            .id(d.getId())
            .code(d.getCode())
            .name(d.getName())
            .description(d.getDescription())
            .icon(d.getIcon())
            .color(d.getColor())
            .sortOrder(d.getSortOrder());

        if (includeStacks) {
            List<TechStack> stacks = stackRepository.findByDirectionIdAndIsActiveTrueOrderBySortOrderAsc(d.getId());
            builder.stacks(stacks.stream()
                .filter(s -> s.getStatus() == TechStackStatus.ACTIVE)
                .map(this::toStackDto)
                .collect(Collectors.toList()));
        }
        return builder.build();
    }

    private TechStackDto toStackDto(TechStack s) {
        return TechStackDto.builder()
            .id(s.getId())
            .directionId(s.getDirection().getId())
            .directionCode(s.getDirection().getCode())
            .directionName(s.getDirection().getName())
            .code(s.getCode())
            .name(s.getName())
            .description(s.getDescription())
            .technologies(s.getTechnologies())
            .status(s.getStatus().name())
            .statusDisplayName(s.getStatus().getDisplayName())
            .sortOrder(s.getSortOrder())
            .createdById(s.getCreatedBy() != null ? s.getCreatedBy().getId() : null)
            .createdByName(s.getCreatedBy() != null ? s.getCreatedBy().getUsername() : null)
            .createdAt(s.getCreatedAt())
            .build();
    }
}
