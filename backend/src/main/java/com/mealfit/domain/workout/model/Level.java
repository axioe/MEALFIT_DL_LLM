package com.mealfit.domain.workout.model;

import java.util.Arrays;
import java.util.Optional;

/**
 * 운동 수준과 수준별 안전 상한 (D18 ① 초안).
 * intensityCap: 운동 강도 상한, maxSets: 운동당 최대 세트,
 * highPerSession: 한 세션의 HIGH 운동 수, highSessionsPerWeek: 주당 HIGH 세션 수.
 */
public enum Level {
    STARTER("starter", 1, 2, 0, 0, -1),
    BEGINNER("beginner", 2, 3, 0, 0, 0),
    INTERMEDIATE("intermediate", 3, 4, 2, 2, 0),
    ADVANCED("advanced", 3, 5, 3, 3, 1);

    private final String profileValue;
    private final int intensityCap;
    private final int maxSets;
    private final int highPerSession;
    private final int highSessionsPerWeek;
    private final int setAdjustment;

    Level(String profileValue, int intensityCap, int maxSets, int highPerSession,
          int highSessionsPerWeek, int setAdjustment) {
        this.profileValue = profileValue;
        this.intensityCap = intensityCap;
        this.maxSets = maxSets;
        this.highPerSession = highPerSession;
        this.highSessionsPerWeek = highSessionsPerWeek;
        this.setAdjustment = setAdjustment;
    }

    public String profileValue() { return profileValue; }
    public int intensityCap() { return intensityCap; }
    public int maxSets() { return maxSets; }
    public int highPerSession() { return highPerSession; }
    public int highSessionsPerWeek() { return highSessionsPerWeek; }
    public int setAdjustment() { return setAdjustment; }

    /** 값이 없거나 모르는 값이면 초급으로 본다 (D18 ①). */
    public static Level fromProfileValue(String value) {
        if (value == null) {
            return BEGINNER;
        }
        String normalized = value.trim();
        Optional<Level> level = Arrays.stream(values())
            .filter(l -> l.profileValue.equals(normalized) || l.name().equals(normalized))
            .findFirst();
        return level.orElse(BEGINNER);
    }
}
