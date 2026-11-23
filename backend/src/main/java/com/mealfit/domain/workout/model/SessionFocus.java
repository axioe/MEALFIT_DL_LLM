package com.mealfit.domain.workout.model;

import java.util.List;

/** 하루 세션의 중심 부위와, 본 운동 칸을 채우는 순서 (설계 6.2). */
public enum SessionFocus {
    FULL_BODY("전신", List.of(FocusArea.LOWER, FocusArea.UPPER_PUSH, FocusArea.UPPER_PULL, FocusArea.CORE)),
    UPPER("상체", List.of(FocusArea.UPPER_PUSH, FocusArea.UPPER_PULL, FocusArea.UPPER_PUSH, FocusArea.UPPER_PULL,
        FocusArea.CORE)),
    LOWER("하체", List.of(FocusArea.LOWER, FocusArea.LOWER, FocusArea.CORE)),
    CORE_CARDIO("유산소·코어", List.of(FocusArea.CARDIO, FocusArea.CORE, FocusArea.FULL, FocusArea.CORE)),
    /** 조건에 맞는 조합이 없을 때 쓰는 검증된 기본 세션 (D18 ④). */
    DEFAULT("기본 루틴", List.of(FocusArea.FULL)),
    /** 기본 세션도 부상 때문에 본 운동이 2개 미만일 때 쓰는 회복 세션 (D18 ④). */
    RECOVERY("회복", List.of(FocusArea.MOBILITY));

    private final String label;
    private final List<FocusArea> slotCycle;

    SessionFocus(String label, List<FocusArea> slotCycle) {
        this.label = label;
        this.slotCycle = slotCycle;
    }

    public String label() {
        return label;
    }

    /** 본 운동 i번째 칸의 부위. 칸 순서를 반복해서 쓴다. */
    public FocusArea slot(int index) {
        return slotCycle.get(index % slotCycle.size());
    }
}
