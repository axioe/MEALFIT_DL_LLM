package com.mealfit.domain.recipe.entity;

/**
 * 검수 레시피(V15)의 끼니 구분.
 * 식단의 MealType(아침·점심·저녁)과 따로 둔다. MealType에 값을 더하면 하루 끼니 수가 바뀌기 때문이다.
 */
public enum RecipeMealSlot {
    /** 아침에 맞는 요리 (토스트·오트죽·간장 달걀밥 등) */
    BREAKFAST,
    /** 점심·저녁 공용 */
    LUNCH_DINNER
}
