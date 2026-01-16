package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.EmployeeResumeDTO;
import com.company.resourcemanager.dto.ResumeCreateDTO;
import com.company.resourcemanager.service.ResumeService;
import com.company.resourcemanager.service.ResumePdfService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/resumes")
@RequiredArgsConstructor
public class ResumeController {

    private final ResumeService resumeService;
    private final ResumePdfService pdfService;

    @GetMapping
    public List<EmployeeResumeDTO> getAllResumes(@RequestParam(required = false) String search) {
        if (search != null && !search.trim().isEmpty()) {
            return resumeService.searchByName(search);
        }
        return resumeService.getAllResumes();
    }

    @GetMapping("/{id}")
    public EmployeeResumeDTO getById(@PathVariable Long id) {
        return resumeService.getById(id);
    }

    @GetMapping("/employee/{employeeId}")
    public ResponseEntity<EmployeeResumeDTO> getByEmployeeId(@PathVariable Long employeeId) {
        EmployeeResumeDTO resume = resumeService.getByEmployeeId(employeeId);
        if (resume == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(resume);
    }

    @PostMapping
    public EmployeeResumeDTO create(@Valid @RequestBody ResumeCreateDTO dto) {
        return resumeService.createOrUpdate(dto);
    }

    @PutMapping("/{id}")
    public EmployeeResumeDTO update(@PathVariable Long id, @Valid @RequestBody ResumeCreateDTO dto) {
        return resumeService.createOrUpdate(dto);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        resumeService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/pdf")
    public ResponseEntity<byte[]> exportPdf(@PathVariable Long id) {
        EmployeeResumeDTO resume = resumeService.getById(id);
        byte[] pdfBytes = pdfService.generatePdf(resume);

        String filename = resume.getEmployeeName().replaceAll("[^a-zA-Zа-яА-Я0-9]", "_") + "_resume.pdf";

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                .body(pdfBytes);
    }

    @GetMapping("/employee/{employeeId}/pdf")
    public ResponseEntity<byte[]> exportPdfByEmployee(@PathVariable Long employeeId) {
        EmployeeResumeDTO resume = resumeService.getByEmployeeId(employeeId);
        if (resume == null) {
            return ResponseEntity.notFound().build();
        }
        byte[] pdfBytes = pdfService.generatePdf(resume);

        String filename = resume.getEmployeeName().replaceAll("[^a-zA-Zа-яА-Я0-9]", "_") + "_resume.pdf";

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                .body(pdfBytes);
    }
}
