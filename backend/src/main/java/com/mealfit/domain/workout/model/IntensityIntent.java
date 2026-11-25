package com.mealfit.domain.workout.model;

/** 문장 키워드에서 해석한 강도 조절 의도 (FR-WORK-02). */
// [문장조정]
public enum IntensityIntent {
    LIGHTER("가볍게"),
    NORMAL("보통"),
    HARDER("강하게");

    private final String label;

    IntensityIntent(String label) {
        this.label = label;
    }

    public String label() {
        return label;
    }
}
