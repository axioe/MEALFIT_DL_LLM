package com.mealfit.domain.workout.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.domain.workout.dto.RoutineResponse.DayResponse;
import com.mealfit.domain.workout.dto.RoutineResponse.ItemResponse;
import com.mealfit.domain.workout.dto.SessionAdjustRequest;
import com.mealfit.domain.workout.dto.SessionAdjustResponse;
import com.mealfit.domain.workout.entity.ExerciseCatalog;
import com.mealfit.domain.workout.entity.WorkoutRoutine;
import com.mealfit.domain.workout.entity.WorkoutSession;
import com.mealfit.domain.workout.model.AdjustRiskLevel;
import com.mealfit.domain.workout.model.BodyArea;
import com.mealfit.domain.workout.model.Equipment;
import com.mealfit.domain.workout.model.ExerciseDef;
import com.mealfit.domain.workout.model.Goal;
import com.mealfit.domain.workout.model.IntensityIntent;
import com.mealfit.domain.workout.model.Level;
import com.mealfit.domain.workout.model.Phase;
import com.mealfit.domain.workout.model.PlannedItem;
import com.mealfit.domain.workout.model.SessionAdjustment;
import com.mealfit.domain.workout.model.SessionFocus;
import com.mealfit.domain.workout.model.SessionPlan;
import com.mealfit.domain.workout.model.Violation;
import com.mealfit.domain.workout.model.WorkoutConditions;
import com.mealfit.domain.workout.model.WorkoutTime;
import com.mealfit.domain.workout.repository.ExerciseCatalogRepository;
import com.mealfit.domain.workout.repository.WorkoutRoutineRepository;
import com.mealfit.domain.workout.repository.WorkoutSessionRepository;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 문장 키워드 해석 기반 하루 운동 세션 조정 (FR-WORK-02, BR-17, D18).
 * - 위험 신호: 세션 변경 중단 + 즉시 119 연락 안내 + 오늘 운동 시작 버튼 차단(startBlocked=true)
 * - 질환·상태: 세션 미변경 + 의사 상담 안내
 * - 고강도 제한: 인접일 같은 부위 HIGH면 차단, 다른 부위면 허용하되 컨디션 저하 시 차단 + 주당·세션당 HIGH 상한 적용
 */
// [문장조정]
@Slf4j
@Service
@RequiredArgsConstructor
public class WorkoutSessionAdjustService {

    static final String NOTICE_EMERGENCY =
        "지금은 운동을 멈추고 쉬어 주세요. 즉시 의료기관(119)에 연락하거나 전문가의 진료를 받으세요.";
    static final String NOTICE_ALREADY_BLOCKED =
        "오늘 위험 신호가 감지되어 운동이 중단된 상태입니다. 오늘은 무리하지 말고 휴식해 주세요. 증상이 있으면 즉시 의료기관(119)에 연락하세요.";
    static final String NOTICE_UNDER_MIN_MINUTES =
        "운동 루틴은 최소 15분부터 조정할 수 있어요. 15·30·45·60분 단위로 다시 요청해 주세요.";
    static final String NOTICE_MEDICAL =
        "질환이나 몸 상태에 맞는 운동은 의사와 먼저 상담해 주세요. MealFit은 일반적인 운동만 제안해요.";
    static final String NOTICE_PAIN =
        "통증이 있으면 무리하지 마세요. 오늘은 %s 부담 운동을 뺐어요. 통증이 계속되면 전문가와 상담해 주세요.";
    static final String NOTICE_POOR_CONDITION =
        "컨디션이 좋지 않아 고강도 운동을 제외하고 강도를 조절했어요. 무리하지 말고 진행해 주세요.";
    static final String NOTICE_ADJACENT_HIGH_BLOCKED =
        "인접일에 같은 부위 고강도 운동이 있어 오늘은 중강도 이하로 조절했어요.";
    static final String NOTICE_WEEKLY_HIGH_LIMIT =
        "이번 주 고강도 세션 상한에 도달해 오늘은 중강도 이하로 조절했어요.";
    static final String NOTICE_NO_KEYWORD =
        "시간(예: 15분), 부위(예: 상체·하체·회복), 강도(예: 가볍게·강하게)나 불편한 부위를 포함해 입력해 주세요.";
    static final String NOTICE_VALIDATION_KEPT =
        "요청한 조건을 안전 기준 안에서 구성할 수 없어 기존 세션을 유지했어요.";

