package com.mealfit.domain.workout.dto;

import com.mealfit.domain.workout.entity.WorkoutLog;
import com.mealfit.domain.workout.entity.WorkoutLogStatus;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/** 운동 기록 단건 응답 (FR-WORK-03). */
// [운동기록]
public record WorkoutLogResponse(
    Long id,
    Long sessionId,
    Long routineId,
    LocalDate workoutDate,
    String focusArea,
    String title,
    int plannedMinutes,
    WorkoutLogStatus status,
    int actualMinutes,
    BigDecimal weightKg,
    LocalDateTime loggedAt
) {
    public static WorkoutLogResponse from(WorkoutLog log) {
        return new WorkoutLogResponse(
            log.getId(),
            log.getSession().getId(),
            log.getSession().getRoutineId(),
            log.getWorkoutDate(),
            log.getSession().getFocusArea(),
            log.getSession().getTitle(),
            log.getSession().getPlannedMinutes(),
            log.getStatus(),
            log.getActualMinutes(),
            log.getWeightKg(),
            log.getLoggedAt()
        );
    }
}
