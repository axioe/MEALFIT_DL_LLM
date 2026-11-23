package com.mealfit.domain.workout.model;

import java.util.Map;

/** 운동 시간 추정 (설계 6.5). 생성기와 검증기가 같은 계산을 쓴다. */
public final class WorkoutTime {

    /** 운동과 운동 사이 전환 시간(초). */
    public static final int TRANSITION_SECONDS = 30;

    /** 운동 사전에 없는 코드(검증에서 걸러짐)에 쓰는 1회당 시간(초). */
    private static final double FALLBACK_SECONDS_PER_REP = 3.0;

    private WorkoutTime() {
    }

    public static int secondsOf(int sets, Integer reps, Integer seconds, double secondsPerRep, int restSeconds) {
        double work = reps != null ? reps * secondsPerRep : (seconds == null ? 0 : seconds);
        return (int) Math.ceil(sets * work) + Math.max(0, sets - 1) * restSeconds + TRANSITION_SECONDS;
    }

    public static int secondsOf(PlannedItem item, Map<String, ExerciseDef> catalog) {
        ExerciseDef def = catalog.get(item.code());
        double perRep = def == null ? FALLBACK_SECONDS_PER_REP : def.secondsPerRep();
        return secondsOf(item.sets(), item.reps(), item.seconds(), perRep, item.restSeconds());
    }

    public static int sessionSeconds(SessionPlan session, Map<String, ExerciseDef> catalog) {
        return session.items().stream().mapToInt(item -> secondsOf(item, catalog)).sum();
    }

    /** 화면에 보여 줄 분 (올림). */
    public static int sessionMinutes(SessionPlan session, Map<String, ExerciseDef> catalog) {
        return (sessionSeconds(session, catalog) + 59) / 60;
    }
}
