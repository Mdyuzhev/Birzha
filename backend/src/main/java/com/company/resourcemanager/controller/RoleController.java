package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.AssignHrBpRequest;
import com.company.resourcemanager.dto.AssignRoleRequest;
import com.company.resourcemanager.dto.DzoDto;
import com.company.resourcemanager.dto.RoleDto;
import com.company.resourcemanager.dto.UserDto;
import com.company.resourcemanager.entity.Dzo;
import com.company.resourcemanager.entity.Role;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.service.CurrentUserService;
import com.company.resourcemanager.service.RoleService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/roles")
@RequiredArgsConstructor
public class RoleController {

    private final RoleService roleService;
    private final CurrentUserService currentUserService;

    @GetMapping
    public ResponseEntity<List<RoleDto>> getAllRoles() {
        List<RoleDto> roles = Arrays.stream(Role.values())
                .map(RoleDto::from)
                .collect(Collectors.toList());
        return ResponseEntity.ok(roles);
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<Set<String>> getUserRoles(@PathVariable Long userId) {
        if (!currentUserService.isSystemAdmin()) {
            return ResponseEntity.status(403).build();
        }

        Set<Role> roles = roleService.getUserRoles(userId);
        Set<String> roleNames = roles.stream()
                .map(Enum::name)
                .collect(Collectors.toSet());
        return ResponseEntity.ok(roleNames);
    }

    @PostMapping("/assign")
    public ResponseEntity<Void> assignRole(@RequestBody AssignRoleRequest request) {
        if (!currentUserService.isSystemAdmin()) {
            return ResponseEntity.status(403).build();
        }

        roleService.assignRole(request.getUserId(), request.getRole());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/remove")
    public ResponseEntity<Void> removeRole(@RequestBody AssignRoleRequest request) {
        if (!currentUserService.isSystemAdmin()) {
            return ResponseEntity.status(403).build();
        }

        roleService.removeRole(request.getUserId(), request.getRole());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/role/{role}/users")
    public ResponseEntity<List<UserDto>> getUsersByRole(@PathVariable String role) {
        if (!currentUserService.isSystemAdmin()) {
            return ResponseEntity.status(403).build();
        }

        Role roleEnum = Role.valueOf(role);
        List<User> users = roleService.getUsersByRole(roleEnum);
        List<UserDto> userDtos = users.stream()
                .map(UserDto::fromEntity)
                .collect(Collectors.toList());
        return ResponseEntity.ok(userDtos);
    }

    @PostMapping("/hr-bp/assign")
    public ResponseEntity<Void> assignHrBpToDzo(@RequestBody AssignHrBpRequest request) {
        if (!currentUserService.isSystemAdmin()) {
            return ResponseEntity.status(403).build();
        }

        Long currentUserId = currentUserService.getCurrentUser().getId();
        roleService.assignHrBpToDzo(request.getUserId(), request.getDzoId(), currentUserId);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/hr-bp/remove")
    public ResponseEntity<Void> removeHrBpFromDzo(@RequestBody AssignHrBpRequest request) {
        if (!currentUserService.isSystemAdmin()) {
            return ResponseEntity.status(403).build();
        }

        roleService.removeHrBpFromDzo(request.getUserId(), request.getDzoId());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/hr-bp/{userId}/dzos")
    public ResponseEntity<List<DzoDto>> getDzosForHrBp(@PathVariable Long userId) {
        if (!currentUserService.isSystemAdmin() && !currentUserService.getCurrentUser().getId().equals(userId)) {
            return ResponseEntity.status(403).build();
        }

        List<Dzo> dzos = roleService.getDzosForHrBp(userId);
        List<DzoDto> dzoDtos = dzos.stream()
                .map(dzo -> DzoDto.builder()
                        .id(dzo.getId())
                        .code(dzo.getCode())
                        .name(dzo.getName())
                        .emailDomain(dzo.getEmailDomain())
                        .isActive(dzo.getIsActive())
                        .build())
                .collect(Collectors.toList());
        return ResponseEntity.ok(dzoDtos);
    }

    @GetMapping("/dzo/{dzoId}/hr-bps")
    public ResponseEntity<List<UserDto>> getHrBpsForDzo(@PathVariable Long dzoId) {
        if (!currentUserService.hasAccessToDzo(dzoId)) {
            return ResponseEntity.status(403).build();
        }

        List<User> users = roleService.getHrBpsForDzo(dzoId);
        List<UserDto> userDtos = users.stream()
                .map(UserDto::fromEntity)
                .collect(Collectors.toList());
        return ResponseEntity.ok(userDtos);
    }
}
