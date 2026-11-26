package com.mealfit.domain.intake.dto;

import com.mealfit.domain.intake.entity.IntakeLog;
import com.mealfit.domain.intake.entity.IntakeStatus;
import com.mealfit.domain.mealplan.entity.MealType;
import java.time.LocalDate;
import java.time.LocalDateTime;

/** 섭취 기록 응답 (FR-INT-01·02, DOM-06). */
// [섭취기록]
public record IntakeLogResponse(
    Long id,
    Long mealPlanId,
    LocalDate planDate,
    MealType mealType,
    IntakeStatus intakeStatus,
    LocalDateTime loggedAt
) {
    public static IntakeLogResponse from(IntakeLog log) {
        return new IntakeLogResponse(
            log.getId(),
            log.getMealPlan().getId(),
            log.getMealPlan().getPlanDate(),
            log.getMealPlan().getMealType(),
            log.getIntakeStatus(),
            log.getLoggedAt()
        );
    }
}
