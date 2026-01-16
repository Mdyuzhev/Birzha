package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.EmployeeResumeDTO;
import com.company.resourcemanager.dto.ResumeCreateDTO;
import com.company.resourcemanager.entity.Employee;
import com.company.resourcemanager.entity.EmployeeResume;
import com.company.resourcemanager.repository.EmployeeRepository;
import com.company.resourcemanager.repository.EmployeeResumeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ResumeService {

    private final EmployeeResumeRepository resumeRepository;
    private final EmployeeRepository employeeRepository;

    public List<EmployeeResumeDTO> getAllResumes() {
        return resumeRepository.findAllWithEmployees().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<EmployeeResumeDTO> searchByName(String query) {
        if (query == null || query.trim().isEmpty()) {
            return getAllResumes();
        }
        return resumeRepository.searchByEmployeeName(query.trim()).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public EmployeeResumeDTO getByEmployeeId(Long employeeId) {
        return resumeRepository.findByEmployeeIdWithEmployee(employeeId)
                .map(this::toDTO)
                .orElse(null);
    }

    public EmployeeResumeDTO getById(Long id) {
        return resumeRepository.findByIdWithEmployee(id)
                .map(this::toDTO)
                .orElseThrow(() -> new RuntimeException("Resume not found"));
    }

    @Transactional
    public EmployeeResumeDTO createOrUpdate(ResumeCreateDTO dto) {
        Employee employee = employeeRepository.findById(dto.getEmployeeId())
                .orElseThrow(() -> new RuntimeException("Employee not found"));

        EmployeeResume resume = resumeRepository.findByEmployeeId(dto.getEmployeeId())
                .orElse(new EmployeeResume());

        resume.setEmployee(employee);
        resume.setPosition(dto.getPosition());
        resume.setSummary(dto.getSummary());
        resume.setSkills(dto.getSkills());
        resume.setExperience(dto.getExperience());
        resume.setEducation(dto.getEducation());
        resume.setCertifications(dto.getCertifications());
        resume.setLanguages(dto.getLanguages());

        return toDTO(resumeRepository.save(resume));
    }

    @Transactional
    public void delete(Long id) {
        resumeRepository.deleteById(id);
    }

    @Transactional
    public void deleteByEmployeeId(Long employeeId) {
        resumeRepository.deleteByEmployeeId(employeeId);
    }

    private EmployeeResumeDTO toDTO(EmployeeResume resume) {
        Employee emp = resume.getEmployee();
        return EmployeeResumeDTO.builder()
                .id(resume.getId())
                .employeeId(emp.getId())
                .employeeName(emp.getFullName())
                .employeeEmail(emp.getEmail())
                .position(resume.getPosition())
                .summary(resume.getSummary())
                .skills(resume.getSkills())
                .experience(resume.getExperience())
                .education(resume.getEducation())
                .certifications(resume.getCertifications())
                .languages(resume.getLanguages())
                .createdAt(resume.getCreatedAt())
                .updatedAt(resume.getUpdatedAt())
                .build();
    }
}
