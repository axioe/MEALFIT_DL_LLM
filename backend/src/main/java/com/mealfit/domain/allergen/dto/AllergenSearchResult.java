package com.mealfit.domain.allergen.dto;

import com.mealfit.domain.allergen.entity.AllergenCertainty;

/**
 * 알레르기 검색 결과 한 건.
 *
 * @param matchedBy   NAME(이름) / ALIAS(별칭) / INGREDIENT(재료 이름, 예: 참기름 → 참깨)
 * @param matchedText 실제로 맞은 이름·별칭·재료
 * @param certainty   INGREDIENT로 맞았을 때만: 그 재료가 포함하는 정도
 */
public record AllergenSearchResult(String code, String name, String category, MatchType matchedBy,
                                   String matchedText, AllergenCertainty certainty) {

    public enum MatchType {
        NAME, ALIAS, INGREDIENT
    }
}
