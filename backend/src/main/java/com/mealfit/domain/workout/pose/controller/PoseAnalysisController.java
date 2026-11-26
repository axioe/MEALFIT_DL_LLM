package com.mealfit.domain.workout.pose.controller;

import com.mealfit.domain.workout.pose.dto.PoseAnalysisRequest;
import com.mealfit.domain.workout.pose.dto.PoseAnalysisResponse;
import com.mealfit.domain.workout.pose.dto.PoseExerciseResponse;
import com.mealfit.domain.workout.pose.service.PoseAnalysisService;
import com.mealfit.global.web.CurrentUserId;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "WorkoutPose", description = "운동 자세 판별 (관절 좌표 → 반복별·조건별 판정, 결과는 참고용)")
@RestController
@RequestMapping("/api/v1/workout")
@RequiredArgsConstructor
public class PoseAnalysisController {

    private final PoseAnalysisService poseAnalysisService;

    // 로그인 확인용으로만 받는다. 사용자 ID는 AI 서비스로 보내지 않고 저장하지도 않는다
    @Operation(summary = "운동 자세 판별 (브라우저에서 뽑은 관절 좌표만 받음, 영상·좌표 저장 없음)")
    @PostMapping("/pose-analyses")
    public PoseAnalysisResponse analyze(@CurrentUserId Long userId, @RequestBody PoseAnalysisRequest request) {
        return poseAnalysisService.analyze(request);
    }

    @Operation(summary = "자세 판별 지원 운동 목록 (운동명·조건 이름)")
    @GetMapping("/pose-exercises")
    public PoseExerciseResponse exercises(@CurrentUserId Long userId) {
        return poseAnalysisService.exercises();
    }
}
