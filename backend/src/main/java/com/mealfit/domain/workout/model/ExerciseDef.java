package com.mealfit.domain.workout.model;

import java.util.Set;

/** 운동 사전(exercise_catalog) 한 행의 불변 스냅샷. 생성기·검증기는 DB 대신 이 값만 본다. */
public record ExerciseDef(
    String code,
    String name,
    Phase phase,
    FocusArea focusArea,
    Equipment equipment,
    int intensity,
    ExerciseUnit unit,
    int defaultSets,
    Integer defaultReps,
    Integer defaultSeconds,
    double secondsPerRep,
    int restSeconds,
    Set<BodyArea> loadAreas
) {
    public ExerciseDef {
        loadAreas = Set.copyOf(loadAreas);
    }

    public boolean isHigh() {
        return intensity >= 3;
    }
}
