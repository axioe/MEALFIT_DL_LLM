package com.mealfit.domain.workout.repository;

import com.mealfit.domain.workout.entity.WorkoutSession;
import java.time.LocalDate;
import java.util.List;
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
}
