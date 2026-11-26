package com.mealfit.domain.allergen.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;
import java.io.Serializable;
import lombok.AccessLevel;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

/** 재료 이름 → 알레르기 유발물질 연결 (V13 시드). 재료 사전이 없어 이름(텍스트)으로 연결한다. */
@Getter
@Entity
@Table(name = "ingredient_allergens")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class IngredientAllergen {

    @EmbeddedId
    private Key id;

    @MapsId("allergenId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "allergen_id")
    private Allergen allergen;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private AllergenCertainty certainty;

    public String getIngredientName() {
        return id.getIngredientName();
    }

    /** 복합 키: 재료 이름 + 알레르기 */
    @Embeddable
    @Getter
    @EqualsAndHashCode
    @NoArgsConstructor(access = AccessLevel.PROTECTED)
    public static class Key implements Serializable {

        @Column(name = "ingredient_name", nullable = false, length = 100)
        private String ingredientName;

        @Column(name = "allergen_id", nullable = false)
        private Long allergenId;
    }
}
