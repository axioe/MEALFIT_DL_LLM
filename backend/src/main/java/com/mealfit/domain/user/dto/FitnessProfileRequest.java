package com.mealfit.domain.user.dto;

import jakarta.validation.constraints.*;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mealfit.domain.user.dto.validation.WholeNumberDeserializer;
import java.math.BigDecimal;
import java.util.Set;

/** 운동 목표·장비 탭의 저장 요청입니다. 이 탭에 속한 값만 변경합니다. */
public record FitnessProfileRequest(
    @Pattern(regexp = "loss|hypertrophy|stamina|health") String workoutGoal,
    @Pattern(regexp = "starter|beginner|intermediate|advanced") String workoutLevel,
    // [운동조건설정] D1 합의 기준: 회당 운동 시간은 15/30/45/60분만 허용 (세부 검증은 ProfileDetailsService)
    @Min(15) @Max(60) @JsonDeserialize(using = WholeNumberDeserializer.class) Integer workoutMinutes,
    @Min(2) @Max(6) @JsonDeserialize(using = WholeNumberDeserializer.class) Integer daysPerWeek,
     @NotNull @Size(max = 50) Set<@NotBlank @Size(max = 100) @Pattern(regexp = "dumbbell|band|mat|pullup_bar|foam_roller|kettlebell|none|barbell|gym") String> equipment,
     @NotNull @Size(max = 50) Set<@NotBlank @Size(max = 100) String> injuries
) {
}
