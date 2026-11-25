package com.mealfit.domain.workout.repository;

import com.mealfit.domain.workout.entity.RoutineStatus;
import com.mealfit.domain.workout.entity.WorkoutRoutine;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WorkoutRoutineRepository extends JpaRepository<WorkoutRoutine, Long> {

    List<WorkoutRoutine> findByUserIdAndStatus(Long userId, RoutineStatus status);

    Optional<WorkoutRoutine> findFirstByUserIdAndStatusOrderByIdDesc(Long userId, RoutineStatus status);

    // [문장조정] 본인 소유 루틴만 조회한다
    Optional<WorkoutRoutine> findByIdAndUserId(Long id, Long userId);
}
