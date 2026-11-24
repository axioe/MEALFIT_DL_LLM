package com.mealfit.domain.workout.service;

import com.mealfit.domain.workout.model.Equipment;
import com.mealfit.domain.workout.model.ExerciseDef;
import com.mealfit.domain.workout.model.ExerciseUnit;
import com.mealfit.domain.workout.model.FocusArea;
import com.mealfit.domain.workout.model.Goal;
import com.mealfit.domain.workout.model.Phase;
import com.mealfit.domain.workout.model.PlannedItem;
import com.mealfit.domain.workout.model.SessionFocus;
import com.mealfit.domain.workout.model.SessionPlan;
import com.mealfit.domain.workout.model.WorkoutConditions;
import com.mealfit.domain.workout.model.WorkoutTime;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.stereotype.Component;

/**
 * 하루 세션을 운동 사전에서 골라 채운다 (설계 6.3–6.5). DB·시계에 의존하지 않는 순수 계산이다.
 * 세션 추정 시간은 항상 선택한 회당 시간 이하가 된다 (BR-17).
 */
@Component
public class SessionComposer {

    /** 본 운동 칸을 시도하는 최대 횟수. */
    private static final int MAX_MAIN_SLOTS = 10;

    /** 칸에 맞는 운동이 없을 때 대신 찾아볼 부위. */
    private static final Map<FocusArea, List<FocusArea>> FALLBACK = Map.of(
        FocusArea.CARDIO, List.of(FocusArea.FULL, FocusArea.LOWER),
        FocusArea.FULL, List.of(FocusArea.CARDIO, FocusArea.LOWER),
        FocusArea.UPPER_PULL, List.of(FocusArea.CORE),
        FocusArea.UPPER_PUSH, List.of(FocusArea.CORE),
        FocusArea.LOWER, List.of(FocusArea.CORE),
        FocusArea.CORE, List.of(FocusArea.FULL)
    );

    public SessionPlan compose(WorkoutConditions conditions, List<ExerciseDef> catalog, LocalDate date,
                               SessionFocus focus, int intensityCap, int highAllowed, int rotation) {
        int minutes = conditions.sessionMinutes();
        int[] budget = phaseBudgetSeconds(minutes);
        List<PlannedItem> items = new ArrayList<>();

        items.addAll(fillSimple(conditions, catalog, Phase.WARM_UP, intensityCap, budget[0], rotation));
        items.addAll(fillMain(conditions, catalog, focus, intensityCap, highAllowed, budget[1], rotation));
        items.addAll(fillSimple(conditions, catalog, Phase.COOL_DOWN, intensityCap, budget[2], rotation));

        String title = focus.label() + " " + minutes + "분";
        return new SessionPlan(date, focus, title, items, SessionPlan.SOURCE_RULE, intensityCap);
    }

    /** 준비 · 본 운동 · 정리 시간(초) (설계 6.3). */
    static int[] phaseBudgetSeconds(int minutes) {
        return switch (minutes) {
            case 15 -> new int[] {3 * 60, 10 * 60, 2 * 60};
            case 30 -> new int[] {5 * 60, 21 * 60, 4 * 60};
            case 45 -> new int[] {7 * 60, 32 * 60, 6 * 60};
            case 60 -> new int[] {8 * 60, 44 * 60, 8 * 60};
            default -> throw new IllegalArgumentException("회당 시간은 15/30/45/60분만 허용합니다: " + minutes);
        };
    }

    /** 사용자가 할 수 있는 운동인지 (장비·부상·강도, 설계 6.4). */
    static boolean allowed(ExerciseDef def, WorkoutConditions conditions, int intensityCap) {
        return conditions.owns(def.equipment())
            && def.loadAreas().stream().noneMatch(conditions.injuries()::contains)
            && def.intensity() <= intensityCap;
    }

    private List<PlannedItem> fillSimple(WorkoutConditions conditions, List<ExerciseDef> catalog, Phase phase,
                                         int intensityCap, int budget, int rotation) {
        List<ExerciseDef> candidates = catalog.stream()
            .filter(def -> def.phase() == phase && allowed(def, conditions, intensityCap))
            .sorted(Comparator.comparing(ExerciseDef::code))
            .toList();
        List<PlannedItem> items = new ArrayList<>();
        int used = 0;
        for (int i = 0; i < candidates.size(); i++) {
            ExerciseDef def = candidates.get(Math.floorMod(rotation + i, candidates.size()));
            int seconds = WorkoutTime.secondsOf(1, def.defaultReps(), def.defaultSeconds(), def.secondsPerRep(), 0);
            if (used + seconds > budget) {
                break;
            }
            items.add(itemOf(def, phase, 1, def.defaultReps(), def.defaultSeconds(), 0));
            used += seconds;
        }
        return items;
    }

