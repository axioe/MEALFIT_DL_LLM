package com.mealfit.domain.workout.entity;

import com.mealfit.domain.workout.model.SessionAdjustment;
import com.mealfit.global.common.BaseTimeEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDate;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 하루 운동 세션 (설계 5.2). 운동 목록은 JSON 문자열(items)로 통째로 저장한다.
 * activeKey가 session_date면 활성, NULL이면 교체된 세션이다.
 */
@Getter
@Entity
@Table(name = "workout_sessions")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class WorkoutSession extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "routine_id", nullable = false)
    private Long routineId;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "session_date", nullable = false)
    private LocalDate sessionDate;

    @Column(name = "focus_area", nullable = false, length = 20)
    private String focusArea;

    @Column(nullable = false, length = 100)
    private String title;

    @Column(name = "planned_minutes", nullable = false)
    private int plannedMinutes;

    @Column(nullable = false, length = 4000)
    private String items;

    @Column(nullable = false, length = 20)
    private String source;

    @Column(nullable = false)
    private boolean adjusted;

    @Column(name = "adjust_note", length = 200)
    private String adjustNote;

    @Column(name = "active_key")
    private LocalDate activeKey;

    @Builder
    private WorkoutSession(Long routineId, Long userId, LocalDate sessionDate, String focusArea, String title,
                           int plannedMinutes, String items, String source) {
        this.routineId = routineId;
        this.userId = userId;
        this.sessionDate = sessionDate;
        this.focusArea = focusArea;
        this.title = title;
        this.plannedMinutes = plannedMinutes;
        this.items = items;
        this.source = source;
        this.adjusted = false;
        this.activeKey = sessionDate;
    }

    public void deactivate() {
        this.activeKey = null;
    }

    public boolean isActive() {
        return activeKey != null;
    }

    // [문장조정] 키워드 해석 결과로 세션을 갱신한다 (위험 신호로 차단된 당일 세션은 해제 불가)
    public void applyAdjustment(String focusArea, String title, int plannedMinutes,
                                String items, String source, String adjustNote) {
        if (isStartBlocked()) {
            throw new IllegalStateException("위험 신호로 차단된 세션은 조정할 수 없습니다.");
        }
        this.focusArea = focusArea;
        this.title = title;
        this.plannedMinutes = plannedMinutes;
        this.items = items;
        this.source = source;
        this.adjusted = true;
        this.adjustNote = adjustNote;
    }

    // [문장조정] 위험 신호 감지 시 세션을 바꾸지 않고 운동 시작 차단 표시만 기록한다
    public void blockByEmergency(String adjustNote) {
        this.adjustNote = adjustNote;
    }

    // [문장조정] 위험 신호로 오늘 운동 시작이 차단된 상태인지 반환한다
    public boolean isStartBlocked() {
        return SessionAdjustment.isEmergencyNote(this.adjustNote);
    }
}
