package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.CreateUserRequest;
import com.company.resourcemanager.dto.UpdateUserRequest;
import com.company.resourcemanager.dto.UserDto;
import com.company.resourcemanager.entity.Dzo;
import com.company.resourcemanager.entity.Role;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.repository.DzoRepository;
import com.company.resourcemanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final DzoRepository dzoRepository;

    public List<UserDto> getAllUsers() {
        return userRepository.findAll()
                .stream()
                .map(UserDto::fromEntity)
                .collect(Collectors.toList());
    }

    public Page<UserDto> searchUsers(String search, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        return userRepository.searchUsers(search, pageable)
                .map(UserDto::fromEntity);
    }

    public UserDto getUserById(Long id) {
        return userRepository.findById(id)
                .map(UserDto::fromEntity)
                .orElse(null);
    }

    @Transactional
    public UserDto createUser(CreateUserRequest request, User currentUser) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("Username already exists");
        }

        Dzo dzo = null;
        if (request.getDzoId() != null) {
            dzo = dzoRepository.findById(request.getDzoId())
                    .orElseThrow(() -> new IllegalArgumentException("DZO not found"));
        }

        User user = User.builder()
                .username(request.getUsername())
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .fullName(request.getFullName())
                .userRoles(new HashSet<>())
                .createdBy(currentUser)
                .dzo(dzo)
                .build();

        User saved = userRepository.save(user);

        for (String roleName : request.getRoles()) {
            try {
                Role role = Role.valueOf(roleName);
                saved.addRole(role);
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Invalid role: " + roleName);
            }
        }

        saved = userRepository.save(saved);
        return UserDto.fromEntity(saved);
    }

    @Transactional
    public UserDto updateUser(Long id, UpdateUserRequest request) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (request.getPassword() != null && !request.getPassword().isEmpty()) {
            user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        }

        if (request.getFullName() != null) {
            user.setFullName(request.getFullName());
        }

        if (request.getRoles() != null && !request.getRoles().isEmpty()) {
            user.getUserRoles().clear();
            for (String roleName : request.getRoles()) {
                try {
                    Role role = Role.valueOf(roleName);
                    user.addRole(role);
                } catch (IllegalArgumentException e) {
                    throw new IllegalArgumentException("Invalid role: " + roleName);
                }
            }
        }

        if (request.getDzoId() != null) {
            Dzo dzo = dzoRepository.findById(request.getDzoId())
                    .orElseThrow(() -> new IllegalArgumentException("DZO not found"));
            user.setDzo(dzo);
        }

        User saved = userRepository.save(user);
        return UserDto.fromEntity(saved);
    }

    @Transactional
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }
}
