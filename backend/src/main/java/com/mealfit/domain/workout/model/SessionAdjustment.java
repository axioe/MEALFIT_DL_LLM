package com.mealfit.domain.workout.model;

import java.util.EnumSet;
import java.util.Set;

/**
 * 문장 키워드 해석 결과 값 객체 (FR-WORK-02).
 * 사용자 원문은 보관하지 않고 해석된 키워드 요약(summaryNote)만 남긴다 (설계 5.2, D18 ③-3).
 */
// [문장조정]
public record SessionAdjustment(
    AdjustRiskLevel riskLevel,
    Integer sessionMinutes,
    // [문장조정] 15분 미만 시간 요청 시 15분으로 임의 증량하지 않기 위한 플래그
    boolean underMinMinutes,
    SessionFocus focus,
    IntensityIntent intensityIntent,
    Set<BodyArea> excludedAreas,
    boolean poorCondition,
    String summaryNote
) {
    /** 위험 신호로 오늘 운동 시작이 차단되었음을 adjust_note에 표시하는 접두어. */
    public static final String EMERGENCY_NOTE = "위험신호:운동중단";

    public SessionAdjustment {
        excludedAreas = excludedAreas == null || excludedAreas.isEmpty()
            ? Set.of()
            : Set.copyOf(EnumSet.copyOf(excludedAreas));
    }

    public boolean isEmergency() {
        return riskLevel == AdjustRiskLevel.EMERGENCY;
    }

    public boolean isMedical() {
        return riskLevel == AdjustRiskLevel.MEDICAL;
    }

    public boolean hasActionableChange() {
        return sessionMinutes != null
            || focus != null
            || intensityIntent != null
            || !excludedAreas.isEmpty()
            || poorCondition;
    }

    public static boolean isEmergencyNote(String adjustNote) {
        return adjustNote != null && adjustNote.startsWith(EMERGENCY_NOTE);
    }
}
