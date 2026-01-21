package com.company.resourcemanager.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "application_history")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ApplicationHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "application_id", nullable = false)
    private Application application;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "changed_by", nullable = false)
    private User changedBy;

    @Column(nullable = false)
    private LocalDateTime changedAt;

    @Enumerated(EnumType.STRING)
    @Column(length = 50)
    private ApplicationStatus oldStatus;

    @Enumerated(EnumType.STRING)
    @Column(length = 50)
    private ApplicationStatus newStatus;

    @Column(length = 100)
    private String action;  // CREATE, STATUS_CHANGE, ASSIGN_RECRUITER, HR_BP_DECISION, etc.

    @Column(columnDefinition = "TEXT")
    private String comment;

    @Column(columnDefinition = "TEXT")
    private String details;  // JSON с дополнительными данными

    @PrePersist
    protected void onCreate() {
        changedAt = LocalDateTime.now();
    }
}
