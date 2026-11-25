package com.mealfit.domain.workout.controller;

import com.mealfit.domain.workout.dto.RoutineRecommendRequest;
import com.mealfit.domain.workout.dto.RoutineResponse;
import com.mealfit.domain.workout.dto.SessionAdjustRequest;
import com.mealfit.domain.workout.dto.SessionAdjustResponse;
import com.mealfit.domain.workout.service.WorkoutRoutineService;
import com.mealfit.domain.workout.service.WorkoutSessionAdjustService;
import com.mealfit.global.web.CurrentUserId;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.time.LocalDate;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "WorkoutRoutine", description = "운동 루틴 생성·조회·문장 조정 (규칙 기반, AI 미사용)")
@RestController
@RequestMapping("/api/v1/workout-routines")
@RequiredArgsConstructor
public class WorkoutRoutineController {

    private final WorkoutRoutineService workoutRoutineService;
    private final WorkoutSessionAdjustService workoutSessionAdjustService;

    @Operation(summary = "맞춤 운동 루틴 생성 (요청 값이 없으면 프로필 운동 조건 사용, 서버 검증 후 저장, 이번 주 7일 반환)")
    @PostMapping("/recommend")
    @ResponseStatus(HttpStatus.CREATED)
    public RoutineResponse recommend(@CurrentUserId Long userId,
                                     @Valid @RequestBody(required = false) RoutineRecommendRequest request) {
        return workoutRoutineService.recommend(userId, request);
    }

    @Operation(summary = "이번 주(또는 week가 속한 주) 운동 루틴 조회. 루틴이 없으면 routineId가 null")
    @GetMapping("/current")
    public RoutineResponse current(@CurrentUserId Long userId,
                                   @RequestParam(required = false)
                                   @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate week) {
        return workoutRoutineService.current(userId, week);
    }

    // [문장조정] 자연어 문장 키워드 해석 기반 하루 운동 세션 조정 (FR-WORK-02)
    @Operation(summary = "문장 키워드 해석으로 해당 날짜 운동 세션 조정 (위험 신호 시 운동 시작 차단)")
    @PatchMapping("/{routineId}/sessions/{sessionDate}")
    public SessionAdjustResponse adjustSession(
        @CurrentUserId Long userId,
        @PathVariable Long routineId,
        @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate sessionDate,
        @Valid @RequestBody SessionAdjustRequest request
    ) {
        return workoutSessionAdjustService.adjust(userId, routineId, sessionDate, request);
    }
}
