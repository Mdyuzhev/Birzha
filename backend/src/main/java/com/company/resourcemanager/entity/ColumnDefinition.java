package com.company.resourcemanager.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "column_definitions")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ColumnDefinition {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String name;

    @Column(name = "display_name", nullable = false, length = 100)
    private String displayName;

    @Enumerated(EnumType.STRING)
    @Column(name = "field_type", nullable = false, length = 20)
    private FieldType fieldType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dictionary_id")
    private Dictionary dictionary;

    @Column(name = "sort_order")
    private Integer sortOrder;

    @Column(name = "is_required")
    private Boolean isRequired;

    public enum FieldType {
        TEXT, SELECT, DATE, NUMBER
    }
}
