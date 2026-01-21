package com.company.resourcemanager.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "blacklist", indexes = {
    @Index(name = "idx_blacklist_dzo", columnList = "dzo_id"),
    @Index(name = "idx_blacklist_email", columnList = "email"),
    @Index(name = "idx_blacklist_full_name", columnList = "full_name"),
    @Index(name = "idx_blacklist_is_active", columnList = "is_active"),
    @Index(name = "idx_blacklist_employee", columnList = "employee_id")
})
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BlacklistEntry {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dzo_id", nullable = false)
    private Dzo dzo;

    // Связь с сотрудником (опционально — может быть внешний кандидат)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "employee_id")
    private Employee employee;

    // ФИО (обязательно, даже если есть employee)
    @Column(name = "full_name", nullable = false)
    private String fullName;

    // Email (для поиска дубликатов)
    @Column(name = "email")
    private String email;

    // Телефон
    @Column(name = "phone")
    private String phone;

    // Причина добавления в ЧС (обязательно)
    @Column(name = "reason", nullable = false, columnDefinition = "TEXT")
    private String reason;

    // Категория причины
    @Enumerated(EnumType.STRING)
    @Column(name = "reason_category", nullable = false)
    private BlacklistReasonCategory reasonCategory;

    // Источник информации (откуда узнали о проблеме)
    @Column(name = "source")
    private String source;

    // Активен ли (false = снят с ЧС)
    @Column(name = "is_active", nullable = false)
    @Builder.Default
    private Boolean isActive = true;

    // Кто добавил
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "added_by", nullable = false)
    private User addedBy;

    // Когда добавлен
    @Column(name = "added_at", nullable = false)
    @Builder.Default
    private LocalDateTime addedAt = LocalDateTime.now();

    // Срок действия (null = бессрочно)
    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    // Кто снял с ЧС
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "removed_by")
    private User removedBy;

    // Когда снят
    @Column(name = "removed_at")
    private LocalDateTime removedAt;

    // Причина снятия
    @Column(name = "removal_reason")
    private String removalReason;

    // Дополнительные данные (JSON)
    @Column(name = "metadata", columnDefinition = "TEXT")
    private String metadata;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at", nullable = false)
    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    // Проверка истёк ли срок
    public boolean isExpired() {
        return expiresAt != null && LocalDateTime.now().isAfter(expiresAt);
    }

    // Эффективно активен (активен И не истёк)
    public boolean isEffectivelyActive() {
        return isActive && !isExpired();
    }
}
