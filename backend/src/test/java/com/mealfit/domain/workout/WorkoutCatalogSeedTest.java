package com.mealfit.domain.workout;

import static org.assertj.core.api.Assertions.assertThat;

import com.mealfit.domain.workout.entity.ExerciseCatalog;
import com.mealfit.domain.workout.model.BodyArea;
import com.mealfit.domain.workout.model.Equipment;
import com.mealfit.domain.workout.model.ExerciseDef;
import com.mealfit.domain.workout.model.FocusArea;
import com.mealfit.domain.workout.model.Goal;
import com.mealfit.domain.workout.model.Level;
import com.mealfit.domain.workout.model.Phase;
import com.mealfit.domain.workout.model.SessionPlan;
import com.mealfit.domain.workout.model.WorkoutConditions;
import com.mealfit.domain.workout.repository.ExerciseCatalogRepository;
import com.mealfit.domain.workout.service.DefaultRoutineProvider;
import com.mealfit.domain.workout.service.RoutineTemplateGenerator;
import com.mealfit.domain.workout.service.RoutineValidator;
import java.time.LocalDate;
import java.util.EnumSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

/** V10 운동 사전 시드로 모든 조건 조합을 돌려, 생성 결과가 검증을 통과하는지 확인한다. */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
class WorkoutCatalogSeedTest {

    private static final LocalDate MONDAY = LocalDate.of(2026, 11, 30);

    @Autowired ExerciseCatalogRepository repository;
    @Autowired RoutineTemplateGenerator generator;
    @Autowired RoutineValidator validator;
    @Autowired DefaultRoutineProvider defaults;

    private List<ExerciseDef> catalog() {
        return repository.findAllActiveWithLoadAreas().stream().map(ExerciseCatalog::toDef).toList();
    }

    @Test
    void 시드는_맨몸만으로_모든_본운동_부위를_채운다() {
        List<ExerciseDef> catalog = catalog();
        assertThat(catalog).hasSizeGreaterThanOrEqualTo(45);
        for (FocusArea area : List.of(FocusArea.LOWER, FocusArea.UPPER_PUSH, FocusArea.UPPER_PULL, FocusArea.CORE,
                FocusArea.FULL, FocusArea.CARDIO)) {
            long count = catalog.stream()
                .filter(def -> def.phase() == Phase.MAIN && def.focusArea() == area
                    && def.equipment() == Equipment.BODYWEIGHT)
                .count();
            assertThat(count).as(area.name()).isGreaterThanOrEqualTo(2);
        }
        Map<String, ExerciseDef> map = catalog.stream()
            .collect(Collectors.toMap(ExerciseDef::code, Function.identity()));
        assertThat(map).containsKeys("MARCH_BRISK", "GLUTE_BRIDGE", "WALL_PUSHUP", "BIRD_DOG", "DEAD_BUG",
            "CHAIR_SQUAT", "BREATHING_RELAX");
        assertThat(map.get("JUMP_SQUAT").loadAreas()).contains(BodyArea.KNEE);
    }

    @Test
    void 실제_시드로_모든_조합이_검증을_통과하거나_기본루틴으로_대체된다() {
        List<ExerciseDef> catalog = catalog();
        Map<String, ExerciseDef> map = catalog.stream()
            .collect(Collectors.toMap(ExerciseDef::code, Function.identity()));
        List<Set<Equipment>> equipmentSets = List.of(Set.of(), EnumSet.of(Equipment.DUMBBELL),
            EnumSet.of(Equipment.BAND, Equipment.PULLUP_BAR), EnumSet.allOf(Equipment.class));
        List<Set<BodyArea>> injurySets = List.of(Set.of(), EnumSet.of(BodyArea.KNEE),
            EnumSet.of(BodyArea.LOWER_BACK, BodyArea.SHOULDER), EnumSet.allOf(BodyArea.class));
        int rule = 0;
        int fallback = 0;
        for (Goal goal : Goal.values()) {
            for (Level level : Level.values()) {
                for (int minutes : List.of(15, 30, 45, 60)) {
                    for (Set<Equipment> equipment : equipmentSets) {
                        for (Set<BodyArea> injuries : injurySets) {
                            WorkoutConditions c = new WorkoutConditions(goal, level, 4, minutes, equipment, injuries,
                                false, 0.0, 0);
                            for (SessionPlan plan : generator.generate(c, catalog, MONDAY, 3)) {
                                if (validator.validate(plan, c, map).isEmpty()) {
                                    rule++;
                                    continue;
                                }
                                fallback++;
                                SessionPlan replacement = defaults.build(c, map, plan.date());
                                assertThat(validator.validate(replacement, c, map))
                                    .as("%s %s %d분 %s %s", goal, level, minutes, equipment, injuries).isEmpty();
                            }
                        }
                    }
                }
            }
        }
        // 부상이 일부만 있을 때는 대부분 규칙으로 만들어져야 한다.
        assertThat(rule).isGreaterThan(fallback);
    }
}