    private static final TypeReference<List<PlannedItem>> ITEMS_TYPE = new TypeReference<>() {
    };

    private final UserRepository userRepository;
    private final ExerciseCatalogRepository catalogRepository;
    private final WorkoutRoutineRepository routineRepository;
    private final WorkoutSessionRepository sessionRepository;
    private final KeywordInterpreter keywordInterpreter;
    private final SessionComposer sessionComposer;
    private final RoutineValidator validator;
    private final DefaultRoutineProvider defaultRoutineProvider;
    private final ObjectMapper objectMapper;

    @Transactional
    public SessionAdjustResponse adjust(Long userId, Long routineId, LocalDate sessionDate,
                                        SessionAdjustRequest request) {
        userRepository.findByIdForUpdate(userId)
            .orElseThrow(() -> new BusinessException(ErrorCode.UNAUTHORIZED));

        WorkoutRoutine routine = routineRepository.findByIdAndUserId(routineId, userId)
            .orElseThrow(() -> new BusinessException(ErrorCode.WORKOUT_ROUTINE_NOT_FOUND));
        WorkoutSession session = sessionRepository
            .findByRoutineIdAndUserIdAndSessionDateAndActiveKeyIsNotNull(routineId, userId, sessionDate)
            .orElseThrow(() -> new BusinessException(ErrorCode.WORKOUT_SESSION_NOT_FOUND));

        // 0. [문장조정] 이미 오늘 위험 신호로 차단된 세션은 이후 어떤 문장이 와도 당일 차단을 해제하지 않는다
        if (session.isStartBlocked()) {
            return new SessionAdjustResponse(
                routine.getId(), false, true, AdjustRiskLevel.EMERGENCY.name(),
                session.getAdjustNote(), List.of(NOTICE_ALREADY_BLOCKED), toDayResponse(session)
            );
        }

        SessionAdjustment adjustment = keywordInterpreter.interpret(request.prompt());

        // 1. 위험 신호: 세션은 유지하되 운동 시작 버튼 차단 표시를 저장하고 즉시 119 안내 반환
        if (adjustment.isEmergency()) {
            session.blockByEmergency(SessionAdjustment.EMERGENCY_NOTE);
            return new SessionAdjustResponse(
                routine.getId(), false, true, AdjustRiskLevel.EMERGENCY.name(),
                session.getAdjustNote(), List.of(NOTICE_EMERGENCY), toDayResponse(session)
            );
        }

        // 2. 질환·상태: 세션을 바꾸지 않고 의사 상담 안내만 반환
        if (adjustment.isMedical()) {
            return new SessionAdjustResponse(
                routine.getId(), false, session.isStartBlocked(), AdjustRiskLevel.MEDICAL.name(),
                adjustment.summaryNote(), List.of(NOTICE_MEDICAL), toDayResponse(session)
            );
        }

        // 2-1. [문장조정] 15분 미만 시간 요청은 15분으로 임의 증량하지 않고 기존 세션을 유지한다
        if (adjustment.underMinMinutes()) {
            return new SessionAdjustResponse(
                routine.getId(), false, session.isStartBlocked(), adjustment.riskLevel().name(),
                session.getAdjustNote(), List.of(NOTICE_UNDER_MIN_MINUTES), toDayResponse(session)
            );
        }

        // 3. 해석 가능한 키워드가 없으면 기존 세션 유지 + 안내
        if (!adjustment.hasActionableChange()) {
            return new SessionAdjustResponse(
                routine.getId(), false, session.isStartBlocked(), AdjustRiskLevel.NONE.name(),
                session.getAdjustNote(), List.of(NOTICE_NO_KEYWORD), toDayResponse(session)
            );
        }

        // 4. 조건 구성 (루틴 스냅샷 + 문장 조정 오버라이드)
        int targetMinutes = adjustment.sessionMinutes() != null
            ? adjustment.sessionMinutes()
            : routine.getSessionMinutes();
        SessionFocus targetFocus = adjustment.focus() != null
            ? adjustment.focus()
            : parseSessionFocus(session.getFocusArea());

        Set<Equipment> equipment = parseEquipment(routine.getEquipmentSnapshot());
        EnumSet<BodyArea> injuries = EnumSet.noneOf(BodyArea.class);
        injuries.addAll(parseBodyAreas(routine.getInjuriesSnapshot()));
        injuries.addAll(adjustment.excludedAreas());

        WorkoutConditions conditions = new WorkoutConditions(
            Goal.fromProfileValue(routine.getGoal()).orElse(Goal.MAINTAIN),
            Level.fromProfileValue(routine.getLevel()),
            routine.getDaysPerWeek(),
            targetMinutes,
            equipment,
            injuries,
            routine.isUnknownInjury(),
            0.0,
            0
        );

        List<ExerciseDef> catalog = catalogRepository.findAllActiveWithLoadAreas().stream()
            .map(ExerciseCatalog::toDef)
            .toList();
        Map<String, ExerciseDef> byCode = catalog.stream()
            .collect(Collectors.toMap(ExerciseDef::code, Function.identity()));

        // 5. 고강도(HIGH) 제한 판정 (같은 부위 연속 차단, 다른 부위 허용, 컨디션 저하 시 차단, 주간 상한 적용)
        HighPolicy highPolicy = evaluateHighPolicy(userId, sessionDate, targetFocus, conditions, adjustment, byCode);

        int rotation = Math.floorMod(
            RoutineTemplateGenerator.seedOf(userId, sessionDate) + sessionDate.getDayOfMonth(), 997
        );
        SessionPlan candidate = targetFocus == SessionFocus.RECOVERY
            ? defaultRoutineProvider.build(conditions, byCode, sessionDate)
            : sessionComposer.compose(conditions, catalog, sessionDate, targetFocus,
                highPolicy.intensityCap(), highPolicy.highAllowed(), rotation);

        SessionPlan validated = validateOrFallback(candidate, conditions, byCode, highPolicy.highAllowed(), sessionDate);
        if (validated == null) {
            return new SessionAdjustResponse(
                routine.getId(), false, session.isStartBlocked(), adjustment.riskLevel().name(),
                session.getAdjustNote(), List.of(NOTICE_VALIDATION_KEPT), toDayResponse(session)
            );
        }

        int plannedMinutes = WorkoutTime.sessionMinutes(validated, byCode);
        session.applyAdjustment(
            validated.focus().name(),
            validated.title(),
            plannedMinutes,
            writeItems(validated.items()),
            validated.source(),
            adjustment.summaryNote()
        );

        List<String> notices = buildNotices(adjustment, highPolicy, validated);
        return new SessionAdjustResponse(
            routine.getId(), true, false, adjustment.riskLevel().name(),
            session.getAdjustNote(), notices, toDayResponse(session)
        );
    }

