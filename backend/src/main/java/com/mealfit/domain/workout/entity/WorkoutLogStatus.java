package com.mealfit.domain.workout.entity;

/**
 * 운동 세션 수행 상태 (FR-WORK-03, BR-18).
 * 같은 세션에 대해 COMPLETED ↔ PARTIAL ↔ SKIPPED 정정을 허용한다.
 */
// [운동기록]
public enum WorkoutLogStatus {
    COMPLETED,
    PARTIAL,
    SKIPPED
}
