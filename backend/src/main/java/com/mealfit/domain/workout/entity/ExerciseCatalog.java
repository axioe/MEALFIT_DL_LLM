package com.mealfit.domain.workout.entity;

import com.mealfit.domain.workout.model.BodyArea;
import com.mealfit.domain.workout.model.Equipment;
import com.mealfit.domain.workout.model.ExerciseDef;
import com.mealfit.domain.workout.model.ExerciseUnit;
import com.mealfit.domain.workout.model.FocusArea;
import com.mealfit.domain.workout.model.Phase;
import com.mealfit.global.common.BaseTimeEntity;
import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.util.HashSet;
import java.util.Set;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

/** 운동 사전 (공용 참조 데이터, V10 시드). 서비스 코드는 {@link #toDef()}로 불변 값만 넘긴다. */
@Getter
@Entity
@Table(name = "exercise_catalog")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ExerciseCatalog extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 50, unique = true)
    private String code;

    @Column(name = "name_ko", nullable = false, length = 100)
    private String nameKo;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Phase phase;

    @Enumerated(EnumType.STRING)
    @Column(name = "focus_area", nullable = false, length = 20)
    private FocusArea focusArea;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Equipment equipment;

    @Column(nullable = false)
    private int intensity;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ExerciseUnit unit;

    @Column(name = "default_sets", nullable = false)
    private int defaultSets;

    @Column(name = "default_reps")
    private Integer defaultReps;

    @Column(name = "default_seconds")
    private Integer defaultSeconds;

    @Column(name = "seconds_per_rep", nullable = false, precision = 4, scale = 1)
    private BigDecimal secondsPerRep;

    @Column(name = "rest_seconds", nullable = false)
    private int restSeconds;

    @Column(name = "pose_exercise_key", length = 50)
    private String poseExerciseKey;

    @Column(nullable = false)
    private boolean active;

    @ElementCollection
    @CollectionTable(name = "exercise_catalog_load_areas", joinColumns = @JoinColumn(name = "exercise_id"))
    @Enumerated(EnumType.STRING)
    @Column(name = "body_area", nullable = false, length = 20)
    private Set<BodyArea> loadAreas = new HashSet<>();

    public ExerciseDef toDef() {
        return new ExerciseDef(code, nameKo, phase, focusArea, equipment, intensity, unit, defaultSets,
            defaultReps, defaultSeconds, secondsPerRep.doubleValue(), restSeconds, loadAreas);
    }
}
