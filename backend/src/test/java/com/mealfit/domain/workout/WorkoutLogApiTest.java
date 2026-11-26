package com.mealfit.domain.workout;

import static com.mealfit.support.TestJwt.user;
import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.domain.workout.entity.WorkoutLog;
import com.mealfit.domain.workout.entity.WorkoutLogStatus;
import com.mealfit.domain.workout.entity.WorkoutRoutine;
import com.mealfit.domain.workout.entity.WorkoutSession;
import com.mealfit.domain.workout.repository.WorkoutLogRepository;
import com.mealfit.domain.workout.repository.WorkoutRoutineRepository;
import com.mealfit.domain.workout.repository.WorkoutSessionRepository;
import com.mealfit.domain.workout.service.RecentWorkoutSummaryProvider;
import com.mealfit.support.TestUserFixture;
import jakarta.persistence.EntityManager;
import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.TemporalAdjusters;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.transaction.annotation.Transactional;

/** 운동 완료 기록·주간 현황·D4 강도 연동·재추천 기록 보호 통합 테스트 (FR-WORK-03·04, BR-18). */
// [운동기록]
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class WorkoutLogApiTest {

    private static final long USER = 85001L;
    private static final long OTHER = 85002L;
    private static final String LOG_PATH = "/api/v1/workout-logs";
    private static final String ROUTINE_PATH = "/api/v1/workout-routines";
    private static final ZoneId ZONE = ZoneId.of("Asia/Seoul");
    private static final LocalDate TODAY = LocalDate.now(ZONE);

    @Autowired MockMvc mvc;
    @Autowired ObjectMapper mapper;
    @Autowired JdbcTemplate jdbc;
    @Autowired EntityManager em;
    @Autowired WorkoutRoutineRepository routineRepository;
    @Autowired WorkoutSessionRepository sessionRepository;
    @Autowired WorkoutLogRepository logRepository;
    @Autowired RecentWorkoutSummaryProvider recentSummaryProvider;

    @BeforeEach
    void prepareUsers() {
        TestUserFixture.create(jdbc, USER);
        TestUserFixture.create(jdbc, OTHER);
    }

    private WorkoutRoutine createManualRoutine(long userId, LocalDate startDate) {
        return routineRepository.save(WorkoutRoutine.builder()
            .userId(userId)
            .goal("hypertrophy")
            .level("intermediate")
            .daysPerWeek(3)
            .sessionMinutes(30)
            .equipmentSnapshot("BODYWEIGHT,DUMBBELL")
            .injuriesSnapshot("")
            .unknownInjury(false)
            .intensityCap(3)
            .source("RULE")
            .ruleVersion("wr-1.0")
            .startDate(startDate)
            .plannedUntil(startDate.plusDays(13))
            .build());
    }

    private WorkoutSession createSession(long userId, long routineId, LocalDate date, String focus, int plannedMinutes) {
        return sessionRepository.save(WorkoutSession.builder()
            .routineId(routineId)
            .userId(userId)
            .sessionDate(date)
            .focusArea(focus)
            .title(focus + " " + plannedMinutes + "분")
            .plannedMinutes(plannedMinutes)
            .items("[{\"phase\":\"MAIN\",\"code\":\"BW_SQUAT\",\"name\":\"맨몸 스쿼트\",\"sets\":3,\"reps\":12,\"seconds\":null,\"restSeconds\":60}]")
            .source("RULE")
            .build());
    }

    private ResultActions record(long userId, Map<String, Object> body) throws Exception {
        return mvc.perform(post(LOG_PATH).with(user(userId))
            .contentType(MediaType.APPLICATION_JSON)
            .content(mapper.writeValueAsString(body)));
    }

    @Test
    void 완료기록_저장_정정_중량kg저장_및_주간현황집계가_정확히_동작한다() throws Exception {
        LocalDate monday = TODAY.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        WorkoutRoutine routine = createManualRoutine(USER, monday);
        WorkoutSession todaySession = createSession(USER, routine.getId(), TODAY, "UPPER", 30);
        WorkoutSession pastSession = createSession(USER, routine.getId(), TODAY.minusDays(1), "LOWER", 25);

        // 1) COMPLETED(시간 미입력 시 예정 시간 30분 자동 채움) + 중량 42.50kg 저장
        Map<String, Object> body1 = new HashMap<>();
        body1.put("sessionId", todaySession.getId());
        body1.put("status", "COMPLETED");
        body1.put("weightKg", new BigDecimal("42.50"));

        record(USER, body1)
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.sessionId").value(todaySession.getId()))
            .andExpect(jsonPath("$.status").value("COMPLETED"))
            .andExpect(jsonPath("$.actualMinutes").value(30))
            .andExpect(jsonPath("$.weightKg").value(42.5));

        // 2) 같은 세션 PARTIAL로 정정 (중복 행 생성 없이 1건 유지)
        record(USER, Map.of("sessionId", todaySession.getId(), "status", "PARTIAL", "actualMinutes", 18, "weightKg", 40.0))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("PARTIAL"))
            .andExpect(jsonPath("$.actualMinutes").value(18));

        // 3) 다시 COMPLETED로 정정
        record(USER, Map.of("sessionId", todaySession.getId(), "status", "COMPLETED", "actualMinutes", 32))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("COMPLETED"))
            .andExpect(jsonPath("$.actualMinutes").value(32));

        // 과거 세션은 SKIPPED(0분) 기록
        record(USER, Map.of("sessionId", pastSession.getId(), "status", "SKIPPED"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("SKIPPED"))
            .andExpect(jsonPath("$.actualMinutes").value(0));

        // 기간 조회: 본인 기록 2건만 존재
        mvc.perform(get(LOG_PATH)
                .param("from", TODAY.minusDays(7).toString())
                .param("to", TODAY.toString())
                .with(user(USER)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.length()").value(2));

        // 주간 현황 집계 확인 (TODAY가 월요일이면 pastSession은 전주이므로 todaySession 1건만 이번 주)
        String summaryJson = mvc.perform(get(LOG_PATH + "/summary")
                .param("week", TODAY.toString())
                .with(user(USER)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.completedCount").value(1))
            .andExpect(jsonPath("$.totalActualMinutes").value(32))
            .andReturn().getResponse().getContentAsString();
        JsonNode summary = mapper.readTree(summaryJson);
        assertThat(summary.get("plannedSessions").asInt()).isGreaterThanOrEqualTo(1);
    }

    @Test
    void 미래세션_위험차단세션_잘못된시간_타인세션은_거절한다() throws Exception {
        WorkoutRoutine routine = createManualRoutine(USER, TODAY);
        WorkoutSession futureSession = createSession(USER, routine.getId(), TODAY.plusDays(2), "LOWER", 30);
        WorkoutSession blockedSession = createSession(USER, routine.getId(), TODAY, "UPPER", 30);

        // 위험 신호로 오늘 세션 차단
        mvc.perform(patch(ROUTINE_PATH + "/" + routine.getId() + "/sessions/" + TODAY).with(user(USER))
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("prompt", "가슴 통증이 있고 숨이 안 쉬어져"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.startBlocked").value(true));

        // 미래 날짜 세션 완료 시도 -> 400 WORKOUT_006
        record(USER, Map.of("sessionId", futureSession.getId(), "status", "COMPLETED", "actualMinutes", 30))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("WORKOUT_006"));

        // 위험 차단 세션 COMPLETED 시도 -> 409 WORKOUT_007
        record(USER, Map.of("sessionId", blockedSession.getId(), "status", "COMPLETED", "actualMinutes", 20))
            .andExpect(status().isConflict())
            .andExpect(jsonPath("$.code").value("WORKOUT_007"));

        // 위험 차단 세션 SKIPPED는 허용 -> 200
        record(USER, Map.of("sessionId", blockedSession.getId(), "status", "SKIPPED"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("SKIPPED"));

        // SKIPPED에 actualMinutes > 0 -> 400 WORKOUT_008
        record(USER, Map.of("sessionId", blockedSession.getId(), "status", "SKIPPED", "actualMinutes", 10))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("WORKOUT_008"));

        // 타인 세션 기록 시도 -> 404 WORKOUT_004
        record(OTHER, blockedSession.getId(), "SKIPPED");
    }

    private void record(long userId, Long sessionId, String status) throws Exception {
        record(userId, Map.of("sessionId", sessionId, "status", status))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.code").value("WORKOUT_004"));
    }

    @Test
    void 루틴을_다시받아도_이미_기록한_세션은_유지되고_최근건너뜀이_많으면_D4가_강도를_낮춘다() throws Exception {
        // 프로필 설정: intermediate (기본 강도 상한 3)
        Map<String, Object> fitness = Map.of(
            "workoutGoal", "hypertrophy",
            "workoutLevel", "intermediate",
            "workoutMinutes", 30,
            "daysPerWeek", 6,
            "equipment", List.of("dumbbell"),
            "injuries", List.of()
        );
        mvc.perform(put("/api/v1/me/profile/details/fitness").with(user(USER))
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(fitness)))
            .andExpect(status().isOk());

        // 최근 14일 내 SKIPPED 2건 저장 (logCount=2, skipRatio=1.0 -> D4로 강도 상한 3 -> 2)
        WorkoutRoutine oldRoutine = createManualRoutine(USER, TODAY.minusDays(5));
        WorkoutSession s1 = createSession(USER, oldRoutine.getId(), TODAY.minusDays(3), "UPPER", 30);
        WorkoutSession s2 = createSession(USER, oldRoutine.getId(), TODAY.minusDays(1), "LOWER", 30);
        WorkoutSession todayLogged = createSession(USER, oldRoutine.getId(), TODAY, "FULL_BODY", 30);

        LocalDateTime now = LocalDateTime.now(ZONE);
        logRepository.save(WorkoutLog.create(USER, s1, WorkoutLogStatus.SKIPPED, 0, null, now));
        logRepository.save(WorkoutLog.create(USER, s2, WorkoutLogStatus.SKIPPED, 0, null, now));
        logRepository.save(WorkoutLog.create(USER, todayLogged, WorkoutLogStatus.COMPLETED, 30, null, now));
        em.flush();

        // D4 요약 검증: 최근 14일 3건 중 2건 SKIPPED (66.7% >= 50%)
        RecentWorkoutSummaryProvider.Summary summary = recentSummaryProvider.summarize(USER, TODAY);
        assertThat(summary.logCount()).isEqualTo(3);
        assertThat(summary.skippedCount()).isEqualTo(2);
        assertThat(summary.skipRatio()).isGreaterThanOrEqualTo(0.5);

        // 오늘 시작일로 새 루틴 재추천 -> 오늘 기록된 세션(todayLogged)이 보호되어야 한다
        String routineJson = mvc.perform(post(ROUTINE_PATH + "/recommend").with(user(USER))
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("startDate", TODAY.toString()))))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();
        JsonNode newRoutine = mapper.readTree(routineJson);

        // 오늘 날짜의 세션 ID가 기존에 완료 기록한 todayLogged 그대로 유지됨
        Long todaySessionIdInResponse = null;
        for (JsonNode day : newRoutine.get("days")) {
            if (TODAY.toString().equals(day.get("date").asText()) && day.hasNonNull("sessionId")) {
                todaySessionIdInResponse = day.get("sessionId").asLong();
            }
        }
        assertThat(todaySessionIdInResponse).isEqualTo(todayLogged.getId());

        // 새 루틴의 intensityCap이 D4로 인해 3 -> 2로 낮아졌는지 DB 확인
        WorkoutRoutine savedNewRoutine = routineRepository.findById(newRoutine.get("routineId").asLong()).orElseThrow();
        assertThat(savedNewRoutine.getIntensityCap()).isEqualTo(2);
    }
}
