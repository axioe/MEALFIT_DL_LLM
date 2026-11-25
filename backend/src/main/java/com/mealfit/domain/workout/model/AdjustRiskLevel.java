package com.mealfit.domain.workout.model;

/**
 * 문장 키워드 해석 결과의 안전 위험 등급 (FR-WORK-02, D18 ③-3).
 * 우선순위: EMERGENCY > MEDICAL > PAIN > NONE.
 */
// [문장조정]
public enum AdjustRiskLevel {
    NONE,
    PAIN,
    MEDICAL,
    EMERGENCY
}