    private HighPolicy evaluateHighPolicy(Long userId, LocalDate sessionDate, SessionFocus targetFocus,
                                          WorkoutConditions conditions, SessionAdjustment adjustment,
                                          Map<String, ExerciseDef> byCode) {
        int baseCap = conditions.intensityCap();

        if (targetFocus == SessionFocus.RECOVERY) {
            return new HighPolicy(1, 0, false, false, false);
        }
        if (adjustment.intensityIntent() == IntensityIntent.LIGHTER) {
            return new HighPolicy(Math.max(1, baseCap - 1), 0, false, false, false);
        }
        if (adjustment.poorCondition()) {
            // 컨디션 저하 시 다른 부위라도 고강도(3) 차단
            return new HighPolicy(Math.min(baseCap, 2), 0, true, false, false);
        }
        if (adjustment.riskLevel() == AdjustRiskLevel.PAIN) {
            return new HighPolicy(Math.min(baseCap, 2), 0, false, false, false);
        }

        // 같은 주(월~일) 활성 세션과 인접일(어제·내일) 고강도 배치 확인
        LocalDate monday = sessionDate.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate sunday = monday.plusDays(6);
        LocalDate queryFrom = sessionDate.minusDays(1).isBefore(monday) ? sessionDate.minusDays(1) : monday;
        LocalDate queryTo = sessionDate.plusDays(1).isAfter(sunday) ? sessionDate.plusDays(1) : sunday;

        List<WorkoutSession> nearbySessions = sessionRepository.findActiveBetween(userId, queryFrom, queryTo);
        int otherHighSessionsInWeek = 0;
        boolean adjacentSameFocusHigh = false;

        for (WorkoutSession other : nearbySessions) {
            if (other.getSessionDate().equals(sessionDate)) {
                continue;
            }
            if (!hasHighExercise(other, byCode)) {
                continue;
            }
            if (!other.getSessionDate().isBefore(monday) && !other.getSessionDate().isAfter(sunday)) {
                otherHighSessionsInWeek++;
            }
            boolean isAdjacent = other.getSessionDate().equals(sessionDate.minusDays(1))
                || other.getSessionDate().equals(sessionDate.plusDays(1));
            if (isAdjacent && isSameFocus(other.getFocusArea(), targetFocus)) {
                adjacentSameFocusHigh = true;
            }
        }

        boolean levelAllowsHigh = baseCap >= 3 && conditions.level().highPerSession() > 0;
        boolean weeklyLimitReached = otherHighSessionsInWeek >= conditions.level().highSessionsPerWeek();

        if (!levelAllowsHigh) {
            return new HighPolicy(baseCap, 0, false, false, false);
        }
        if (adjacentSameFocusHigh) {
            return new HighPolicy(2, 0, false, true, false);
        }
        if (weeklyLimitReached) {
            return new HighPolicy(2, 0, false, false, true);
        }
        return new HighPolicy(3, conditions.level().highPerSession(), false, false, false);
    }

