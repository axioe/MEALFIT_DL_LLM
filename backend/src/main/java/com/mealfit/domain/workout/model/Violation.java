package com.mealfit.domain.workout.model;

/** 검증 위반 한 건. 로그에는 운동 코드와 위반 종류만 남긴다 (건강 정보 제외). */
public record Violation(ViolationType type, String exerciseCode) {
}
