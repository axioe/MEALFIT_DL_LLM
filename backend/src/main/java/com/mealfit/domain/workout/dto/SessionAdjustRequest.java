package com.mealfit.domain.workout.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/** 문장 키워드 해석 기반 오늘 운동 세션 조정 요청 (FR-WORK-02). */
// [문장조정]
public record SessionAdjustRequest(
    @NotBlank(message = "조정 요청 문장을 입력해 주세요.")
    @Size(max = 200, message = "조정 요청 문장은 200자 이하로 입력해 주세요.")
    String prompt
) {
}
