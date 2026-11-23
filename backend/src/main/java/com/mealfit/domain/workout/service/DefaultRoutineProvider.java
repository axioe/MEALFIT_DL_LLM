package com.mealfit.domain.workout.service;

import com.mealfit.domain.workout.model.ExerciseDef;
import com.mealfit.domain.workout.model.ExerciseUnit;
import com.mealfit.domain.workout.model.Phase;
import com.mealfit.domain.workout.model.PlannedItem;
import com.mealfit.domain.workout.model.SessionFocus;
import com.mealfit.domain.workout.model.SessionPlan;
import com.mealfit.domain.workout.model.WorkoutConditions;
import com.mealfit.domain.workout.model.WorkoutTime;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.springframework.stereotype.Component;

/**
 * 조건을 만족하는 조합이 없을 때 쓰는 기본 세션 (D18 ④, BR-17).
 * 모두 맨몸·강도 1이며, 부상 부위에 걸리는 운동은 여기서도 뺀다.
 * 빼고 나서 본 운동이 2개 미만이면 회복 세션으로 바꾼다.
 */
@Component
public class DefaultRoutineProvider {

    static final List<String> MAIN = List.of("MARCH_BRISK", "GLUTE_BRIDGE", "WALL_PUSHUP", "BIRD_DOG",
        "DEAD_BUG", "CHAIR_SQUAT");
    static final List<String> WARM_UP = List.of("DEEP_BREATHING", "ARM_CIRCLE", "HIP_CIRCLE", "WRIST_ANKLE_ROLL",
        "NECK_ROLL");
    static final List<String> COOL_DOWN = List.of("BREATHING_RELAX", "HAMSTRING_STRETCH", "CHEST_STRETCH",
        "CALF_STRETCH", "SUPINE_TWIST");
    static final String RECOVERY_MAIN = "BREATHING_RELAX";

    private static final int DEFAULT_SETS = 2;
    private static final int MAX_DEFAULT_SETS = 3;
    private static final int DEFAULT_REST = 30;

    public SessionPlan build(WorkoutConditions conditions, Map<String, ExerciseDef> catalog, LocalDate date) {
        int minutes = conditions.sessionMinutes();
        int[] budget = SessionComposer.phaseBudgetSeconds(minutes);
        int maxSets = Math.min(MAX_DEFAULT_SETS, conditions.level().maxSets());
        int sets = Math.min(DEFAULT_SETS, maxSets);

        List<ExerciseDef> main = usable(MAIN, conditions, catalog);
        List<PlannedItem> mainItems = fillMain(main, sets, maxSets, budget[1]);
        List<PlannedItem> items = new ArrayList<>(simple(WARM_UP, Phase.WARM_UP, conditions, catalog, budget[0]));

        if (mainItems.size() >= 2) {
            items.addAll(mainItems);
            items.addAll(simple(COOL_DOWN, Phase.COOL_DOWN, conditions, catalog, budget[2]));
            return new SessionPlan(date, SessionFocus.DEFAULT, "기본 루틴 " + minutes + "분", items,
                SessionPlan.SOURCE_DEFAULT, 1);
        }

        // 회복 세션: 누워서 호흡 이완을 본 운동으로 쓰고, 정리 스트레칭을 붙인다.
        ExerciseDef relax = catalog.get(RECOVERY_MAIN);
        int relaxSeconds = Math.min(MAX_RECOVERY_SECONDS, budget[1] - WorkoutTime.TRANSITION_SECONDS);
        items.add(new PlannedItem(Phase.MAIN, relax.code(), relax.name(), 1, null, relaxSeconds, 0));
        items.addAll(simple(COOL_DOWN.subList(1, COOL_DOWN.size()), Phase.COOL_DOWN, conditions, catalog,
            budget[2]));
        return new SessionPlan(date, SessionFocus.RECOVERY, "회복 세션 " + minutes + "분", items,
            SessionPlan.SOURCE_DEFAULT, 1);
    }

    private static final int MAX_RECOVERY_SECONDS = 600;

    private static List<ExerciseDef> usable(List<String> codes, WorkoutConditions conditions,
                                            Map<String, ExerciseDef> catalog) {
        return codes.stream()
            .map(catalog::get)
            .filter(Objects::nonNull)
            .filter(def -> SessionComposer.allowed(def, conditions, 1))
            .toList();
    }

    private static List<PlannedItem> fillMain(List<ExerciseDef> defs, int sets, int maxSets, int budget) {
        List<PlannedItem> items = new ArrayList<>();
        int used = 0;
        for (ExerciseDef def : defs) {
            PlannedItem item = mainItem(def, sets);
            int time = WorkoutTime.secondsOf(item.sets(), item.reps(), item.seconds(), def.secondsPerRep(),
                item.restSeconds());
            if (used + time > budget) {
                continue;
            }
            items.add(item);
            used += time;
        }
        // 시간이 남으면 세트를 하나씩 늘린다 (최대 3세트, 수준별 상한 이하).
        boolean grown = true;
        while (grown) {
            grown = false;
            for (int i = 0; i < items.size(); i++) {
                PlannedItem item = items.get(i);
                ExerciseDef def = defs.stream().filter(d -> d.code().equals(item.code())).findFirst().orElseThrow();
                if (item.sets() >= maxSets) {
                    continue;
                }
                int before = WorkoutTime.secondsOf(item.sets(), item.reps(), item.seconds(), def.secondsPerRep(),
                    item.restSeconds());
                PlannedItem bigger = mainItem(def, item.sets() + 1);
                int after = WorkoutTime.secondsOf(bigger.sets(), bigger.reps(), bigger.seconds(),
                    def.secondsPerRep(), bigger.restSeconds());
                if (used - before + after <= budget) {
                    items.set(i, bigger);
                    used += after - before;
                    grown = true;
                }
            }
        }
        return items;
    }

    private static PlannedItem mainItem(ExerciseDef def, int sets) {
        Integer reps = def.unit() == ExerciseUnit.REPS ? def.defaultReps() : null;
        Integer seconds = def.unit() == ExerciseUnit.SECONDS ? def.defaultSeconds() : null;
        return new PlannedItem(Phase.MAIN, def.code(), def.name(), sets, reps, seconds, DEFAULT_REST);
    }

    private static List<PlannedItem> simple(List<String> codes, Phase phase, WorkoutConditions conditions,
                                            Map<String, ExerciseDef> catalog, int budget) {
        List<PlannedItem> items = new ArrayList<>();
        int used = 0;
        for (ExerciseDef def : usable(codes, conditions, catalog)) {
            int time = WorkoutTime.secondsOf(1, def.defaultReps(), def.defaultSeconds(), def.secondsPerRep(), 0);
            if (used + time > budget) {
                break;
            }
            items.add(new PlannedItem(phase, def.code(), def.name(), 1, def.defaultReps(), def.defaultSeconds(), 0));
            used += time;
        }
        return items;
    }
}
