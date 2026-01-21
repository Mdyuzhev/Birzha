package com.company.resourcemanager.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "blacklist_history", indexes = {
    @Index(name = "idx_blacklist_history_entry", columnList = "blacklist_entry_id"),
    @Index(name = "idx_blacklist_history_action", columnList = "action")
})
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BlacklistHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "blacklist_entry_id", nullable = false)
    private BlacklistEntry blacklistEntry;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "changed_by", nullable = false)
    private User changedBy;

    @Column(name = "changed_at", nullable = false)
    @Builder.Default
    private LocalDateTime changedAt = LocalDateTime.now();

    @Column(name = "action", nullable = false)
    private String action; // ADD, UPDATE, REMOVE, REACTIVATE

    @Column(name = "comment", columnDefinition = "TEXT")
    private String comment;

    @Column(name = "details", columnDefinition = "TEXT")
    private String details; // JSON с изменениями
}
