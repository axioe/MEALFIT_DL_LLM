package com.mealfit.domain.workout.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;
import java.util.List;

/**
 * 운동 루틴 생성 요청 (설계 8.1). 모든 필드는 선택이며, 없으면 프로필의 운동 조건을 쓴다.
 * goal: loss·hypertrophy·stamina·health, sessionMinutes: 15·30·45·60,
 * equipment: 프로필 장비 값, injuries: 화면 부위 라벨(허리·무릎…), startDate: 없으면 오늘.
 * 요청 값을 프로필에 저장하지는 않는다 (프로필 저장은 FR-PROF-05).
 */
public record RoutineRecommendRequest(
    String goal,
    String level,
    @Min(2) @Max(6) Integer daysPerWeek,
    Integer sessionMinutes,
    @Size(max = 20) List<String> equipment,
    @Size(max = 20) List<String> injuries,
    LocalDate startDate
) {
    public static RoutineRecommendRequest empty() {
        return new RoutineRecommendRequest(null, null, null, null, null, null, null);
    }
}
