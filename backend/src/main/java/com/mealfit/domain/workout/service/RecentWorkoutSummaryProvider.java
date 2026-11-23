package com.mealfit.domain.workout.service;

import java.time.LocalDate;

/**
 * 최근 운동 기록 요약을 루틴 생성에 넘겨주는 연결부 (FR-WORK-03 "최근 수행 기록은 다음 루틴 생성의 입력").
 * 운동 기록(workout_logs) 담당자가 이 인터페이스를 구현한 빈을 등록한다.
 * 구현 빈이 없으면 기록이 없는 것으로 본다.
 */
public interface RecentWorkoutSummaryProvider {

    /** today 이전 14일 동안의 기록 수와 건너뜀 수. */
    Summary summarize(Long userId, LocalDate today);

    record Summary(int logCount, int skippedCount) {
        public static final Summary EMPTY = new Summary(0, 0);

        public double skipRatio() {
            return logCount == 0 ? 0.0 : (double) skippedCount / logCount;
        }
    }
}
