package com.company.resourcemanager.service;

import com.company.resourcemanager.entity.ColumnDefinition;
import com.company.resourcemanager.entity.Employee;
import com.company.resourcemanager.repository.ColumnDefinitionRepository;
import com.company.resourcemanager.repository.EmployeeRepository;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ExcelExportService {

    private final EmployeeRepository employeeRepository;
    private final ColumnDefinitionRepository columnDefinitionRepository;

    public byte[] exportEmployees(Specification<Employee> spec) throws IOException {
        List<Employee> employees = spec != null
            ? employeeRepository.findAll(spec)
            : employeeRepository.findAll();

        List<ColumnDefinition> columns = columnDefinitionRepository.findAllByOrderBySortOrderAsc();

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Сотрудники");

            // Стиль заголовков
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);

            // Стиль данных
            CellStyle dataStyle = workbook.createCellStyle();
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);

            // Заголовки
            Row headerRow = sheet.createRow(0);
            int colIdx = 0;

            Cell cell = headerRow.createCell(colIdx++);
            cell.setCellValue("ФИО");
            cell.setCellStyle(headerStyle);

            cell = headerRow.createCell(colIdx++);
            cell.setCellValue("Email");
            cell.setCellStyle(headerStyle);

            for (ColumnDefinition col : columns) {
                cell = headerRow.createCell(colIdx++);
                cell.setCellValue(col.getDisplayName());
                cell.setCellStyle(headerStyle);
            }

            // Данные
            int rowIdx = 1;
            for (Employee emp : employees) {
                Row row = sheet.createRow(rowIdx++);
                colIdx = 0;

                Cell dataCell = row.createCell(colIdx++);
                dataCell.setCellValue(emp.getFullName());
                dataCell.setCellStyle(dataStyle);

                dataCell = row.createCell(colIdx++);
                dataCell.setCellValue(emp.getEmail() != null ? emp.getEmail() : "");
                dataCell.setCellStyle(dataStyle);

                Map<String, Object> customFields = emp.getCustomFields();
                for (ColumnDefinition col : columns) {
                    dataCell = row.createCell(colIdx++);
                    Object value = customFields != null ? customFields.get(col.getName()) : null;
                    dataCell.setCellValue(value != null ? value.toString() : "");
                    dataCell.setCellStyle(dataStyle);
                }
            }

            // Автоширина колонок
            for (int i = 0; i < colIdx; i++) {
                sheet.autoSizeColumn(i);
            }

            ByteArrayOutputStream out = new ByteArrayOutputStream();
            workbook.write(out);
            return out.toByteArray();
        }
    }
}
