package com.mealfit.domain.recipe.entity;

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
 * 재료 기준표 (V15 시드, 59종). 냉장고 재료와 레시피 재료를 비교할 때 쓴다.
 * 보유 계산 규칙, 서로 바꿔 쓸 수 있는 대체 그룹, 냉장고 입력 별칭(예: 참치캔 → 참치 통조림)을 담는다.
 */
@Getter
@Entity
@Table(name = "ingredient_standards")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class IngredientStandard {

    public enum Role {
        BASE, PROTEIN, VEGETABLE, FRUIT_NUT, BEVERAGE, SEASONING, PANTRY
    }

    /** REQUIRED: 없으면 추가 재료 / OPTIONAL: 있으면 더 좋음 / EXCLUDED: 늘 있다고 봄 */
    public enum OwnershipRule {
        REQUIRED, OPTIONAL, EXCLUDED
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100, unique = true)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Role role;

    @Enumerated(EnumType.STRING)
    @Column(name = "ownership_rule", nullable = false, length = 20)
    private OwnershipRule ownershipRule;

    @Column(name = "substitute_group", length = 30)
    private String substituteGroup;

    @Column(nullable = false, length = 20)
    private String unit;

    @ElementCollection
    @CollectionTable(name = "ingredient_standard_aliases", joinColumns = @JoinColumn(name = "ingredient_standard_id"))
    @Column(name = "alias", nullable = false, length = 100)
    private Set<String> aliases = new HashSet<>();

    public Set<String> getAliases() {
        return Set.copyOf(aliases);
    }
}
