package com.mealfit.domain.workout.entity;

import com.mealfit.global.common.BaseTimeEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 운동 세션 완료·일부·건너뜀 기록 (FR-WORK-03·04, BR-18).
 * 세션당 1건(user_id, session_id 유일)이며 상태·시간·중량(kg)을 정정할 수 있다.
 */
// [운동기록]
@Getter
@Entity
@Table(
    name = "workout_logs",
    uniqueConstraints = @UniqueConstraint(
        name = "uk_workout_logs_user_session",
        columnNames = {"user_id", "session_id"}
    )
)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class WorkoutLog extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "session_id", nullable = false)
    private WorkoutSession session;

    @Column(name = "workout_date", nullable = false)
    private LocalDate workoutDate;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private WorkoutLogStatus status;

    @Column(name = "actual_minutes", nullable = false)
    private int actualMinutes;

    @Column(name = "weight_kg", precision = 6, scale = 2)
    private BigDecimal weightKg;

    @Column(name = "logged_at", nullable = false)
    private LocalDateTime loggedAt;

    public static WorkoutLog create(Long userId, WorkoutSession session, WorkoutLogStatus status,
                                    int actualMinutes, BigDecimal weightKg, LocalDateTime loggedAt) {
        WorkoutLog log = new WorkoutLog();
        log.userId = userId;
        log.session = session;
        log.workoutDate = session.getSessionDate();
        log.status = status;
        log.actualMinutes = actualMinutes;
        log.weightKg = weightKg;
        log.loggedAt = loggedAt;
        return log;
    }

    public void update(WorkoutLogStatus status, int actualMinutes, BigDecimal weightKg, LocalDateTime loggedAt) {
        this.status = status;
        this.actualMinutes = actualMinutes;
        this.weightKg = weightKg;
        this.loggedAt = loggedAt;
    }
}
