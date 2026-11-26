package com.mealfit.domain.workout.dto;

import com.mealfit.domain.workout.entity.WorkoutLogStatus;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/** 주간 운동 현황 집계 응답 (FR-WORK-04, DOM-05). */
// [운동기록]
public record WorkoutWeeklySummaryResponse(
    LocalDate weekStart,
    LocalDate weekEnd,
    int plannedSessions,
    int completedCount,
    int partialCount,
    int skippedCount,
    int pendingCount,
    int totalPlannedMinutes,
    int totalActualMinutes,
    int completionRate,
    List<SessionSummaryItem> items
) {
    public record SessionSummaryItem(
        Long sessionId,
        LocalDate workoutDate,
        String focusArea,
        String title,
        int plannedMinutes,
        boolean adjusted,
        WorkoutLogStatus status,
        int actualMinutes,
        BigDecimal weightKg
    ) {
    }
}
