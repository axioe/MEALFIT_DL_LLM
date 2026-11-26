package com.mealfit.domain.intake.controller;

import com.mealfit.domain.intake.dto.IntakeLogRequest;
import com.mealfit.domain.intake.dto.IntakeLogResponse;
import com.mealfit.domain.intake.service.IntakeLogService;
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

@Tag(name = "IntakeLog", description = "식단 섭취 기록 (먹음·건너뜀 저장/정정 및 날짜별 조회)")
@RestController
@RequestMapping("/api/v1/intake-logs")
@RequiredArgsConstructor
// [섭취기록]
public class IntakeLogController {

    private final IntakeLogService intakeLogService;

    @Operation(summary = "확정 식단의 섭취 상태(EATEN/SKIPPED) 기록 및 정정 (PLANNED 복귀·미래 날짜·미확정 식단 불가)")
    @PostMapping
    public IntakeLogResponse record(
        @CurrentUserId Long userId,
        @Valid @RequestBody IntakeLogRequest request
    ) {
        return intakeLogService.record(userId, request);
    }

    @Operation(summary = "조회 날짜(미지정 시 오늘)의 본인 섭취 기록 목록 조회")
    @GetMapping
    public List<IntakeLogResponse> getByDate(
        @CurrentUserId Long userId,
        @RequestParam(required = false)
        @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date
    ) {
        return intakeLogService.getByDate(userId, date);
    }
}
