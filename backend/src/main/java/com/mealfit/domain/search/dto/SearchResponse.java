package com.mealfit.domain.search.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.mealfit.domain.inventory.entity.ExpirationStatus;
import com.mealfit.domain.inventory.entity.StorageLocation;
import com.mealfit.domain.mealplan.entity.MealPlanStatus;
import com.mealfit.domain.mealplan.entity.MealType;
import com.mealfit.domain.recipe.entity.RecipeSource;
import com.mealfit.domain.shopping.entity.ShoppingItemStatus;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * 통합 검색 결과. 요청하지 않은 대상은 null(응답에서 빠짐).
 *
 * @param query 정리된 검색어 (앞뒤 공백 제거·연속 공백 하나로)
 * @param terms 실제로 찾은 낱말 (별칭 확장 포함, 예: 계란 → 계란·달걀)
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public record SearchResponse(
        String query,
        List<String> terms,
        Group<RecipeHit> recipes,
        Group<InventoryHit> inventory,
        Group<MealPlanHit> mealPlans,
        Group<ShoppingHit> shoppingItems,
        Group<ExerciseHit> exercises,
        Group<WorkoutHit> workouts
) {

    /** 대상별 결과: 전체 건수와 이번 페이지 항목 */
    public record Group<T>(long total, List<T> items) {
    }

    /**
     * @param matchedIngredients 검색어에 걸린 재료 (요리명으로만 걸리면 빈 목록)
     * @param restricted         내 알레르기·제외 재료가 들어 있으면 true (결과에서 빼지 않고 표시만)
     * @param restrictedIngredients 걸린 재료
     */
    public record RecipeHit(Long id, String name, int cookTimeMin, RecipeSource source, boolean mine,
                            List<String> matchedIngredients, boolean restricted, List<String> restrictedIngredients) {
    }

    public record InventoryHit(Long lotId, String ingredientName, BigDecimal quantity, String unit,
                               LocalDate expiryDate, ExpirationStatus expirationStatus, StorageLocation storageLocation) {
    }

    public record MealPlanHit(Long id, LocalDate planDate, MealType mealType, MealPlanStatus status,
                              Long recipeId, String recipeName) {
    }

    public record ShoppingHit(Long id, String ingredientName, BigDecimal requiredQty, BigDecimal purchasedQty,
                              String unit, ShoppingItemStatus status) {
    }

    public record ExerciseHit(String code, String name, String focusArea, String equipment, int intensity,
                              boolean poseSupported) {
    }

    public record WorkoutHit(Long sessionId, LocalDate sessionDate, String title, String focusArea, int plannedMinutes) {
    }
}
