package com.mealfit.domain.workout.service;

import com.mealfit.domain.user.entity.ProfileDetails;
import com.mealfit.domain.user.repository.ProfileDetailsRepository;
import com.mealfit.domain.user.repository.ProfileRepository;
import com.mealfit.domain.workout.dto.RoutineRecommendRequest;
import com.mealfit.domain.workout.model.BodyArea;
import com.mealfit.domain.workout.model.Equipment;
import com.mealfit.domain.workout.model.Goal;
import com.mealfit.domain.workout.model.Level;
import com.mealfit.domain.workout.model.WorkoutConditions;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.util.ArrayList;
import java.util.Collection;
import java.util.EnumSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

/**
 * 요청 값과 프로필(profile_details)의 운동 조건을 합쳐 엔진 입력으로 바꾼다 (설계 3장).
 * 요청 값이 우선이고, 없으면 프로필 값을 쓴다. 요청의 잘못된 값은 거부하고, 프로필 값은 가능한 한 보정한다.
 */
@Component
@RequiredArgsConstructor
public class WorkoutConditionsResolver {

    private final ProfileRepository profileRepository;
    private final ProfileDetailsRepository profileDetailsRepository;

    public WorkoutConditions resolve(Long userId, RoutineRecommendRequest request,
                                     RecentWorkoutSummaryProvider.Summary recent) {
        Optional<ProfileDetails> details = profileRepository.findByUserId(userId)
            .flatMap(profile -> profileDetailsRepository.findById(profile.getId()));

        // 빠진 필수 조건은 모두 모아 한 번에 알려 준다 (어느 항목을 어디서 입력할지 사용자가 알 수 있게)
        List<String> missing = new ArrayList<>();

        Goal goal = request.goal() != null
            ? Goal.fromProfileValue(request.goal()).orElseThrow(() -> invalid("목표"))
            : details.map(ProfileDetails::getWorkoutGoal).flatMap(Goal::fromProfileValue).orElse(null);
        if (goal == null) {
            missing.add("운동 목표");
        }

        Level level = Level.fromProfileValue(request.level() != null
            ? request.level() : details.map(ProfileDetails::getWorkoutLevel).orElse(null));

        Integer days = request.daysPerWeek() != null
            ? request.daysPerWeek() : details.map(ProfileDetails::getDaysPerWeek).orElse(null);
        if (days == null) {
            missing.add("주당 운동 일수");
        } else if (days < 2 || days > 6) {
            throw invalid("주당 일수");
        }

        Integer minutes;
        if (request.sessionMinutes() != null) {
            if (!WorkoutConditions.ALLOWED_MINUTES.contains(request.sessionMinutes())) {
                throw invalid("회당 시간(15·30·45·60분)");
            }
            minutes = request.sessionMinutes();
        } else {
            minutes = details.map(ProfileDetails::getWorkoutMinutes).map(WorkoutConditionsResolver::floorMinutes)
                .orElse(null);
            if (minutes == null) {
                missing.add("회당 운동 시간");
            }
        }

        if (!missing.isEmpty()) {
            throw new BusinessException(ErrorCode.WORKOUT_CONDITIONS_MISSING, missingMessage(missing));
        }

        Set<Equipment> equipment = request.equipment() != null
            ? equipmentOf(request.equipment(), true)
            : equipmentOf(details.map(ProfileDetails::getEquipment).map(List::copyOf).orElse(List.of()), false);

        Collection<String> rawInjuries = request.injuries() != null
            ? request.injuries()
            : details.map(ProfileDetails::getInjuries).map(List::copyOf).orElse(List.of());
        Set<BodyArea> injuries = EnumSet.noneOf(BodyArea.class);
        boolean unknownInjury = false;
        for (String raw : rawInjuries) {
            if (raw == null || raw.isBlank()) {
                continue;
            }
            Optional<BodyArea> area = BodyArea.fromInput(raw);
            if (area.isPresent()) {
                injuries.add(area.get());
            } else {
                unknownInjury = true;
            }
        }

        return new WorkoutConditions(goal, level, days, minutes, equipment, injuries, unknownInjury,
            recent.skipRatio(), recent.logCount());
    }

    /**
     * 빠진 조건 안내 문구. 예) "운동 조건 중 주당 운동 일수가 비어 있어요. 내 설정 > 운동 목표 & 장비에서 입력해 주세요."
     * 조사(이/가)는 마지막 글자의 받침으로 고른다.
     */
    static String missingMessage(List<String> missing) {
        String items = String.join(", ", missing);
        char last = items.charAt(items.length() - 1);
        boolean batchim = last >= '가' && last <= '힣' && (last - '가') % 28 != 0;
        return "운동 조건 중 " + items + (batchim ? "이" : "가")
            + " 비어 있어요. 내 설정 > 운동 목표 & 장비에서 입력해 주세요.";
    }

    /** 프로필의 회당 시간(10–90분)을 허용 값 중 가까운 아래 값으로 내린다 (최소 15분, 설계 결정 D1). */
    static int floorMinutes(int minutes) {
        if (minutes >= 60) {
            return 60;
        }
        if (minutes >= 45) {
            return 45;
        }
        if (minutes >= 30) {
            return 30;
        }
        return 15;
    }

    private static Set<Equipment> equipmentOf(Collection<String> values, boolean strict) {
        Set<Equipment> owned = EnumSet.noneOf(Equipment.class);
        for (String value : values) {
            Optional<Set<Equipment>> mapped = Equipment.fromProfileValue(value);
            if (mapped.isPresent()) {
                owned.addAll(mapped.get());
            } else if (strict) {
                throw invalid("장비");
            }
        }
        return owned;
    }

    private static BusinessException invalid(String field) {
        return new BusinessException(ErrorCode.WORKOUT_INVALID_CONDITION,
            "허용하지 않는 운동 조건입니다: " + field);
    }
}
