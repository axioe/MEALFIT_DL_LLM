package com.mealfit.domain.workout.pose.dto;

import java.util.List;

/**
 * 운동 자세 판별 요청 (FR-WORK-05). 브라우저가 MediaPipe로 뽑은 관절 좌표만 보낸다 (영상·이미지 없음, NFR-SEC-05).
 * exercise: 자세 판별 운동명(AI 서비스 지원 목록 기준), fps: 5~30,
 * frames: 프레임마다 관절 33개의 [x, y, z, visibility]. 사람을 못 찾은 프레임은 null.
 * 검증은 PoseAnalysisService 에서 한다 (숫자 범위·길이·지원 운동).
 */
public record PoseAnalysisRequest(
        String exercise,
        Double fps,
        List<List<List<Double>>> frames
) {
}