    private List<PlannedItem> fillMain(WorkoutConditions conditions, List<ExerciseDef> catalog, SessionFocus focus,
                                       int intensityCap, int highAllowed, int budget, int rotation) {
        List<PlannedItem> items = new ArrayList<>();
        Set<String> used = new HashSet<>();
        int usedSeconds = 0;
        int highCount = 0;

        for (int slot = 0; slot < MAX_MAIN_SLOTS; slot++) {
            boolean highOk = highCount < highAllowed;
            ExerciseDef def = pick(conditions, catalog, focus.slot(slot), intensityCap, highOk, used,
                rotation + slot);
            if (def == null) {
                continue;
            }
            used.add(def.code());

            int sets = targetSets(conditions);
            Integer reps = def.unit() == ExerciseUnit.REPS ? targetReps(conditions.goal(), def) : null;
            Integer seconds = def.unit() == ExerciseUnit.SECONDS ? targetSeconds(conditions.goal(), def) : null;
            int rest = restSeconds(conditions.goal());

            int time = WorkoutTime.secondsOf(sets, reps, seconds, def.secondsPerRep(), rest);
            while (usedSeconds + time > budget && sets > 1) {
                sets--;
                time = WorkoutTime.secondsOf(sets, reps, seconds, def.secondsPerRep(), rest);
            }
            if (usedSeconds + time > budget) {
                continue;
            }
            items.add(itemOf(def, Phase.MAIN, sets, reps, seconds, rest));
            usedSeconds += time;
            if (def.isHigh()) {
                highCount++;
            }
        }
        return items;
    }

    private ExerciseDef pick(WorkoutConditions conditions, List<ExerciseDef> catalog, FocusArea area,
                             int intensityCap, boolean highOk, Set<String> used, int rotation) {
        List<FocusArea> areas = new ArrayList<>();
        areas.add(area);
        areas.addAll(FALLBACK.getOrDefault(area, List.of()));
        for (FocusArea candidateArea : areas) {
            List<ExerciseDef> candidates = catalog.stream()
                .filter(def -> def.phase() == Phase.MAIN && def.focusArea() == candidateArea)
                .filter(def -> allowed(def, conditions, intensityCap))
                .filter(def -> highOk || !def.isHigh())
                .filter(def -> !used.contains(def.code()))
                .sorted(Comparator
                    .comparing((ExerciseDef def) -> def.equipment() == Equipment.BODYWEIGHT)
                    .thenComparing(ExerciseDef::intensity, Comparator.reverseOrder())
                    .thenComparing(ExerciseDef::code))
                .toList();
            if (!candidates.isEmpty()) {
                return candidates.get(Math.floorMod(rotation, candidates.size()));
            }
        }
        return null;
    }

    /** 목표별 기본 세트 + 수준 보정, 수준별 최대 세트 이하 (설계 6.5, D18 ①). */
    static int targetSets(WorkoutConditions conditions) {
        int base = switch (conditions.goal()) {
            case STRENGTH, FAT_LOSS -> 3;
            case ENDURANCE, MAINTAIN -> 2;
        };
        int sets = base + conditions.level().setAdjustment();
        return Math.max(1, Math.min(sets, conditions.level().maxSets()));
    }

    private static Integer targetReps(Goal goal, ExerciseDef def) {
        int reps = def.defaultReps() == null ? 10 : def.defaultReps();
        if (goal == Goal.FAT_LOSS) {
            reps += 3;
        }
        return Math.min(reps, 30);
    }

    private static Integer targetSeconds(Goal goal, ExerciseDef def) {
        if (goal == Goal.ENDURANCE) {
            return 40;
        }
        return def.defaultSeconds() == null ? 30 : def.defaultSeconds();
    }

    private static int restSeconds(Goal goal) {
        return switch (goal) {
            case STRENGTH -> 90;
            case FAT_LOSS -> 45;
            case ENDURANCE -> 20;
            case MAINTAIN -> 60;
        };
    }

    private static PlannedItem itemOf(ExerciseDef def, Phase phase, int sets, Integer reps, Integer seconds,
                                      int rest) {
        return new PlannedItem(phase, def.code(), def.name(), sets, reps, seconds, rest);
    }
}
