package com.mealfit.domain.workout.service;

import com.mealfit.domain.workout.model.ExerciseDef;
import com.mealfit.domain.workout.model.Phase;
import com.mealfit.domain.workout.model.PlannedItem;
import com.mealfit.domain.workout.model.SessionPlan;
import com.mealfit.domain.workout.model.Violation;
import com.mealfit.domain.workout.model.ViolationType;
import com.mealfit.domain.workout.model.WorkoutConditions;
import com.mealfit.domain.workout.model.WorkoutTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Component;

/**
 * 운동 루틴 서버 검증 (BR-17, 설계 7장). 생성기를 믿지 않고 저장 직전에 다시 확인한다.
 * 문장 조정(FR-WORK-02) 결과에도 같은 메서드를 쓴다.
 */
@Component
public class RoutineValidator {

    /** 분량 허용 범위 (D18 ⑤). 세트 상한은 수준별 값을 쓴다. */
    static final int MAX_REPS = 30;
    static final int MIN_SECONDS = 10;
    static final int MAX_SECONDS = 600;
    static final int MAX_REST_SECONDS = 180;

    public List<Violation> validate(SessionPlan session, WorkoutConditions conditions,
                                    Map<String, ExerciseDef> catalog) {
        List<Violation> violations = new ArrayList<>();
        int maxSets = conditions.level().maxSets();

        for (PlannedItem item : session.items()) {
            ExerciseDef def = catalog.get(item.code());
            if (def == null) {
                violations.add(new Violation(ViolationType.UNKNOWN_EXERCISE, item.code()));
                continue;
            }
            if (!conditions.owns(def.equipment())) {
                violations.add(new Violation(ViolationType.EQUIPMENT_NOT_OWNED, item.code()));
            }
            if (def.loadAreas().stream().anyMatch(conditions.injuries()::contains)) {
                violations.add(new Violation(ViolationType.INJURY_CONFLICT, item.code()));
            }
            if (def.intensity() > session.intensityCap() || def.intensity() > conditions.intensityCap()) {
                violations.add(new Violation(ViolationType.INTENSITY_EXCEEDED, item.code()));
            }
            if (!dosageOk(item, maxSets)) {
                violations.add(new Violation(ViolationType.DOSAGE_OUT_OF_RANGE, item.code()));
            }
        }

        if (WorkoutTime.sessionSeconds(session, catalog) > conditions.sessionMinutes() * 60) {
            violations.add(new Violation(ViolationType.TIME_EXCEEDED, null));
        }
        if (session.itemsOf(Phase.MAIN).isEmpty()) {
            violations.add(new Violation(ViolationType.EMPTY_MAIN, null));
        }
        return violations;
    }

    private static boolean dosageOk(PlannedItem item, int maxSets) {
        boolean setsOk = item.sets() >= 1 && item.sets() <= maxSets;
        boolean amountOk = item.reps() != null
            ? item.reps() >= 1 && item.reps() <= MAX_REPS && item.seconds() == null
            : item.seconds() != null && item.seconds() >= MIN_SECONDS && item.seconds() <= MAX_SECONDS;
        boolean restOk = item.restSeconds() >= 0 && item.restSeconds() <= MAX_REST_SECONDS;
        return setsOk && amountOk && restOk;
    }
}
