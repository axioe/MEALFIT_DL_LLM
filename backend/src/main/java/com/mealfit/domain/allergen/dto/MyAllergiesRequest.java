package com.mealfit.domain.allergen.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.Set;

/**
 * 내 알레르기 저장 요청. 목록에서 고른 항목은 코드로, 목록에 없는 알레르기는 직접 입력으로 받는다.
 * 프로필 알레르기와 같은 한도(최대 50개, 항목당 100자)를 따른다.
 */
public record MyAllergiesRequest(
        @NotNull @Size(max = 50) Set<@NotBlank @Size(max = 30) String> codes,
        @NotNull @Size(max = 50) Set<@NotBlank @Size(max = 100) String> custom
) {
}
