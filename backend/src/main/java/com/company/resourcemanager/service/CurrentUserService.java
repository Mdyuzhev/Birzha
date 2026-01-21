package com.company.resourcemanager.service;

import com.company.resourcemanager.entity.Dzo;
import com.company.resourcemanager.entity.Role;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.exception.ResourceNotFoundException;
import com.company.resourcemanager.repository.HrBpAssignmentRepository;
import com.company.resourcemanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class CurrentUserService {
    private final UserRepository userRepository;
    private final HrBpAssignmentRepository hrBpAssignmentRepository;

    public User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        return userRepository.findByUsername(username)
            .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }

    public Long getCurrentDzoId() {
        User user = getCurrentUser();
        return user.getDzo() != null ? user.getDzo().getId() : null;
    }

    public Set<Role> getCurrentUserRoles() {
        return getCurrentUser().getRoles();
    }

    public boolean hasRole(Role role) {
        return getCurrentUser().hasRole(role);
    }

    public boolean hasAnyRole(Role... roles) {
        Set<Role> userRoles = getCurrentUserRoles();
        for (Role role : roles) {
            if (userRoles.contains(role)) {
                return true;
            }
        }
        return false;
    }

    public boolean isSystemAdmin() {
        return hasRole(Role.SYSTEM_ADMIN);
    }

    public boolean isDzoAdmin() {
        return hasRole(Role.DZO_ADMIN);
    }

    public boolean isRecruiter() {
        return hasRole(Role.RECRUITER);
    }

    public boolean isHrBp() {
        return hasRole(Role.HR_BP);
    }

    public boolean isBorup() {
        return hasRole(Role.BORUP);
    }

    public boolean isManager() {
        return hasRole(Role.MANAGER);
    }

    public List<Dzo> getAssignedDzos() {
        if (!isHrBp()) {
            return List.of();
        }
        return hrBpAssignmentRepository.findDzosByUserId(getCurrentUser().getId());
    }

    public boolean hasAccessToDzo(Long dzoId) {
        if (isSystemAdmin()) {
            return true;
        }
        if (isDzoAdmin() && getCurrentDzoId() != null && getCurrentDzoId().equals(dzoId)) {
            return true;
        }
        if (isHrBp()) {
            return getAssignedDzos().stream()
                    .anyMatch(dzo -> dzo.getId().equals(dzoId));
        }
        return false;
    }
}
