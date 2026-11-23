package com.mealfit.domain.workout.model;

import java.util.Arrays;
import java.util.Optional;

/** 부상·부담 부위. 화면 선택지(INJURY_AREA_OPTIONS) 7개와 같다 (D18 ②). */
public enum BodyArea {
    LOWER_BACK("허리"),
    KNEE("무릎"),
    SHOULDER("어깨"),
    NECK("목"),
    WRIST("손목"),
    ANKLE("발목"),
    HIP("고관절");

    private final String label;

    BodyArea(String label) {
        this.label = label;
    }

    public String label() {
        return label;
    }

    /** 한국어 라벨 또는 코드를 부위로 바꾼다. 모르는 값이면 empty. */
    public static Optional<BodyArea> fromInput(String value) {
        if (value == null) {
            return Optional.empty();
        }
        String normalized = value.trim();
        return Arrays.stream(values())
            .filter(area -> area.label.equals(normalized) || area.name().equalsIgnoreCase(normalized))
            .findFirst();
    }
}