    private SessionPlan validateOrFallback(SessionPlan candidate, WorkoutConditions conditions,
                                           Map<String, ExerciseDef> byCode, int highAllowed, LocalDate date) {
        if (passesValidation(candidate, conditions, byCode, highAllowed)) {
            return candidate;
        }
        log.info("조정 세션 검증 위반으로 기본 세션 대체: date={}", date);
        SessionPlan fallback = defaultRoutineProvider.build(conditions, byCode, date);
        if (passesValidation(fallback, conditions, byCode, highAllowed)) {
            return fallback;
        }
        return null;
    }

    private boolean passesValidation(SessionPlan plan, WorkoutConditions conditions,
                                     Map<String, ExerciseDef> byCode, int highAllowed) {
        List<Violation> violations = validator.validate(plan, conditions, byCode);
        if (!violations.isEmpty()) {
            return false;
        }
        long highCount = plan.itemsOf(Phase.MAIN).stream()
            .map(item -> byCode.get(item.code()))
            .filter(def -> def != null && def.isHigh())
            .count();
        return highCount <= highAllowed;
    }

    private boolean hasHighExercise(WorkoutSession session, Map<String, ExerciseDef> byCode) {
        return readItems(session.getItems()).stream()
            .filter(item -> item.phase() == Phase.MAIN)
            .map(item -> byCode.get(item.code()))
            .anyMatch(def -> def != null && def.isHigh());
    }

    private static boolean isSameFocus(String otherFocusArea, SessionFocus targetFocus) {
        return parseSessionFocus(otherFocusArea) == targetFocus;
    }

