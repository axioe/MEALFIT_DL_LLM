package com.mealfit.domain.workout.model;

import java.util.EnumSet;
import java.util.Optional;
import java.util.Set;

/**
 * 운동 사전의 필요 장비. 맨몸(BODYWEIGHT)은 누구나 보유한 것으로 본다.
 * 프로필 값 gym은 아래 장비를 모두 보유한 것으로 해석한다 (설계 결정 D2 제안).
 */
public enum Equipment {
    BODYWEIGHT, MAT, DUMBBELL, BAND, PULLUP_BAR, FOAM_ROLLER, KETTLEBELL, BARBELL;

    private static final Set<Equipment> GYM = EnumSet.of(MAT, DUMBBELL, BAND, PULLUP_BAR,
        FOAM_ROLLER, KETTLEBELL, BARBELL);

    /** 프로필·요청 값(dumbbell, pullup_bar, none, gym …)을 장비 집합으로 바꾼다. 모르는 값이면 empty. */
    public static Optional<Set<Equipment>> fromProfileValue(String value) {
        if (value == null) {
            return Optional.empty();
        }
        return switch (value.trim().toLowerCase()) {
            case "none", "bodyweight" -> Optional.of(EnumSet.noneOf(Equipment.class));
            case "gym" -> Optional.of(EnumSet.copyOf(GYM));
            case "dumbbell" -> Optional.of(EnumSet.of(DUMBBELL));
            case "band" -> Optional.of(EnumSet.of(BAND));
            case "mat" -> Optional.of(EnumSet.of(MAT));
            case "pullup_bar" -> Optional.of(EnumSet.of(PULLUP_BAR));
            case "foam_roller" -> Optional.of(EnumSet.of(FOAM_ROLLER));
            case "kettlebell" -> Optional.of(EnumSet.of(KETTLEBELL));
            case "barbell" -> Optional.of(EnumSet.of(BARBELL));
            default -> Optional.empty();
        };
    }
}
