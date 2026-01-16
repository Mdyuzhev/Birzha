package com.company.resourcemanager.service;

import com.company.resourcemanager.dto.EmployeeResumeDTO;
import com.lowagie.text.*;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfWriter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class ResumePdfService {

    private Font titleFont;
    private Font headerFont;
    private Font subHeaderFont;
    private Font normalFont;
    private Font smallFont;

    public ResumePdfService() {
        try {
            BaseFont baseFont = BaseFont.createFont(BaseFont.HELVETICA, "Cp1251", BaseFont.EMBEDDED);
            titleFont = new Font(baseFont, 18, Font.BOLD);
            headerFont = new Font(baseFont, 14, Font.BOLD);
            subHeaderFont = new Font(baseFont, 12, Font.BOLD);
            normalFont = new Font(baseFont, 11, Font.NORMAL);
            smallFont = new Font(baseFont, 10, Font.ITALIC);
        } catch (Exception e) {
            log.warn("Could not create Cp1251 font, using default", e);
            titleFont = new Font(Font.HELVETICA, 18, Font.BOLD);
            headerFont = new Font(Font.HELVETICA, 14, Font.BOLD);
            subHeaderFont = new Font(Font.HELVETICA, 12, Font.BOLD);
            normalFont = new Font(Font.HELVETICA, 11, Font.NORMAL);
            smallFont = new Font(Font.HELVETICA, 10, Font.ITALIC);
        }
    }

    public byte[] generatePdf(EmployeeResumeDTO resume) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            Document document = new Document(PageSize.A4, 50, 50, 50, 50);
            PdfWriter.getInstance(document, baos);
            document.open();

            // Header - Name
            Paragraph name = new Paragraph(resume.getEmployeeName(), titleFont);
            name.setAlignment(Element.ALIGN_CENTER);
            document.add(name);

            // Position
            if (resume.getPosition() != null && !resume.getPosition().isEmpty()) {
                Paragraph position = new Paragraph(resume.getPosition(), subHeaderFont);
                position.setAlignment(Element.ALIGN_CENTER);
                position.setSpacingBefore(5);
                document.add(position);
            }

            // Contact
            if (resume.getEmployeeEmail() != null) {
                Paragraph email = new Paragraph(resume.getEmployeeEmail(), smallFont);
                email.setAlignment(Element.ALIGN_CENTER);
                email.setSpacingBefore(5);
                document.add(email);
            }

            document.add(new Paragraph(" "));

            // Summary
            if (resume.getSummary() != null && !resume.getSummary().isEmpty()) {
                addSection(document, "О себе", resume.getSummary());
            }

            // Skills
            if (resume.getSkills() != null && !resume.getSkills().isEmpty()) {
                addSectionHeader(document, "Ключевые навыки");
                for (Map<String, Object> skill : resume.getSkills()) {
                    String skillName = getString(skill, "name");
                    String level = getString(skill, "level");
                    String years = getString(skill, "years");

                    StringBuilder sb = new StringBuilder("• " + skillName);
                    if (level != null && !level.isEmpty()) {
                        sb.append(" - ").append(level);
                    }
                    if (years != null && !years.isEmpty()) {
                        sb.append(" (").append(years).append(" лет)");
                    }
                    document.add(new Paragraph(sb.toString(), normalFont));
                }
                document.add(new Paragraph(" "));
            }

            // Experience
            if (resume.getExperience() != null && !resume.getExperience().isEmpty()) {
                addSectionHeader(document, "Опыт работы");
                for (Map<String, Object> exp : resume.getExperience()) {
                    String company = getString(exp, "company");
                    String pos = getString(exp, "position");
                    String startDate = getString(exp, "startDate");
                    String endDate = getString(exp, "endDate");
                    String description = getString(exp, "description");

                    Paragraph companyP = new Paragraph(company, subHeaderFont);
                    document.add(companyP);

                    String period = startDate + " - " + (endDate != null && !endDate.isEmpty() ? endDate : "по настоящее время");
                    Paragraph posP = new Paragraph(pos + " | " + period, smallFont);
                    document.add(posP);

                    if (description != null && !description.isEmpty()) {
                        Paragraph descP = new Paragraph(description, normalFont);
                        descP.setSpacingBefore(5);
                        document.add(descP);
                    }

                    // Projects
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> projects = (List<Map<String, Object>>) exp.get("projects");
                    if (projects != null && !projects.isEmpty()) {
                        Paragraph projHeader = new Paragraph("Проекты:", normalFont);
                        projHeader.setSpacingBefore(5);
                        document.add(projHeader);
                        for (Map<String, Object> proj : projects) {
                            String projName = getString(proj, "name");
                            String projDesc = getString(proj, "description");
                            document.add(new Paragraph("  • " + projName + (projDesc != null ? ": " + projDesc : ""), normalFont));
                        }
                    }

                    document.add(new Paragraph(" "));
                }
            }

            // Education
            if (resume.getEducation() != null && !resume.getEducation().isEmpty()) {
                addSectionHeader(document, "Образование");
                for (Map<String, Object> edu : resume.getEducation()) {
                    String institution = getString(edu, "institution");
                    String degree = getString(edu, "degree");
                    String field = getString(edu, "field");
                    String year = getString(edu, "year");

                    Paragraph instP = new Paragraph(institution + (year != null ? " (" + year + ")" : ""), subHeaderFont);
                    document.add(instP);

                    if (degree != null || field != null) {
                        String eduDetails = (degree != null ? degree : "") + (field != null ? ", " + field : "");
                        document.add(new Paragraph(eduDetails, normalFont));
                    }
                }
                document.add(new Paragraph(" "));
            }

            // Certifications
            if (resume.getCertifications() != null && !resume.getCertifications().isEmpty()) {
                addSectionHeader(document, "Сертификаты");
                for (Map<String, Object> cert : resume.getCertifications()) {
                    String certName = getString(cert, "name");
                    String issuer = getString(cert, "issuer");
                    String year = getString(cert, "year");

                    StringBuilder sb = new StringBuilder("• " + certName);
                    if (issuer != null) sb.append(" - ").append(issuer);
                    if (year != null) sb.append(" (").append(year).append(")");
                    document.add(new Paragraph(sb.toString(), normalFont));
                }
                document.add(new Paragraph(" "));
            }

            // Languages
            if (resume.getLanguages() != null && !resume.getLanguages().isEmpty()) {
                addSectionHeader(document, "Языки");
                for (Map<String, Object> lang : resume.getLanguages()) {
                    String language = getString(lang, "language");
                    String level = getString(lang, "level");
                    document.add(new Paragraph("• " + language + " - " + level, normalFont));
                }
            }

            document.close();
        } catch (Exception e) {
            log.error("Error generating PDF", e);
            throw new RuntimeException("Failed to generate PDF: " + e.getMessage());
        }

        return baos.toByteArray();
    }

    private void addSectionHeader(Document document, String title) throws DocumentException {
        Paragraph header = new Paragraph(title, headerFont);
        header.setSpacingBefore(10);
        header.setSpacingAfter(5);
        document.add(header);

        // Line separator
        Paragraph line = new Paragraph("_".repeat(70), normalFont);
        line.setSpacingAfter(10);
        document.add(line);
    }

    private void addSection(Document document, String title, String content) throws DocumentException {
        addSectionHeader(document, title);
        Paragraph p = new Paragraph(content, normalFont);
        p.setSpacingAfter(10);
        document.add(p);
    }

    private String getString(Map<String, Object> map, String key) {
        Object value = map.get(key);
        return value != null ? value.toString() : null;
    }
}
