package com.mealfit.domain.intake.repository;

import com.mealfit.domain.intake.entity.IntakeLog;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IntakeLogRepository extends JpaRepository<IntakeLog, Long> {

    Optional<IntakeLog> findByMealPlanIdAndUserId(Long mealPlanId, Long userId);
}
