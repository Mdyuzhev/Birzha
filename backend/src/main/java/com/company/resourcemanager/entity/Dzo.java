package com.company.resourcemanager.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "dzos")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Dzo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String code;  // Уникальный код: "rt-dc", "rt-solar", "bft"

    @Column(nullable = false, length = 255)
    private String name;  // Полное название: "ЦОД", "Солар"

    @Column(length = 100)
    private String emailDomain;  // Email домен: "rt-dc.ru", "rt-solar.ru"

    @Column(nullable = false)
    private Boolean isActive = true;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
