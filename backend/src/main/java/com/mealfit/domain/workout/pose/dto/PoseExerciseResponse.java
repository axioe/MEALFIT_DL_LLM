package com.mealfit.domain.workout.pose.dto;

import java.util.List;

/** 자세 판별 지원 운동 목록 (AI 서비스 모델 manifest 기준). 화면의 운동 선택 목록에 쓴다. */
public record PoseExerciseResponse(String modelVersion, List<Exercise> exercises) {

    /** 운동명과 판정하는 자세 조건 이름 */
    public record Exercise(String name, List<String> conditions) { }
}
