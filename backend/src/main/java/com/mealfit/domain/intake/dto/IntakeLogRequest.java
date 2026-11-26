package com.mealfit.domain.intake.dto;

import com.mealfit.domain.intake.entity.IntakeStatus;
import jakarta.validation.constraints.NotNull;

/** 섭취 기록(먹음·건너뜀) 저장·정정 요청 (FR-INT-01·02). */
// [섭취기록]
public record IntakeLogRequest(
    @NotNull(message = "식단 ID는 필수입니다.")
    Long mealPlanId,
    @NotNull(message = "섭취 상태는 필수입니다.")
    IntakeStatus intakeStatus
) {
}
