package com.mealfit.domain.intake.repository;

import com.mealfit.domain.intake.entity.IntakeLog;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface IntakeLogRepository extends JpaRepository<IntakeLog, Long> {

    Optional<IntakeLog> findByMealPlanIdAndUserId(Long mealPlanId, Long userId);

    // [섭취기록] 본인 소유·특정 날짜 식단의 섭취 기록 목록을 N+1 없이 조회한다
    @Query("""
        select log from IntakeLog log
        join fetch log.mealPlan mp
        where log.userId = :userId and mp.planDate = :planDate
        order by mp.id asc
        """)
    List<IntakeLog> findByUserIdAndPlanDate(@Param("userId") Long userId, @Param("planDate") LocalDate planDate);
}
