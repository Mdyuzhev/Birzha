package com.company.resourcemanager.service;

import com.company.resourcemanager.entity.Dzo;
import com.company.resourcemanager.entity.HrBpAssignment;
import com.company.resourcemanager.entity.Role;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.entity.UserRole;
import com.company.resourcemanager.repository.DzoRepository;
import com.company.resourcemanager.repository.HrBpAssignmentRepository;
import com.company.resourcemanager.repository.UserRepository;
import com.company.resourcemanager.repository.UserRoleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class RoleService {

    private final UserRoleRepository userRoleRepository;
    private final HrBpAssignmentRepository hrBpAssignmentRepository;
    private final UserRepository userRepository;
    private final DzoRepository dzoRepository;

    @Transactional
    public void assignRole(Long userId, Role role) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found: " + userId));

        if (!userRoleRepository.existsByUserIdAndRole(userId, role)) {
            UserRole userRole = new UserRole(user, role);
            userRoleRepository.save(userRole);
        }
    }

    @Transactional
    public void removeRole(Long userId, Role role) {
        userRoleRepository.deleteByUserIdAndRole(userId, role);
    }

    @Transactional(readOnly = true)
    public Set<Role> getUserRoles(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found: " + userId));
        return user.getRoles();
    }

    @Transactional(readOnly = true)
    public List<User> getUsersByRole(Role role) {
        return userRoleRepository.findUsersByRole(role);
    }

    @Transactional
    public void assignHrBpToDzo(Long userId, Long dzoId, Long assignedByUserId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found: " + userId));
        Dzo dzo = dzoRepository.findById(dzoId)
                .orElseThrow(() -> new RuntimeException("DZO not found: " + dzoId));
        User assignedBy = userRepository.findById(assignedByUserId)
                .orElseThrow(() -> new RuntimeException("Assigned by user not found: " + assignedByUserId));

        if (!hrBpAssignmentRepository.existsByUserIdAndDzoId(userId, dzoId)) {
            HrBpAssignment assignment = new HrBpAssignment(user, dzo, assignedBy);
            hrBpAssignmentRepository.save(assignment);
        }
    }

    @Transactional
    public void removeHrBpFromDzo(Long userId, Long dzoId) {
        hrBpAssignmentRepository.deleteByUserIdAndDzoId(userId, dzoId);
    }

    @Transactional(readOnly = true)
    public List<Dzo> getDzosForHrBp(Long userId) {
        return hrBpAssignmentRepository.findDzosByUserId(userId);
    }

    @Transactional(readOnly = true)
    public List<User> getHrBpsForDzo(Long dzoId) {
        return hrBpAssignmentRepository.findUsersByDzoId(dzoId);
    }
}
