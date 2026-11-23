package com.mealfit.domain.workout.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.domain.workout.dto.RoutineRecommendRequest;
import com.mealfit.domain.workout.dto.RoutineResponse;
import com.mealfit.domain.workout.dto.RoutineResponse.DayResponse;
import com.mealfit.domain.workout.dto.RoutineResponse.ItemResponse;
import com.mealfit.domain.workout.entity.ExerciseCatalog;
import com.mealfit.domain.workout.entity.RoutineStatus;
import com.mealfit.domain.workout.entity.WorkoutRoutine;
import com.mealfit.domain.workout.entity.WorkoutSession;
import com.mealfit.domain.workout.model.BodyArea;
import com.mealfit.domain.workout.model.Equipment;
import com.mealfit.domain.workout.model.ExerciseDef;
import com.mealfit.domain.workout.model.Phase;
import com.mealfit.domain.workout.model.PlannedItem;
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
import java.time.ZoneId;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 운동 루틴 생성·조회 (FR-WORK-01, BR-17, 설계 9장). 운동 조건과 부상 정보는 AI 서비스로 보내지 않는다 (NFR-SEC-04).
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class WorkoutRoutineService {

    static final ZoneId ZONE = ZoneId.of("Asia/Seoul");

    static final String DISCLAIMER = "MealFit 운동 루틴은 일반적인 운동 제안이며, 의학적 진단이나 치료를 대신하지 않습니다.";
    static final String NOTICE_INJURY = "%s 부담이 큰 운동을 빼고 구성했어요. 운동 중 통증이 생기면 바로 멈추고, "
        + "계속되면 의사나 물리치료사와 상담해 주세요.";
    static final String NOTICE_UNKNOWN_INJURY = "입력한 몸 상태를 정확히 알 수 없어 가장 가벼운 강도로 구성했어요. "
        + "통증이나 질환이 있으면 운동 전에 의사나 물리치료사와 상담해 주세요.";
    static final String NOTICE_DEFAULT = "선택한 조건(장비·시간·몸 상태)에 맞는 운동이 부족해 기본 루틴을 보여 드려요. "
        + "조건을 바꾸면 다시 받을 수 있어요.";

    private static final TypeReference<List<PlannedItem>> ITEMS_TYPE = new TypeReference<>() {
    };

    private final UserRepository userRepository;
    private final ExerciseCatalogRepository catalogRepository;
    private final WorkoutRoutineRepository routineRepository;
    private final WorkoutSessionRepository sessionRepository;
    private final WorkoutConditionsResolver conditionsResolver;
    private final RoutineTemplateGenerator generator;
    private final RoutineValidator validator;
    private final DefaultRoutineProvider defaultRoutineProvider;
    private final Optional<RecentWorkoutSummaryProvider> recentSummaryProvider;
    private final ObjectMapper objectMapper;

    @Transactional
    public RoutineResponse recommend(Long userId, RoutineRecommendRequest request) {
        RoutineRecommendRequest safeRequest = request == null ? RoutineRecommendRequest.empty() : request;
        LocalDate today = LocalDate.now(ZONE);
        LocalDate startDate = safeRequest.startDate() == null ? today : safeRequest.startDate();
        if (startDate.isBefore(today)) {
            throw new BusinessException(ErrorCode.WORKOUT_INVALID_CONDITION, "지난 날짜로는 루틴을 만들 수 없습니다.");
        }

        // 같은 회원의 동시 요청을 줄 세운다 (인증 코드와 같은 잠금 순서: 회원 먼저).
        userRepository.findByIdForUpdate(userId)
            .orElseThrow(() -> new BusinessException(ErrorCode.UNAUTHORIZED));

        RecentWorkoutSummaryProvider.Summary recent = recentSummaryProvider
            .map(provider -> provider.summarize(userId, today))
            .orElse(RecentWorkoutSummaryProvider.Summary.EMPTY);
        WorkoutConditions conditions = conditionsResolver.resolve(userId, safeRequest, recent);

        List<ExerciseDef> catalog = loadCatalog();
        Map<String, ExerciseDef> byCode = catalog.stream()
            .collect(Collectors.toMap(ExerciseDef::code, Function.identity()));

        List<SessionPlan> plans = new ArrayList<>();
        for (SessionPlan plan : generator.generate(conditions, catalog, startDate,
                RoutineTemplateGenerator.seedOf(userId, startDate))) {
            plans.add(validated(plan, conditions, byCode));
        }

        // 기존 루틴은 교체 상태로 바꾸고, 시작일 이후의 활성 세션만 비활성화한다. 지난 세션은 그대로 둔다.
        // TODO(workout_logs 추가 후): 기록이 있는 세션은 비활성화하지 않고 새 루틴에서 그 날짜를 건너뛴다.
        routineRepository.findByUserIdAndStatus(userId, RoutineStatus.ACTIVE).forEach(WorkoutRoutine::replace);
        sessionRepository.findActiveFrom(userId, startDate).forEach(WorkoutSession::deactivate);
        sessionRepository.flush();

        boolean allDefault = !plans.isEmpty()
            && plans.stream().allMatch(plan -> SessionPlan.SOURCE_DEFAULT.equals(plan.source()));
        WorkoutRoutine routine = routineRepository.save(WorkoutRoutine.builder()
            .userId(userId)
            .goal(conditions.goal().profileValue())
            .level(conditions.level().profileValue())
            .daysPerWeek(conditions.daysPerWeek())
            .sessionMinutes(conditions.sessionMinutes())
            .equipmentSnapshot(joinNames(conditions.equipment().stream().map(Equipment::name).sorted().toList()))
            .injuriesSnapshot(joinNames(conditions.injuries().stream().map(BodyArea::name).sorted().toList()))
            .unknownInjury(conditions.unknownInjury())
            .intensityCap(conditions.intensityCap())
            .source(allDefault ? SessionPlan.SOURCE_DEFAULT : SessionPlan.SOURCE_RULE)
            .ruleVersion(RoutineTemplateGenerator.RULE_VERSION)
            .startDate(startDate)
            .plannedUntil(RoutineTemplateGenerator.plannedUntil(startDate))
            .build());

        List<WorkoutSession> sessions = plans.stream()
            .map(plan -> WorkoutSession.builder()
                .routineId(routine.getId())
                .userId(userId)
                .sessionDate(plan.date())
                .focusArea(plan.focus().name())
                .title(plan.title())
                .plannedMinutes(WorkoutTime.sessionMinutes(plan, byCode))
                .items(writeItems(plan.items()))
                .source(plan.source())
                .build())
            .toList();
        try {
            sessionRepository.saveAllAndFlush(sessions);
        } catch (DataIntegrityViolationException e) {
            throw new BusinessException(ErrorCode.WORKOUT_CONCURRENT_REQUEST);
        }

        return weekResponse(userId, startDate, Optional.of(routine));
    }

    /** 조회한 주(월–일)의 루틴 (설계 8.2). 활성 루틴이 없으면 "루틴 없음" 응답이다. */
    @Transactional(readOnly = true)
    public RoutineResponse current(Long userId, LocalDate week) {
        LocalDate date = week == null ? LocalDate.now(ZONE) : week;
        return weekResponse(userId, date,
            routineRepository.findFirstByUserIdAndStatusOrderByIdDesc(userId, RoutineStatus.ACTIVE));
    }

    /** 생성기 결과를 검증하고, 위반한 세션만 기본 세션으로 바꾼다 (TRD AI-03, BR-17). */
    private SessionPlan validated(SessionPlan plan, WorkoutConditions conditions, Map<String, ExerciseDef> byCode) {
        List<Violation> violations = validator.validate(plan, conditions, byCode);
        if (violations.isEmpty()) {
            return plan;
        }
        log.info("운동 세션 검증 위반으로 기본 세션 대체: date={}, violations={}", plan.date(),
            violations.stream().map(v -> v.type() + ":" + v.exerciseCode()).toList());
        SessionPlan fallback = defaultRoutineProvider.build(conditions, byCode, plan.date());
        List<Violation> again = validator.validate(fallback, conditions, byCode);
        if (!again.isEmpty()) {
            log.error("기본 세션도 검증을 통과하지 못함: violations={}", again);
            throw new BusinessException(ErrorCode.INTERNAL_ERROR);
        }
        return fallback;
    }

    private List<ExerciseDef> loadCatalog() {
        return catalogRepository.findAllActiveWithLoadAreas().stream().map(ExerciseCatalog::toDef).toList();
    }

    private RoutineResponse weekResponse(Long userId, LocalDate anyDayOfWeek, Optional<WorkoutRoutine> routine) {
        LocalDate monday = anyDayOfWeek.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate sunday = monday.plusDays(6);
        Map<LocalDate, WorkoutSession> sessions = sessionRepository.findActiveBetween(userId, monday, sunday)
            .stream().collect(Collectors.toMap(WorkoutSession::getSessionDate, Function.identity()));

        List<DayResponse> days = new ArrayList<>();
        for (LocalDate date = monday; !date.isAfter(sunday); date = date.plusDays(1)) {
            WorkoutSession session = sessions.get(date);
            String dayOfWeek = date.getDayOfWeek().name().substring(0, 3);
            if (session == null) {
                LocalDate day = date;
                boolean rest = routine.map(r -> r.covers(day)).orElse(false);
                days.add(new DayResponse(date, dayOfWeek, rest, null, null, null, null, null, null,
                    null, null, null));
                continue;
            }
            List<PlannedItem> items = readItems(session.getItems());
            days.add(new DayResponse(date, dayOfWeek, false, session.getId(), session.getFocusArea(),
                session.getTitle(), session.getPlannedMinutes(), session.getSource(), session.isAdjusted(),
                itemsOf(items, Phase.WARM_UP), itemsOf(items, Phase.MAIN), itemsOf(items, Phase.COOL_DOWN)));
        }

        if (routine.isEmpty()) {
            return new RoutineResponse(null, null, null, null, null, null, null, null, null, DISCLAIMER,
                List.of(), days);
        }
        WorkoutRoutine r = routine.get();
        boolean anyDefault = sessions.values().stream()
            .anyMatch(session -> SessionPlan.SOURCE_DEFAULT.equals(session.getSource()));
        return new RoutineResponse(r.getId(), r.getGoal(), r.getLevel(), r.getDaysPerWeek(), r.getSessionMinutes(),
            r.getSource(), r.getRuleVersion(), r.getStartDate(), r.getPlannedUntil(), DISCLAIMER,
            notices(r, anyDefault), days);
    }

    private static List<String> notices(WorkoutRoutine routine, boolean anyDefault) {
        List<String> notices = new ArrayList<>();
        List<String> labels = splitNames(routine.getInjuriesSnapshot()).stream()
            .map(name -> BodyArea.valueOf(name).label())
            .toList();
        if (!labels.isEmpty()) {
            notices.add(NOTICE_INJURY.formatted(String.join("·", labels)));
        }
        if (routine.isUnknownInjury()) {
            notices.add(NOTICE_UNKNOWN_INJURY);
        }
        if (anyDefault) {
            notices.add(NOTICE_DEFAULT);
        }
        return notices;
    }

    private static List<ItemResponse> itemsOf(List<PlannedItem> items, Phase phase) {
        return items.stream()
            .filter(item -> item.phase() == phase)
            .map(item -> new ItemResponse(item.code(), item.name(), item.sets(), item.reps(), item.seconds(),
                item.restSeconds()))
            .toList();
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

    private static String joinNames(List<String> names) {
        return String.join(",", names);
    }

    private static List<String> splitNames(String joined) {
        if (joined == null || joined.isBlank()) {
            return List.of();
        }
        return Arrays.stream(joined.split(",")).map(String::trim).filter(s -> !s.isEmpty()).toList();
    }
}
