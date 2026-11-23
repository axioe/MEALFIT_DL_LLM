package com.mealfit.domain.workout.model;

/** 세션 안의 운동 한 개와 분량. reps 또는 seconds 중 하나만 쓴다. */
public record PlannedItem(
    Phase phase,
    String code,
    String name,
    int sets,
    Integer reps,
    Integer seconds,
    int restSeconds
) {
}
