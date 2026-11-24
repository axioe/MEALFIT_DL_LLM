package com.mealfit.domain.workout;

import static org.assertj.core.api.Assertions.assertThat;

import com.mealfit.domain.workout.model.BodyArea;
import com.mealfit.domain.workout.model.Equipment;
import com.mealfit.domain.workout.model.ExerciseDef;
import com.mealfit.domain.workout.model.ExerciseUnit;
import com.mealfit.domain.workout.model.FocusArea;
import com.mealfit.domain.workout.model.Goal;
import com.mealfit.domain.workout.model.Level;
import com.mealfit.domain.workout.model.Phase;
import com.mealfit.domain.workout.model.PlannedItem;
import com.mealfit.domain.workout.model.SessionFocus;
import com.mealfit.domain.workout.model.SessionPlan;
import com.mealfit.domain.workout.model.ViolationType;
import com.mealfit.domain.workout.model.WorkoutConditions;
import com.mealfit.domain.workout.model.WorkoutTime;
import com.mealfit.domain.workout.service.DefaultRoutineProvider;
import com.mealfit.domain.workout.service.RoutineTemplateGenerator;
import com.mealfit.domain.workout.service.RoutineValidator;
import com.mealfit.domain.workout.service.SessionComposer;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;
import org.junit.jupiter.api.Test;

/** 규칙 엔진 순수 클래스 단위 테스트 (DB 없음). 실제 시드 전체 검증은 WorkoutCatalogSeedTest가 맡는다. */
class WorkoutEngineTest {

    private static final LocalDate MONDAY = LocalDate.of(2026, 11, 30);

    private final SessionComposer composer = new SessionComposer();
    private final RoutineTemplateGenerator generator = new RoutineTemplateGenerator(composer);
    private final RoutineValidator validator = new RoutineValidator();
    private final DefaultRoutineProvider defaults = new DefaultRoutineProvider();

    private static ExerciseDef def(String code, Phase phase, FocusArea area, Equipment equipment, int intensity,
                                   ExerciseUnit unit, Integer reps, Integer seconds, BodyArea... loads) {
        Set<BodyArea> loadAreas = loads.length == 0 ? Set.of() : EnumSet.of(loads[0], loads);
        return new ExerciseDef(code, code, phase, area, equipment, intensity, unit, 3, reps, seconds, 3.0, 60,
            loadAreas);
    }

    private static ExerciseDef warm(String code, BodyArea... loads) {
        return def(code, Phase.WARM_UP, FocusArea.MOBILITY, Equipment.BODYWEIGHT, 1, ExerciseUnit.SECONDS, null, 60,
            loads);
    }

    private static ExerciseDef cool(String code, BodyArea... loads) {
        return def(code, Phase.COOL_DOWN, FocusArea.MOBILITY, Equipment.BODYWEIGHT, 1, ExerciseUnit.SECONDS, null,
            60, loads);
    }

    private static ExerciseDef main(String code, FocusArea area, Equipment equipment, int intensity,
                                    BodyArea... loads) {
        return def(code, Phase.MAIN, area, equipment, intensity, ExerciseUnit.REPS, 10, null, loads);
    }

