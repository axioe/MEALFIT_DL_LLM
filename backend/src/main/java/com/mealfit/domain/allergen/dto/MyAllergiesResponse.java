package com.mealfit.domain.allergen.dto;

import java.util.List;

/**
 * 내 알레르기: 목록에서 고른 항목과 직접 입력한 항목.
 *
 * @param selected 알레르기 사전에 있는 항목 (표시 순서대로)
 * @param custom   사전에 없는 직접 입력 (고시 외). 기존처럼 이름 포함 검사로 차단한다
 */
public record MyAllergiesResponse(List<Selected> selected, List<String> custom) {

    public record Selected(String code, String name, String category) {
    }
}
