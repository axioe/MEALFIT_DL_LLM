package com.mealfit.domain.workout.model;

/** 운동 루틴 서버 검증(BR-17) 위반 종류 (설계 7장). */
public enum ViolationType {
    UNKNOWN_EXERCISE,
    EQUIPMENT_NOT_OWNED,
    INJURY_CONFLICT,
    INTENSITY_EXCEEDED,
    TIME_EXCEEDED,
    DOSAGE_OUT_OF_RANGE,
    EMPTY_MAIN
}
