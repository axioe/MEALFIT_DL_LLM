package com.mealfit.domain.allergen.entity;

import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Table;
import java.util.HashSet;
import java.util.Set;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 알레르기 유발물질 사전 (공용 참조 데이터, V13 시드).
 * 현행 19종 + 개정 예고 4종. 카테고리는 화면 묶음용이고, 회원 선택은 개별 항목으로 저장한다.
 */
@Getter
@Entity
@Table(name = "allergens")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Allergen {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 30, unique = true)
    private String code;

    @Column(nullable = false, length = 50, unique = true)
    private String name;

    @Column(nullable = false, length = 30)
    private String category;

    @Column(name = "category_order", nullable = false)
    private int categoryOrder;

    @Column(name = "display_order", nullable = false)
    private int displayOrder;

    /** 묶음의 [전체 선택]에 포함되는지 (육류·첨가물은 개별 선택만) */
    @Column(name = "select_all", nullable = false)
    private boolean selectAll;

    @Enumerated(EnumType.STRING)
    @Column(name = "legal_status", nullable = false, length = 20)
    private AllergenLegalStatus legalStatus;

    @Column(name = "legal_condition", length = 200)
    private String legalCondition;

    @ElementCollection
    @CollectionTable(name = "allergen_aliases", joinColumns = @JoinColumn(name = "allergen_id"))
    @Column(name = "alias", nullable = false, length = 50)
    private Set<String> aliases = new HashSet<>();

    public Set<String> getAliases() {
        return Set.copyOf(aliases);
    }
}
