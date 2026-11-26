package com.mealfit.domain.workout.repository;

import com.mealfit.domain.workout.entity.WorkoutSession;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface WorkoutSessionRepository extends JpaRepository<WorkoutSession, Long> {

    /** 기간 안의 활성 세션 (날짜 순). */
    @Query("""
        select s from WorkoutSession s
        where s.userId = :userId and s.activeKey is not null
          and s.sessionDate between :from and :to
        order by s.sessionDate
        """)
    List<WorkoutSession> findActiveBetween(@Param("userId") Long userId, @Param("from") LocalDate from,
                                           @Param("to") LocalDate to);

    /** 이 날짜 이후의 활성 세션 (루틴을 다시 받을 때 교체 대상). */
    @Query("""
        select s from WorkoutSession s
        where s.userId = :userId and s.activeKey is not null and s.sessionDate >= :from
        """)
    List<WorkoutSession> findActiveFrom(@Param("userId") Long userId, @Param("from") LocalDate from);

    /**
     * 이 날짜에 위험 신호 차단 표시(adjust_note 접두어)가 남은 세션이 있는지. 교체된(비활성) 세션도 본다.
     * 루틴을 다시 받아도 당일 차단을 이어 가기 위해 쓴다.
     */
    boolean existsByUserIdAndSessionDateAndAdjustNoteStartingWith(Long userId, LocalDate sessionDate,
                                                                   String notePrefix);

    // [문장조정] 본인 소유의 특정 루틴·날짜 활성 세션 조회
    Optional<WorkoutSession> findByRoutineIdAndUserIdAndSessionDateAndActiveKeyIsNotNull(
        Long routineId, Long userId, LocalDate sessionDate
    );

    // [운동기록] 본인 소유 세션 단건 조회
    Optional<WorkoutSession> findByIdAndUserId(Long id, Long userId);
}
