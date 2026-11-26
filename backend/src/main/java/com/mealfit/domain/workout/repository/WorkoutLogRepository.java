package com.mealfit.domain.workout.repository;

import com.mealfit.domain.workout.entity.WorkoutLog;
import java.time.LocalDate;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

// [운동기록]
public interface WorkoutLogRepository extends JpaRepository<WorkoutLog, Long> {

    Optional<WorkoutLog> findByUserIdAndSessionId(Long userId, Long sessionId);

    /** 기간 안의 본인 운동 기록 목록 (세션 fetch join, 날짜순). */
    @Query("""
        select l from WorkoutLog l
        join fetch l.session s
        where l.userId = :userId
          and l.workoutDate between :from and :to
        order by l.workoutDate asc, l.id asc
        """)
    List<WorkoutLog> findByUserIdAndDateBetween(@Param("userId") Long userId,
                                                @Param("from") LocalDate from,
                                                @Param("to") LocalDate to);

    /** 주어진 세션 ID 목록 중 이미 운동 기록이 존재하는 세션 ID 집합 (루틴 재추천 시 보호용). */
    @Query("""
        select l.session.id from WorkoutLog l
        where l.userId = :userId and l.session.id in :sessionIds
        """)
    Set<Long> findLoggedSessionIds(@Param("userId") Long userId, @Param("sessionIds") Collection<Long> sessionIds);
}
