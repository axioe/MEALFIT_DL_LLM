package com.mealfit.domain.workout.model;

import java.util.EnumSet;
import java.util.Set;

/**
 * 루틴 생성 입력 (설계 3장). 요청 값이 우선이고 없으면 프로필 값을 쓴다.
 * equipment에는 맨몸이 항상 포함된다. unknownInjury는 화면 7개 외의 부상 값이 있었는지 여부다.
 */
public record WorkoutConditions(
    Goal goal,
    Level level,
    int daysPerWeek,
    int sessionMinutes,
    Set<Equipment> equipment,
    Set<BodyArea> injuries,
    boolean unknownInjury,
    double recentSkipRatio,
    int recentLogCount
) {
    public static final Set<Integer> ALLOWED_MINUTES = Set.of(15, 30, 45, 60);

    public WorkoutConditions {
        EnumSet<Equipment> owned = EnumSet.of(Equipment.BODYWEIGHT);
        owned.addAll(equipment);
        equipment = Set.copyOf(owned);
        injuries = injuries.isEmpty() ? Set.of() : Set.copyOf(EnumSet.copyOf(injuries));
    }

    /**
     * 실제 적용할 강도 상한 (D18 ①).
     * 모르는 부상 값이 있으면 1로 고정한다. 최근 기록의 건너뜀이 많거나 부상 부위가 있으면 한 단계 낮춘다 (한 번만).
     */
    public int intensityCap() {
        if (unknownInjury) {
            return 1;
        }
        boolean skipHeavy = recentLogCount >= 2 && recentSkipRatio >= 0.5;
        boolean lower = skipHeavy || !injuries.isEmpty();
        return Math.max(1, level.intensityCap() - (lower ? 1 : 0));
    }

    public boolean owns(Equipment required) {
        return equipment.contains(required);
    }
}
