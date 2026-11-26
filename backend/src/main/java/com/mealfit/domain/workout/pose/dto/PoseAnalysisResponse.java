package com.mealfit.domain.workout.pose.dto;

import java.util.List;

/**
 * 운동 자세 판별 결과 (AI 서비스 응답을 검증해 그대로 전달). 모든 판정은 참고용이다 (D20, 판단 보류 없음).
 * status: OK(판정) / RETAKE(사람 미검출·프레임 부족 → retakeCode 로 재촬영 안내)
 */
public record PoseAnalysisResponse(
        String exercise,
        String status,
        String retakeCode,
        String modelVersion,
        int repCount,
        List<Rep> reps,
        List<ConditionSummary> conditions,
        String notice
) {
    /** 반복 1회의 구간(프레임 번호)과 조건별 판정 */
    public record Rep(int index, int startFrame, int endFrame, List<ConditionResult> conditions) { }

    /** 조건별 '올바름' 확률(0~1)과 판정 */
    public record ConditionResult(String name, double probability, boolean correct) { }

    /** 조건별 요약: 올바른 반복 수, 모델 정확도(외부 평가 EXTERNAL 또는 교차검증 CV, 없으면 null), 피드백 문구 */
    public record ConditionSummary(String name, int correctReps, int totalReps, Double accuracy,
                                   String accuracyBasis, String feedback) { }
}
