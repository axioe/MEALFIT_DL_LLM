package com.mealfit.domain.allergen.dto;

import java.util.List;

/**
 * 레시피가 내 알레르기에 걸리는지와 그 이유 (MEALFIT-140 제외 안내).
 *
 * @param safe     걸리는 재료가 하나도 없으면 true
 * @param warnings 걸린 재료별 이유
 */
public record RecipeAllergenCheckResponse(Long recipeId, String recipeName, boolean safe, List<Warning> warnings) {

    /**
     * @param ingredientName 레시피 재료
     * @param allergen       알레르기 사전 항목 이름. 직접 입력과 이름이 겹친 경우는 입력한 글자
     * @param reason         CONTAINS(포함) / MAY_CONTAIN(확인 필요) / NAME_MATCH(이름 포함·가공품)
     * @param message        화면에 그대로 보여 줄 문장
     */
    public record Warning(String ingredientName, String allergen, Reason reason, String message) {
    }

    public enum Reason {
        CONTAINS, MAY_CONTAIN, NAME_MATCH
    }
}
