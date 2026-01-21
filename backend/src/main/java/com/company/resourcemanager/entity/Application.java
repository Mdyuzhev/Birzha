package com.company.resourcemanager.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "applications")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Application {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Связь с ДЗО
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dzo_id", nullable = false)
    private Dzo dzo;

    // Кандидат на ротацию
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    // Кто создал заявку (Руководитель или HR BP)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by", nullable = false)
    private User createdBy;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    // Статус заявки
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private ApplicationStatus status;

    // Целевая позиция
    @Column(length = 255)
    private String targetPosition;

    // Целевой стек (справочник)
    @Column(length = 100)
    private String targetStack;

    // Текущая и целевая ЗП
    @Column(precision = 12, scale = 2)
    private BigDecimal currentSalary;

    @Column(precision = 12, scale = 2)
    private BigDecimal targetSalary;

    // Процент увеличения ЗП (вычисляемое поле)
    @Column(precision = 5, scale = 2)
    private BigDecimal salaryIncreasePercent;

    // Требуется ли согласование БОРУП (>30%)
    @Column(nullable = false)
    @Builder.Default
    private Boolean requiresBorupApproval = false;

    // Прикреплённое резюме (путь к файлу или ID)
    @Column(length = 500)
    private String resumeFilePath;

    // Комментарий при создании
    @Column(columnDefinition = "TEXT")
    private String comment;

    // === Назначенные участники ===

    // Рекрутер, взявший заявку в работу
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recruiter_id")
    private User recruiter;

    private LocalDateTime assignedToRecruiterAt;

    // HR BP отдающей стороны
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hr_bp_id")
    private User hrBp;

    // БОРУП (если требуется)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "borup_id")
    private User borup;

    // === Решения согласующих ===

    // Решение HR BP
    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private DecisionType hrBpDecision;

    @Column(columnDefinition = "TEXT")
    private String hrBpComment;

    private LocalDateTime hrBpDecisionAt;

    // Решение БОРУП
    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private DecisionType borupDecision;

    @Column(columnDefinition = "TEXT")
    private String borupComment;

    private LocalDateTime borupDecisionAt;

    // === Итоговое решение ===

    @Column(columnDefinition = "TEXT")
    private String finalComment;

    private LocalDate transferDate;

    private LocalDateTime completedAt;

    // === Callbacks ===

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (status == null) {
            status = ApplicationStatus.DRAFT;
        }
        calculateSalaryIncrease();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
        calculateSalaryIncrease();
    }

    private void calculateSalaryIncrease() {
        if (currentSalary != null && targetSalary != null &&
            currentSalary.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal increase = targetSalary.subtract(currentSalary)
                .divide(currentSalary, 4, RoundingMode.HALF_UP)
                .multiply(new BigDecimal("100"));
            this.salaryIncreasePercent = increase.setScale(2, RoundingMode.HALF_UP);
            this.requiresBorupApproval = increase.compareTo(new BigDecimal("30")) > 0;
        }
    }
}
