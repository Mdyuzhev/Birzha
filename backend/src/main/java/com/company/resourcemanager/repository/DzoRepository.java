package com.company.resourcemanager.repository;

import com.company.resourcemanager.entity.Dzo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DzoRepository extends JpaRepository<Dzo, Long> {
    Optional<Dzo> findByCode(String code);
    List<Dzo> findByIsActiveTrue();
    Optional<Dzo> findByEmailDomain(String emailDomain);
}
