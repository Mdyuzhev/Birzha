package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    boolean existsByUsername(String username);

    Page<User> findByUsernameContainingIgnoreCaseOrFullNameContainingIgnoreCase(
        String username, String fullName, Pageable pageable);

    default Page<User> searchUsers(String search, Pageable pageable) {
        if (search == null || search.isBlank()) {
            return findAll(pageable);
        }
        return findByUsernameContainingIgnoreCaseOrFullNameContainingIgnoreCase(search, search, pageable);
    }
}
