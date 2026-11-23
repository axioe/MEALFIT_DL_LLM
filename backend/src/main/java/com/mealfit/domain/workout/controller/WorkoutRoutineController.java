package com.mealfit.domain.workout.controller;

import com.mealfit.domain.workout.dto.RoutineRecommendRequest;
import com.mealfit.domain.workout.dto.RoutineResponse;
import com.mealfit.domain.workout.service.WorkoutRoutineService;
import com.mealfit.global.web.CurrentUserId;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.time.LocalDate;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "WorkoutRoutine", description = "운동 루틴 생성·조회 (규칙 기반, AI 미사용)")
@RestController
@RequestMapping("/api/v1/workout-routines")
@RequiredArgsConstructor
public class WorkoutRoutineController {

    private final WorkoutRoutineService workoutRoutineService;

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
}
