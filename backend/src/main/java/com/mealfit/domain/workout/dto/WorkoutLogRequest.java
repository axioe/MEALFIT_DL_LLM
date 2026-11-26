package com.mealfit.domain.workout.dto;

import com.mealfit.domain.workout.entity.WorkoutLogStatus;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

/** 운동 완료·일부·건너뜀 기록 요청 (FR-WORK-03, BR-18). 중량 단위는 kg. */
// [운동기록]
public record WorkoutLogRequest(
    @NotNull(message = "운동 세션 ID는 필수입니다.")
    Long sessionId,
    @NotNull(message = "운동 수행 상태는 필수입니다.")
    WorkoutLogStatus status,
    Integer actualMinutes,
    @DecimalMin(value = "0.00", message = "중량은 0kg 이상이어야 합니다.")
    @DecimalMax(value = "9999.99", message = "중량은 9999.99kg 이하로 입력해 주세요.")
    @Digits(integer = 4, fraction = 2, message = "중량은 소수 둘째 자리까지 입력할 수 있습니다.")
    BigDecimal weightKg
) {
}
