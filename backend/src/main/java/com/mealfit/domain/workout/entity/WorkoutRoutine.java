package com.mealfit.domain.workout.entity;

import com.mealfit.global.common.BaseTimeEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDate;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/** 운동 루틴. 생성 당시 조건을 스냅샷으로 남긴다 (설계 5.1). */
@Getter
@Entity
@Table(name = "workout_routines")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class WorkoutRoutine extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(nullable = false, length = 20)
    private String goal;

    @Column(nullable = false, length = 20)
    private String level;

    @Column(name = "days_per_week", nullable = false)
    private int daysPerWeek;

    @Column(name = "session_minutes", nullable = false)
    private int sessionMinutes;

    @Column(name = "equipment_snapshot", nullable = false, length = 500)
    private String equipmentSnapshot;

    @Column(name = "injuries_snapshot", nullable = false, length = 500)
    private String injuriesSnapshot;

    @Column(name = "unknown_injury", nullable = false)
    private boolean unknownInjury;

    @Column(name = "intensity_cap", nullable = false)
    private int intensityCap;

    @Column(nullable = false, length = 20)
    private String source;

    @Column(name = "rule_version", nullable = false, length = 20)
    private String ruleVersion;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private RoutineStatus status;

    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @Column(name = "planned_until", nullable = false)
    private LocalDate plannedUntil;

    @Builder
    private WorkoutRoutine(Long userId, String goal, String level, int daysPerWeek, int sessionMinutes,
                           String equipmentSnapshot, String injuriesSnapshot, boolean unknownInjury,
                           int intensityCap, String source, String ruleVersion, LocalDate startDate,
                           LocalDate plannedUntil) {
        this.userId = userId;
        this.goal = goal;
        this.level = level;
        this.daysPerWeek = daysPerWeek;
        this.sessionMinutes = sessionMinutes;
        this.equipmentSnapshot = equipmentSnapshot;
        this.injuriesSnapshot = injuriesSnapshot;
        this.unknownInjury = unknownInjury;
        this.intensityCap = intensityCap;
        this.source = source;
        this.ruleVersion = ruleVersion;
        this.status = RoutineStatus.ACTIVE;
        this.startDate = startDate;
        this.plannedUntil = plannedUntil;
    }

    public void replace() {
        this.status = RoutineStatus.REPLACED;
    }

    public boolean covers(LocalDate date) {
        return !date.isBefore(startDate) && !date.isAfter(plannedUntil);
    }
}