    private static List<String> buildNotices(SessionAdjustment adjustment, HighPolicy highPolicy,
                                             SessionPlan validated) {
        List<String> notices = new ArrayList<>();
        if (adjustment.riskLevel() == AdjustRiskLevel.PAIN && !adjustment.excludedAreas().isEmpty()) {
            String labels = adjustment.excludedAreas().stream()
                .map(BodyArea::label)
                .sorted()
                .collect(Collectors.joining("·"));
            notices.add(NOTICE_PAIN.formatted(labels));
        }
        if (highPolicy.blockedByPoorCondition()) {
            notices.add(NOTICE_POOR_CONDITION);
        }
        if (highPolicy.blockedByAdjacentSameFocus()) {
            notices.add(NOTICE_ADJACENT_HIGH_BLOCKED);
        } else if (highPolicy.blockedByWeeklyLimit()) {
            notices.add(NOTICE_WEEKLY_HIGH_LIMIT);
        }
        if (SessionPlan.SOURCE_DEFAULT.equals(validated.source())) {
            notices.add(WorkoutRoutineService.NOTICE_DEFAULT);
        }
        return notices;
    }

    private DayResponse toDayResponse(WorkoutSession session) {
        List<PlannedItem> items = readItems(session.getItems());
        String dayOfWeek = session.getSessionDate().getDayOfWeek().name().substring(0, 3);
        return new DayResponse(
            session.getSessionDate(),
            dayOfWeek,
            false,
            session.getId(),
            session.getFocusArea(),
            session.getTitle(),
            session.getPlannedMinutes(),
            session.getSource(),
            session.isAdjusted(),
            session.getAdjustNote(),
            session.isStartBlocked(),
            itemsOf(items, Phase.WARM_UP),
            itemsOf(items, Phase.MAIN),
            itemsOf(items, Phase.COOL_DOWN)
        );
    }

    private static List<ItemResponse> itemsOf(List<PlannedItem> items, Phase phase) {
        return items.stream()
            .filter(item -> item.phase() == phase)
            .map(item -> new ItemResponse(item.code(), item.name(), item.sets(), item.reps(), item.seconds(),
                item.restSeconds()))
            .toList();
    }

    private static SessionFocus parseSessionFocus(String value) {
        if (value == null || value.isBlank()) {
            return SessionFocus.FULL_BODY;
        }
        try {
            return SessionFocus.valueOf(value.trim());
        } catch (IllegalArgumentException e) {
            return SessionFocus.FULL_BODY;
        }
    }

    private static Set<Equipment> parseEquipment(String snapshot) {
        EnumSet<Equipment> result = EnumSet.of(Equipment.BODYWEIGHT);
        if (snapshot == null || snapshot.isBlank()) {
            return result;
        }
        Arrays.stream(snapshot.split(","))
            .map(String::trim)
            .filter(s -> !s.isEmpty())
            .forEach(name -> {
                try {
                    result.add(Equipment.valueOf(name));
                } catch (IllegalArgumentException ignored) {
                    // 알 수 없는 스냅샷 값은 무시
                }
            });
        return result;
    }

    private static Set<BodyArea> parseBodyAreas(String snapshot) {
        EnumSet<BodyArea> result = EnumSet.noneOf(BodyArea.class);
        if (snapshot == null || snapshot.isBlank()) {
            return result;
        }
        Arrays.stream(snapshot.split(","))
            .map(String::trim)
            .filter(s -> !s.isEmpty())
            .forEach(name -> {
                try {
                    result.add(BodyArea.valueOf(name));
                } catch (IllegalArgumentException ignored) {
                    // 알 수 없는 스냅샷 값은 무시
                }
            });
        return result;
    }

    private String writeItems(List<PlannedItem> items) {
        try {
            return objectMapper.writeValueAsString(items);
        } catch (JsonProcessingException e) {
            throw new IllegalStateException("운동 목록을 저장 형식으로 바꾸지 못했습니다.", e);
        }
    }

    private List<PlannedItem> readItems(String json) {
        try {
            return objectMapper.readValue(json, ITEMS_TYPE);
        } catch (JsonProcessingException e) {
            throw new IllegalStateException("저장된 운동 목록을 읽지 못했습니다.", e);
        }
    }

    private record HighPolicy(
        int intensityCap,
        int highAllowed,
        boolean blockedByPoorCondition,
        boolean blockedByAdjacentSameFocus,
        boolean blockedByWeeklyLimit
    ) {
    }
}