    /** 기본 루틴 코드와 부위·장비·강도 조합을 고루 담은 작은 사전. */
    static List<ExerciseDef> catalog() {
        List<ExerciseDef> list = new ArrayList<>(List.of(
            warm("DEEP_BREATHING"), warm("ARM_CIRCLE", BodyArea.SHOULDER), warm("HIP_CIRCLE", BodyArea.HIP),
            warm("WRIST_ANKLE_ROLL", BodyArea.WRIST, BodyArea.ANKLE), warm("NECK_ROLL", BodyArea.NECK),
            warm("JUMPING_JACK", BodyArea.KNEE, BodyArea.ANKLE),
            cool("BREATHING_RELAX"), cool("HAMSTRING_STRETCH", BodyArea.LOWER_BACK),
            cool("CHEST_STRETCH", BodyArea.SHOULDER), cool("CALF_STRETCH", BodyArea.ANKLE),
            cool("SUPINE_TWIST", BodyArea.LOWER_BACK),
            def("MARCH_BRISK", Phase.MAIN, FocusArea.CARDIO, Equipment.BODYWEIGHT, 1, ExerciseUnit.SECONDS, null,
                120, BodyArea.ANKLE),
            main("GLUTE_BRIDGE", FocusArea.LOWER, Equipment.BODYWEIGHT, 1),
            main("WALL_PUSHUP", FocusArea.UPPER_PUSH, Equipment.BODYWEIGHT, 1, BodyArea.WRIST, BodyArea.SHOULDER),
            main("BIRD_DOG", FocusArea.CORE, Equipment.BODYWEIGHT, 1, BodyArea.WRIST),
            main("DEAD_BUG", FocusArea.CORE, Equipment.BODYWEIGHT, 1),
            main("CHAIR_SQUAT", FocusArea.LOWER, Equipment.BODYWEIGHT, 1, BodyArea.KNEE, BodyArea.HIP),
            main("BW_SQUAT", FocusArea.LOWER, Equipment.BODYWEIGHT, 2, BodyArea.KNEE, BodyArea.HIP),
            main("JUMP_SQUAT", FocusArea.LOWER, Equipment.BODYWEIGHT, 3, BodyArea.KNEE, BodyArea.ANKLE),
            main("PUSHUP", FocusArea.UPPER_PUSH, Equipment.BODYWEIGHT, 2, BodyArea.WRIST, BodyArea.SHOULDER),
            main("SUPERMAN", FocusArea.UPPER_PULL, Equipment.BODYWEIGHT, 1, BodyArea.LOWER_BACK),
            main("BURPEE", FocusArea.FULL, Equipment.BODYWEIGHT, 3, BodyArea.KNEE, BodyArea.WRIST),
            def("HIGH_KNEES", Phase.MAIN, FocusArea.CARDIO, Equipment.BODYWEIGHT, 2, ExerciseUnit.SECONDS, null, 30,
                BodyArea.KNEE),
            def("PLANK", Phase.MAIN, FocusArea.CORE, Equipment.BODYWEIGHT, 2, ExerciseUnit.SECONDS, null, 30,
                BodyArea.SHOULDER),
            main("DB_ROW", FocusArea.UPPER_PULL, Equipment.DUMBBELL, 2, BodyArea.LOWER_BACK),
            main("DB_GOBLET_SQUAT", FocusArea.LOWER, Equipment.DUMBBELL, 2, BodyArea.KNEE),
            main("DB_LATERAL_RAISE", FocusArea.UPPER_PUSH, Equipment.DUMBBELL, 1, BodyArea.SHOULDER),
            main("BB_SQUAT", FocusArea.LOWER, Equipment.BARBELL, 3, BodyArea.KNEE, BodyArea.LOWER_BACK),
            main("BB_ROW", FocusArea.UPPER_PULL, Equipment.BARBELL, 3, BodyArea.LOWER_BACK)
        ));
        return list;
    }

    private static Map<String, ExerciseDef> byCode(List<ExerciseDef> catalog) {
        return catalog.stream().collect(Collectors.toMap(ExerciseDef::code, Function.identity()));
    }

    private static WorkoutConditions conditions(Goal goal, Level level, int days, int minutes,
                                                Set<Equipment> equipment, Set<BodyArea> injuries) {
        return new WorkoutConditions(goal, level, days, minutes, equipment, injuries, false, 0.0, 0);
    }

    private List<SessionPlan> generate(WorkoutConditions c, List<ExerciseDef> catalog) {
        return generator.generate(c, catalog, MONDAY, 7);
    }

    @Test
    void 모든_목표_수준_시간_조합에서_세션시간이_회당시간_이하이고_검증을_통과한다() {
        List<ExerciseDef> catalog = catalog();
        Map<String, ExerciseDef> map = byCode(catalog);
        for (Goal goal : Goal.values()) {
            for (Level level : Level.values()) {
                for (int minutes : List.of(15, 30, 45, 60)) {
                    for (int days = 2; days <= 6; days++) {
                        WorkoutConditions c = conditions(goal, level, days, minutes,
                            EnumSet.of(Equipment.DUMBBELL, Equipment.BARBELL), Set.of());
                        for (SessionPlan plan : generate(c, catalog)) {
                            assertThat(WorkoutTime.sessionSeconds(plan, map)).isLessThanOrEqualTo(minutes * 60);
                            assertThat(validator.validate(plan, c, map)).as("%s %s %d분 %d일 %s", goal, level,
                                minutes, days, plan.date()).isEmpty();
                        }
                    }
                }
            }
        }
    }

    @Test
    void 주당_일수만큼_정해진_요일에_세션을_만든다() {
        WorkoutConditions c = conditions(Goal.STRENGTH, Level.BEGINNER, 3, 30, Set.of(), Set.of());
        List<SessionPlan> plans = generate(c, catalog());
        // 시작 주와 다음 주, 2주치
        assertThat(plans).hasSize(6);
        assertThat(plans).extracting(plan -> plan.date().getDayOfWeek()).containsOnly(DayOfWeek.MONDAY,
            DayOfWeek.WEDNESDAY, DayOfWeek.FRIDAY);
    }

