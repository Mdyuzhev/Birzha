package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.CreateDzoRequest;
import com.company.resourcemanager.dto.UpdateDzoRequest;
import com.company.resourcemanager.entity.Dzo;
import com.company.resourcemanager.exception.ResourceNotFoundException;
import com.company.resourcemanager.repository.DzoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DzoService {
    private final DzoRepository dzoRepository;

    public List<Dzo> getAllActive() {
        return dzoRepository.findByIsActiveTrue();
    }

    public Dzo getById(Long id) {
        return dzoRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("DZO not found: " + id));
    }

    public Dzo getByCode(String code) {
        return dzoRepository.findByCode(code)
            .orElseThrow(() -> new ResourceNotFoundException("DZO not found: " + code));
    }

    @Transactional
    public Dzo create(CreateDzoRequest request) {
        Dzo dzo = Dzo.builder()
            .code(request.getCode())
            .name(request.getName())
            .emailDomain(request.getEmailDomain())
            .isActive(true)
            .build();
        return dzoRepository.save(dzo);
    }

    @Transactional
    public Dzo update(Long id, UpdateDzoRequest request) {
        Dzo dzo = getById(id);
        dzo.setName(request.getName());
        dzo.setEmailDomain(request.getEmailDomain());
        dzo.setIsActive(request.getIsActive());
        return dzoRepository.save(dzo);
    }
}
