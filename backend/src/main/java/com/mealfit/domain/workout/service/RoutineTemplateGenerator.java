package com.mealfit.domain.workout.service;

import com.mealfit.domain.workout.model.ExerciseDef;
import com.mealfit.domain.workout.model.Goal;
import com.mealfit.domain.workout.model.SessionFocus;
import com.mealfit.domain.workout.model.SessionPlan;
import com.mealfit.domain.workout.model.WorkoutConditions;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.IsoFields;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

/**
 * 요일 배치와 목표별 부위 배분으로 기간 안의 세션을 만든다 (설계 6.1·6.2).
 * 결과는 검증 전 초안이며, 저장 전에 {@link RoutineValidator}를 거친다.
 */
@Component
@RequiredArgsConstructor
public class RoutineTemplateGenerator {

    public static final String RULE_VERSION = "wr-1.0";

    private final SessionComposer composer;

    /** 주당 일수별 운동 요일 (설계 6.1, 결정 D7 제안). */
    static List<DayOfWeek> trainingDays(int daysPerWeek) {
        return switch (daysPerWeek) {
            case 2 -> List.of(DayOfWeek.MONDAY, DayOfWeek.THURSDAY);
            case 3 -> List.of(DayOfWeek.MONDAY, DayOfWeek.WEDNESDAY, DayOfWeek.FRIDAY);
            case 4 -> List.of(DayOfWeek.MONDAY, DayOfWeek.TUESDAY, DayOfWeek.THURSDAY, DayOfWeek.FRIDAY);
            case 5 -> List.of(DayOfWeek.MONDAY, DayOfWeek.TUESDAY, DayOfWeek.WEDNESDAY, DayOfWeek.FRIDAY,
                DayOfWeek.SATURDAY);
            case 6 -> List.of(DayOfWeek.MONDAY, DayOfWeek.TUESDAY, DayOfWeek.WEDNESDAY, DayOfWeek.THURSDAY,
                DayOfWeek.FRIDAY, DayOfWeek.SATURDAY);
            default -> throw new IllegalArgumentException("주당 일수는 2–6일만 허용합니다: " + daysPerWeek);
        };
    }

    /**
     * 주 안에서 index번째 운동일의 중심 부위 (설계 6.2).
     * 같은 부위가 연속된 운동일에 오지 않도록 번갈아 배치한다.
     */
    static SessionFocus focusFor(Goal goal, int daysPerWeek, int index) {
        return switch (goal) {
            case STRENGTH -> {
                if (daysPerWeek <= 3) {
                    yield SessionFocus.FULL_BODY;
                }
                List<SessionFocus> cycle = daysPerWeek == 4
                    ? List.of(SessionFocus.UPPER, SessionFocus.LOWER)
                    : List.of(SessionFocus.UPPER, SessionFocus.LOWER, SessionFocus.CORE_CARDIO);
                yield cycle.get(index % cycle.size());
            }
            case FAT_LOSS, MAINTAIN -> daysPerWeek <= 3 || index % 2 == 0
                ? SessionFocus.FULL_BODY : SessionFocus.CORE_CARDIO;
            case ENDURANCE -> index % 2 == 0 ? SessionFocus.CORE_CARDIO : SessionFocus.FULL_BODY;
        };
    }

    /** 시작일이 속한 주와 다음 주까지 (설계 5.3, 결정 D6 제안). */
    public static LocalDate plannedUntil(LocalDate startDate) {
        return startDate.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY)).plusWeeks(1);
    }

    public static int seedOf(Long userId, LocalDate startDate) {
        LocalDate monday = startDate.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        return Math.abs((userId + ":" + monday + ":" + RULE_VERSION).hashCode() % 1000);
    }

    public List<SessionPlan> generate(WorkoutConditions conditions, List<ExerciseDef> catalog,
                                      LocalDate startDate, int seed) {
        List<DayOfWeek> days = trainingDays(conditions.daysPerWeek());
        Map<String, ExerciseDef> byCode = catalog.stream()
            .collect(Collectors.toMap(ExerciseDef::code, Function.identity()));
        Map<Integer, Integer> highSessionsByWeek = new HashMap<>();
        Set<LocalDate> highDates = new java.util.HashSet<>();
        List<SessionPlan> sessions = new ArrayList<>();

        LocalDate end = plannedUntil(startDate);
        for (LocalDate date = startDate; !date.isAfter(end); date = date.plusDays(1)) {
            int index = days.indexOf(date.getDayOfWeek());
            if (index < 0) {
                continue;
            }
            int week = date.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);
            int cap = conditions.intensityCap();
            int highAllowed = conditions.level().highPerSession();
            boolean weeklyFull = highSessionsByWeek.getOrDefault(week, 0) >= conditions.level().highSessionsPerWeek();
            if (weeklyFull || highDates.contains(date.minusDays(1))) {
                cap = Math.min(cap, 2);
            }
            if (cap < 3) {
                highAllowed = 0;
            }

            SessionFocus focus = focusFor(conditions.goal(), conditions.daysPerWeek(), index);
            SessionPlan session = composer.compose(conditions, catalog, date, focus, cap, highAllowed,
                seed + index);
            sessions.add(session);

            boolean hasHigh = session.items().stream()
                .map(item -> byCode.get(item.code()))
                .anyMatch(def -> def != null && def.isHigh());
            if (hasHigh) {
                highDates.add(date);
                highSessionsByWeek.merge(week, 1, Integer::sum);
            }
        }
        return sessions;
    }
}
