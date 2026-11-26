package com.mealfit.domain.workout.service;

import com.mealfit.domain.workout.entity.WorkoutLog;
import com.mealfit.domain.workout.entity.WorkoutLogStatus;
import com.mealfit.domain.workout.repository.WorkoutLogRepository;
import java.time.LocalDate;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * 최근 14일 운동 수행 기록 요약을 루틴 생성기에 제공한다 (FR-WORK-03, 설계 D4).
 * 기록이 2건 이상이고 건너뜀 비율이 50% 이상이면 WorkoutConditions.intensityCap()이 강도 상한을 1단계 낮춘다.
 */
// [운동기록]
@Component
@RequiredArgsConstructor
public class RecentWorkoutSummaryProviderImpl implements RecentWorkoutSummaryProvider {

    private final WorkoutLogRepository logRepository;

    @Override
    @Transactional(readOnly = true)
    public Summary summarize(Long userId, LocalDate today) {
        LocalDate from = today.minusDays(14);
        List<WorkoutLog> logs = logRepository.findByUserIdAndDateBetween(userId, from, today);
        if (logs.isEmpty()) {
            return Summary.EMPTY;
        }
        int skipped = (int) logs.stream()
            .filter(log -> log.getStatus() == WorkoutLogStatus.SKIPPED)
            .count();
        return new Summary(logs.size(), skipped);
    }
}
