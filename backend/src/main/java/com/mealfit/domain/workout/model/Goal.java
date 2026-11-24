package com.mealfit.domain.workout.model;

import java.util.Arrays;
import java.util.Optional;

/** 운동 목표. 프로필 저장 값(loss·hypertrophy·stamina·health)과 1:1로 대응한다 (SDD 6.5 감량·근력·체력·유지). */
public enum Goal {
    FAT_LOSS("loss"),
    STRENGTH("hypertrophy"),
    ENDURANCE("stamina"),
    MAINTAIN("health");

    private final String profileValue;

    Goal(String profileValue) {
        this.profileValue = profileValue;
    }

    public String profileValue() {
        return profileValue;
    }

    public static Optional<Goal> fromProfileValue(String value) {
        if (value == null) {
            return Optional.empty();
        }
        String normalized = value.trim();
        return Arrays.stream(values())
            .filter(goal -> goal.profileValue.equals(normalized) || goal.name().equals(normalized))
            .findFirst();
    }
}