    @Test
    void 근력_4일_6일은_같은_부위를_연속된_운동일에_두지_않는다() {
        for (int days : List.of(4, 6)) {
            WorkoutConditions c = conditions(Goal.STRENGTH, Level.INTERMEDIATE, days, 45, Set.of(), Set.of());
            List<SessionPlan> plans = generate(c, catalog());
            for (int i = 1; i < plans.size(); i++) {
                if (plans.get(i).date().minusDays(1).equals(plans.get(i - 1).date())) {
                    assertThat(plans.get(i).focus()).isNotEqualTo(plans.get(i - 1).focus());
                }
            }
        }
    }

    @Test
    void 같은_입력이면_같은_루틴이_나온다() {
        WorkoutConditions c = conditions(Goal.FAT_LOSS, Level.INTERMEDIATE, 4, 45, EnumSet.of(Equipment.DUMBBELL),
            Set.of());
        assertThat(generate(c, catalog())).isEqualTo(generate(c, catalog()));
    }

    @Test
    void 보유하지_않은_장비_운동은_들어가지_않는다() {
        WorkoutConditions c = conditions(Goal.STRENGTH, Level.ADVANCED, 4, 60, EnumSet.of(Equipment.DUMBBELL),
            Set.of());
        Map<String, ExerciseDef> map = byCode(catalog());
        generate(c, catalog()).forEach(plan -> plan.items().forEach(item ->
            assertThat(map.get(item.code()).equipment()).isIn(Equipment.BODYWEIGHT, Equipment.DUMBBELL)));
    }

    @Test
    void 부상_부위에_부담을_주는_운동은_들어가지_않는다() {
        WorkoutConditions c = conditions(Goal.STRENGTH, Level.ADVANCED, 3, 45,
            EnumSet.of(Equipment.DUMBBELL, Equipment.BARBELL), EnumSet.of(BodyArea.KNEE));
        Map<String, ExerciseDef> map = byCode(catalog());
        generate(c, catalog()).forEach(plan -> plan.items().forEach(item ->
            assertThat(map.get(item.code()).loadAreas()).doesNotContain(BodyArea.KNEE)));
    }

    @Test
    void 입문자는_강도1_운동만_받고_부상이_있으면_한단계_낮춘다() {
        Map<String, ExerciseDef> map = byCode(catalog());
        WorkoutConditions starter = conditions(Goal.STRENGTH, Level.STARTER, 3, 30, Set.of(), Set.of());
        generate(starter, catalog()).forEach(plan -> plan.items().forEach(item ->
            assertThat(map.get(item.code()).intensity()).isEqualTo(1)));

        WorkoutConditions injured = conditions(Goal.STRENGTH, Level.ADVANCED, 3, 30, Set.of(),
            EnumSet.of(BodyArea.NECK));
        assertThat(injured.intensityCap()).isEqualTo(2);
        generate(injured, catalog()).forEach(plan -> plan.items().forEach(item ->
            assertThat(map.get(item.code()).intensity()).isLessThanOrEqualTo(2)));
    }

    @Test
    void 건너뜀이_많거나_모르는_부상값이면_강도상한을_낮춘다() {
        WorkoutConditions skipHeavy = new WorkoutConditions(Goal.STRENGTH, Level.ADVANCED, 3, 30, Set.of(),
            Set.of(), false, 0.5, 4);
        assertThat(skipHeavy.intensityCap()).isEqualTo(2);
        WorkoutConditions unknown = new WorkoutConditions(Goal.STRENGTH, Level.ADVANCED, 3, 30, Set.of(),
            Set.of(), true, 0.0, 0);
        assertThat(unknown.intensityCap()).isEqualTo(1);
    }

    @Test
    void 중급은_주당_HIGH_세션을_2개까지만_만든다() {
        WorkoutConditions c = conditions(Goal.STRENGTH, Level.INTERMEDIATE, 6, 60, EnumSet.of(Equipment.BARBELL),
            Set.of());
        Map<String, ExerciseDef> map = byCode(catalog());
        List<SessionPlan> firstWeek = generate(c, catalog()).stream()
            .filter(plan -> plan.date().isBefore(MONDAY.plusDays(7))).toList();
        long highSessions = firstWeek.stream()
            .filter(plan -> plan.items().stream().anyMatch(item -> map.get(item.code()).isHigh()))
            .count();
        assertThat(highSessions).isLessThanOrEqualTo(2);
    }

    @Test
    void 무릎부상_기본루틴은_무릎운동을_빼고_검증을_통과한다() {
        WorkoutConditions c = conditions(Goal.STRENGTH, Level.BEGINNER, 3, 30, Set.of(), EnumSet.of(BodyArea.KNEE));
        Map<String, ExerciseDef> map = byCode(catalog());
        SessionPlan plan = defaults.build(c, map, MONDAY);
        assertThat(plan.focus()).isEqualTo(SessionFocus.DEFAULT);
        assertThat(plan.source()).isEqualTo(SessionPlan.SOURCE_DEFAULT);
        assertThat(plan.items()).extracting(PlannedItem::code).doesNotContain("CHAIR_SQUAT", "JUMPING_JACK");
        assertThat(plan.itemsOf(Phase.MAIN)).hasSizeGreaterThanOrEqualTo(2);
        assertThat(validator.validate(plan, c, map)).isEmpty();
    }

