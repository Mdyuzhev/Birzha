package com.company.resourcemanager.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "nine_box_assessments")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NineBoxAssessment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "assessed_by", nullable = false)
    private User assessedBy;

    @Column(name = "assessed_at")
    private LocalDateTime assessedAt;

    @Column(name = "q1_results", nullable = false)
    private Integer q1Results;

    @Column(name = "q2_goals", nullable = false)
    private Integer q2Goals;

    @Column(name = "q3_quality", nullable = false)
    private Integer q3Quality;

    @Column(name = "q4_growth", nullable = false)
    private Integer q4Growth;

    @Column(name = "q5_leadership", nullable = false)
    private Integer q5Leadership;

    @Column(name = "performance_score", nullable = false, precision = 3, scale = 2)
    private BigDecimal performanceScore;

    @Column(name = "potential_score", nullable = false, precision = 3, scale = 2)
    private BigDecimal potentialScore;

    @Column(name = "box_position", nullable = false)
    private Integer boxPosition;

    @Column(columnDefinition = "TEXT")
    private String comment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dzo_id")
    private Dzo dzo;

    @PrePersist
    protected void onCreate() {
        assessedAt = LocalDateTime.now();
        calculateScores();
    }

    @PreUpdate
    protected void onUpdate() {
        calculateScores();
    }

    public void calculateScores() {
        // Performance = среднее q1, q2, q3
        double perf = (q1Results + q2Goals + q3Quality) / 3.0;
        this.performanceScore = BigDecimal.valueOf(perf).setScale(2, java.math.RoundingMode.HALF_UP);

        // Potential = среднее q4, q5
        double pot = (q4Growth + q5Leadership) / 2.0;
        this.potentialScore = BigDecimal.valueOf(pot).setScale(2, java.math.RoundingMode.HALF_UP);

        // Box position (1-9)
        int perfLevel = getLevel(perf);   // 0=Low, 1=Med, 2=High
        int potLevel = getLevel(pot);

        // Matrix: potLevel * 3 + perfLevel + 1
        this.boxPosition = potLevel * 3 + perfLevel + 1;
    }

    private int getLevel(double score) {
        if (score <= 2.3) return 0;       // Low
        else if (score <= 3.6) return 1;  // Medium
        else return 2;                     // High
    }
}
