package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.Role;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.entity.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRoleRepository extends JpaRepository<UserRole, Long> {

    List<UserRole> findByUser(User user);

    List<UserRole> findByUserId(Long userId);

    List<UserRole> findByRole(Role role);

    Optional<UserRole> findByUserIdAndRole(Long userId, Role role);

    boolean existsByUserIdAndRole(Long userId, Role role);

    void deleteByUserIdAndRole(Long userId, Role role);

    void deleteByUserId(Long userId);

    @Query("SELECT ur.user FROM UserRole ur WHERE ur.role = :role")
    List<User> findUsersByRole(@Param("role") Role role);
}
