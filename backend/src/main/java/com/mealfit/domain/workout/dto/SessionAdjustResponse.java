package com.mealfit.domain.workout.dto;

import com.mealfit.domain.workout.dto.RoutineResponse.DayResponse;
import java.util.List;

/**
 * 문장 키워드 해석 조정 응답 (FR-WORK-02, D18 ③-3).
 * startBlocked가 true이면 위험 신호로 인해 오늘 루틴의 운동 시작 버튼을 차단해야 한다.
 */
// [문장조정]
public record SessionAdjustResponse(
    Long routineId,
    boolean adjusted,
    boolean startBlocked,
    String riskLevel,
    String adjustNote,
    List<String> notices,
    DayResponse day
) {
}
