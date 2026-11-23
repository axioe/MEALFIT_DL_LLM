package com.mealfit.domain.workout.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.LocalDate;
import java.util.List;

/**
 * 운동 루틴 응답 (설계 8.1). days는 조회한 주의 월요일부터 일요일까지 7일이다.
 * 필드 이름은 운동 화면(WorkoutPage)이 쓰는 이름(isRestDay·focusArea·durationMinutes·warmUp·exercises·coolDown)에 맞췄다.
 * 활성 루틴이 없으면 routineId가 null이고 각 날은 세션도 휴식일도 아니다 ("루틴 없음").
 */
public record RoutineResponse(
    Long routineId,
    String goal,
    String level,
    Integer daysPerWeek,
    Integer sessionMinutes,
    String source,
    String ruleVersion,
    LocalDate startDate,
    LocalDate plannedUntil,
    String disclaimer,
    List<String> notices,
    List<DayResponse> days
) {

    public record DayResponse(
        LocalDate date,
        String dayOfWeek,
        @JsonProperty("isRestDay") boolean restDay,
        Long sessionId,
        String focusArea,
        String title,
        Integer durationMinutes,
        String source,
        Boolean adjusted,
        List<ItemResponse> warmUp,
        List<ItemResponse> exercises,
        List<ItemResponse> coolDown
    ) {
    }

    public record ItemResponse(
        String code,
        String name,
        int sets,
        Integer reps,
        Integer seconds,
        int restSeconds
    ) {
    }
}
