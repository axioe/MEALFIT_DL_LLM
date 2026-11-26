package com.mealfit.domain.workout.controller;

import com.mealfit.domain.workout.dto.WorkoutLogRequest;
import com.mealfit.domain.workout.dto.WorkoutLogResponse;
import com.mealfit.domain.workout.dto.WorkoutWeeklySummaryResponse;
import com.mealfit.domain.workout.service.WorkoutLogService;
import com.mealfit.global.web.CurrentUserId;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.time.LocalDate;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "WorkoutLog", description = "운동 완료 기록 저장·정정 및 주간 현황 집계 (FR-WORK-03·04)")
@RestController
@RequestMapping("/api/v1/workout-logs")
@RequiredArgsConstructor
// [운동기록]
public class WorkoutLogController {

    private final WorkoutLogService workoutLogService;

    @Operation(summary = "운동 세션 완료·일부·건너뜀 기록 저장 및 정정 (미래 날짜 400, 위험 차단 세션 완료 409)")
    @PostMapping
    public WorkoutLogResponse record(
        @CurrentUserId Long userId,
        @Valid @RequestBody WorkoutLogRequest request
    ) {
        return workoutLogService.record(userId, request);
    }

    @Operation(summary = "기간별 본인 운동 기록 목록 조회 (미지정 시 최근 14일)")
    @GetMapping
    public List<WorkoutLogResponse> getLogs(
        @CurrentUserId Long userId,
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to
    ) {
        return workoutLogService.getLogs(userId, from, to);
    }

    @Operation(summary = "조회한 주(월~일) 운동 현황 집계 (계획 세션 대비 완료·일부·건너뜀·실제 시간)")
    @GetMapping("/summary")
    public WorkoutWeeklySummaryResponse getWeeklySummary(
        @CurrentUserId Long userId,
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate week
    ) {
        return workoutLogService.getWeeklySummary(userId, week);
    }
}
