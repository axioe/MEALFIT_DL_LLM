package com.mealfit.domain.workout.entity;

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
}