    @Test
    void 모든_부위를_다쳐도_부담없는_운동이_2개_남으면_기본루틴이고_검증을_통과한다() {
        for (int minutes : List.of(15, 30, 45, 60)) {
            WorkoutConditions c = conditions(Goal.MAINTAIN, Level.STARTER, 2, minutes, Set.of(),
                EnumSet.allOf(BodyArea.class));
            Map<String, ExerciseDef> map = byCode(catalog());
            SessionPlan plan = defaults.build(c, map, MONDAY);
            assertThat(plan.focus()).isEqualTo(SessionFocus.DEFAULT);
            assertThat(plan.itemsOf(Phase.MAIN)).extracting(PlannedItem::code)
                .containsOnly("GLUTE_BRIDGE", "DEAD_BUG");
            assertThat(validator.validate(plan, c, map)).isEmpty();
        }
    }

    @Test
    void 기본루틴_본운동이_2개_미만이면_회복세션이고_검증을_통과한다() {
        List<ExerciseDef> catalog = catalog().stream()
            .filter(def -> !Set.of("GLUTE_BRIDGE", "DEAD_BUG").contains(def.code()))
            .toList();
        Map<String, ExerciseDef> map = byCode(catalog);
        for (int minutes : List.of(15, 30, 45, 60)) {
            WorkoutConditions c = conditions(Goal.MAINTAIN, Level.STARTER, 2, minutes, Set.of(),
                EnumSet.allOf(BodyArea.class));
            SessionPlan plan = defaults.build(c, map, MONDAY);
            assertThat(plan.focus()).isEqualTo(SessionFocus.RECOVERY);
            assertThat(plan.itemsOf(Phase.MAIN)).extracting(PlannedItem::code).containsExactly("BREATHING_RELAX");
            assertThat(validator.validate(plan, c, map)).isEmpty();
        }
    }

    @Test
    void 검증기는_위반_종류를_찾아낸다() {
        Map<String, ExerciseDef> map = byCode(catalog());
        WorkoutConditions c = conditions(Goal.STRENGTH, Level.BEGINNER, 3, 15, Set.of(), EnumSet.of(BodyArea.KNEE));
        SessionPlan bad = new SessionPlan(MONDAY, SessionFocus.LOWER, "bad", List.of(
            new PlannedItem(Phase.MAIN, "NOT_IN_CATALOG", "?", 3, 10, null, 60),
            new PlannedItem(Phase.MAIN, "DB_ROW", "덤벨 로우", 3, 10, null, 60),
            new PlannedItem(Phase.MAIN, "BW_SQUAT", "스쿼트", 3, 10, null, 60),
            new PlannedItem(Phase.MAIN, "JUMP_SQUAT", "점프", 3, 10, null, 60),
            new PlannedItem(Phase.MAIN, "GLUTE_BRIDGE", "브릿지", 9, 50, null, 600)
        ), SessionPlan.SOURCE_RULE, 2);
        assertThat(validator.validate(bad, c, map)).extracting(v -> v.type()).contains(
            ViolationType.UNKNOWN_EXERCISE, ViolationType.EQUIPMENT_NOT_OWNED, ViolationType.INJURY_CONFLICT,
            ViolationType.INTENSITY_EXCEEDED, ViolationType.DOSAGE_OUT_OF_RANGE, ViolationType.TIME_EXCEEDED);

        SessionPlan empty = new SessionPlan(MONDAY, SessionFocus.LOWER, "empty", List.of(), SessionPlan.SOURCE_RULE,
            2);
        assertThat(validator.validate(empty, c, map)).extracting(v -> v.type()).contains(ViolationType.EMPTY_MAIN);
    }

    @Test
    void 본운동_후보가_없으면_생성기는_빈_본운동을_내고_검증에서_걸린다() {
        List<ExerciseDef> onlyJumpAndBarbell = catalog().stream()
            .filter(def -> def.phase() != Phase.MAIN || Set.of("JUMP_SQUAT", "BB_SQUAT").contains(def.code()))
            .toList();
        WorkoutConditions c = conditions(Goal.STRENGTH, Level.BEGINNER, 3, 30, EnumSet.of(Equipment.DUMBBELL),
            EnumSet.of(BodyArea.KNEE));
        SessionPlan plan = generate(c, onlyJumpAndBarbell).get(0);
        assertThat(plan.itemsOf(Phase.MAIN)).isEmpty();
        assertThat(validator.validate(plan, c, byCode(onlyJumpAndBarbell))).extracting(v -> v.type())
            .contains(ViolationType.EMPTY_MAIN);
    }
}
