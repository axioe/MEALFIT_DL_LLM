package com.mealfit.domain.recipe.entity;

import com.mealfit.domain.mealplan.entity.MealType;
import com.mealfit.global.common.BaseTimeEntity;
import jakarta.persistence.CascadeType;
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
import jakarta.persistence.OneToMany;
import jakarta.persistence.OrderColumn;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@Table(name = "recipes")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Recipe extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** null이면 공용(시드/로컬 대체) 레시피 */
    @Column(name = "user_id")
    private Long userId;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 500)
    private String description;

    /** 기준 인분. 실제 필요량 = 재료량 × 실제 인분 / servingSize */
    @Column(name = "serving_size", nullable = false)
    private int servingSize;

    @Column(name = "cook_time_min", nullable = false)
    private int cookTimeMin;

    @Column(precision = 8, scale = 1)
    private BigDecimal calories;

    @Column(name = "protein_g", precision = 8, scale = 1)
    private BigDecimal proteinG;

    @Column(name = "carbs_g", precision = 8, scale = 1)
    private BigDecimal carbsG;

    @Column(name = "fat_g", precision = 8, scale = 1)
    private BigDecimal fatG;

    /** 근거 없는 영양 수치는 true → 화면에 "추정치" 표시 */
    @Column(name = "nutrition_estimated", nullable = false)
    private boolean nutritionEstimated;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private RecipeSource source;

    /** 로컬 대체 후보로 쓸 끼니. null이면 모든 끼니에 쓸 수 있다. */
    @Enumerated(EnumType.STRING)
    @Column(name = "meal_type", length = 20)
    private MealType mealType;

    @ElementCollection
    @CollectionTable(name = "recipe_steps", joinColumns = @JoinColumn(name = "recipe_id"))
    @OrderColumn(name = "step_order")
    @Column(name = "description", nullable = false, length = 500)
    private List<String> steps = new ArrayList<>();

    @OneToMany(mappedBy = "recipe", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<RecipeIngredient> ingredients = new ArrayList<>();

    /** 검수 레시피(V15 시드)의 원본 코드. 다른 레시피는 null */
    @Column(name = "recipe_code", length = 20, unique = true)
    private String recipeCode;

    /** 검수 레시피의 끼니 구분 (아침 / 점심·저녁 공용). null이면 mealType 기준 */
    @Enumerated(EnumType.STRING)
    @Column(name = "meal_slot", length = 20)
    private RecipeMealSlot mealSlot;

    /** 요리 형태 (예: 현미 덮밥, 간장 달걀밥) */
    @Column(name = "dish_type", length = 50)
    private String dishType;

    /** 같은 요리의 변형 묶음 (예: 소스만 다른 레시피). 비슷한 메뉴 연속 추천을 막는 데 쓴다 */
    @Column(name = "dish_group", length = 100)
    private String dishGroup;

    @Column(name = "recommendation_reason", length = 300)
    private String recommendationReason;

    @Builder
    private Recipe(Long userId, String name, String description, int servingSize, int cookTimeMin,
                   BigDecimal calories, BigDecimal proteinG, BigDecimal carbsG, BigDecimal fatG,
                   boolean nutritionEstimated, RecipeSource source, MealType mealType, List<String> steps) {
        this.userId = userId;
        this.name = name;
        this.description = description;
        this.servingSize = servingSize;
        this.cookTimeMin = cookTimeMin;
        this.calories = calories;
        this.proteinG = proteinG;
        this.carbsG = carbsG;
        this.fatG = fatG;
        this.nutritionEstimated = nutritionEstimated;
        this.source = source;
        this.mealType = mealType;
        if (steps != null) {
            this.steps.addAll(steps);
        }
    }

    public void addIngredient(String ingredientName, BigDecimal requiredQty, String unit) {
        ingredients.add(new RecipeIngredient(this, ingredientName, requiredQty, unit));
    }
}
