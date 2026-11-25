package com.mealfit.domain.workout;

import static com.mealfit.support.TestJwt.user;
import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assumptions.assumeTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.support.TestUserFixture;
import jakarta.persistence.EntityManager;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
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

/** 문장 키워드 해석 조정 API 통합 테스트 (FR-WORK-02, QA-27, D18). */
// [문장조정]
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class WorkoutSessionAdjustApiTest {

    private static final long USER = 83001L;
    private static final long OTHER = 83002L;
    private static final String PATH = "/api/v1/workout-routines";
    private static final LocalDate NEXT_MONDAY = LocalDate.now(ZoneId.of("Asia/Seoul"))
        .with(TemporalAdjusters.next(DayOfWeek.MONDAY));

    @Autowired MockMvc mvc;
    @Autowired ObjectMapper mapper;
    @Autowired JdbcTemplate jdbc;
    @Autowired EntityManager em;

    @BeforeEach
    void prepareUsers() {
        TestUserFixture.create(jdbc, USER);
        TestUserFixture.create(jdbc, OTHER);
    }

    private JsonNode createRoutine(long userId, String level, int days, int minutes, List<String> equipment)
            throws Exception {
        return createRoutine(userId, level, days, minutes, equipment, NEXT_MONDAY);
    }

    private JsonNode createRoutine(long userId, String level, int days, int minutes, List<String> equipment,
                                   LocalDate startDate) throws Exception {
        // 수준을 프로필에 먼저 저장
        Map<String, Object> fitness = new HashMap<>(Map.of(
            "workoutGoal", "hypertrophy",
            "workoutLevel", level,
            "workoutMinutes", minutes,
            "daysPerWeek", days,
            "equipment", equipment,
            "injuries", List.of()
        ));
        mvc.perform(put("/api/v1/me/profile/details/fitness").with(user(userId))
                .contentType(MediaType.APPLICATION_JSON).content(mapper.writeValueAsString(fitness)))
            .andExpect(status().isOk());

        Map<String, Object> body = Map.of(
            "goal", "hypertrophy",
            "daysPerWeek", days,
            "sessionMinutes", minutes,
            "equipment", equipment,
            "injuries", List.of(),
            "startDate", startDate.toString()
        );
        String json = mvc.perform(post(PATH + "/recommend").with(user(userId))
                .contentType(MediaType.APPLICATION_JSON).content(mapper.writeValueAsString(body)))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();
        return mapper.readTree(json);
    }

    private ResultActions adjust(long userId, long routineId, LocalDate date, String prompt) throws Exception {
        return mvc.perform(patch(PATH + "/" + routineId + "/sessions/" + date).with(user(userId))
            .contentType(MediaType.APPLICATION_JSON)
            .content(mapper.writeValueAsString(Map.of("prompt", prompt))));
    }

    private Set<String> loadAreasOf(String code) {
        return Set.copyOf(jdbc.queryForList("""
            select la.body_area from exercise_catalog_load_areas la
            join exercise_catalog ec on ec.id = la.exercise_id
            where ec.code = ?
            """, String.class, code));
    }

    private int intensityOf(String code) {
        Integer v = jdbc.queryForObject(
            "select intensity from exercise_catalog where code = ?", Integer.class, code);
        return v == null ? 0 : v;
    }

    private List<String> mainCodes(JsonNode day) {
        List<String> codes = new ArrayList<>();
        day.get("exercises").forEach(item -> codes.add(item.get("code").asText()));
        return codes;
    }

    @Test
    void QA27_15분만_가능해_조정시_세션시간이_15분이하로_재구성된다() throws Exception {
        JsonNode routine = createRoutine(USER, "beginner", 3, 45, List.of("dumbbell"));
        long routineId = routine.get("routineId").asLong();

        String resJson = adjust(USER, routineId, NEXT_MONDAY, "오늘은 15분만 가능해")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.adjusted").value(true))
            .andExpect(jsonPath("$.startBlocked").value(false))
            .andExpect(jsonPath("$.riskLevel").value("NONE"))
            .andReturn().getResponse().getContentAsString();
        JsonNode res = mapper.readTree(resJson);
        assertThat(res.get("day").get("durationMinutes").asInt()).isLessThanOrEqualTo(15);
        assertThat(res.get("day").get("adjusted").asBoolean()).isTrue();
        assertThat(res.get("adjustNote").asText()).contains("시간:15분");
    }

    @Test
    void 통증부위_문장조정시_해당부위_부담운동을_제외하고_안내를_반환한다() throws Exception {
        JsonNode routine = createRoutine(USER, "beginner", 3, 30, List.of("dumbbell"));
        long routineId = routine.get("routineId").asLong();

        String resJson = adjust(USER, routineId, NEXT_MONDAY, "무릎이 좀 아파서 가볍게 할래")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.adjusted").value(true))
            .andExpect(jsonPath("$.riskLevel").value("PAIN"))
            .andReturn().getResponse().getContentAsString();
        JsonNode res = mapper.readTree(resJson);
        assertThat(res.get("notices").toString()).contains("무릎");
        for (String phase : List.of("warmUp", "exercises", "coolDown")) {
            for (JsonNode item : res.get("day").get(phase)) {
                assertThat(loadAreasOf(item.get("code").asText())).doesNotContain("KNEE");
            }
        }
    }

    @Test
    void 위험신호_감지시_세션을_변경하지않고_운동시작을_차단하며_재조회에서도_유지된다() throws Exception {
        JsonNode routine = createRoutine(USER, "beginner", 3, 30, List.of("none"));
        long routineId = routine.get("routineId").asLong();
        List<String> beforeCodes = mainCodes(routine.get("days").get(0));

        String resJson = adjust(USER, routineId, NEXT_MONDAY, "가슴이 답답하고 숨이 안 쉬어져")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.adjusted").value(false))
            .andExpect(jsonPath("$.startBlocked").value(true))
            .andExpect(jsonPath("$.riskLevel").value("EMERGENCY"))
            .andReturn().getResponse().getContentAsString();
        JsonNode res = mapper.readTree(resJson);
        assertThat(res.get("notices").toString()).contains("119");
        assertThat(mainCodes(res.get("day"))).isEqualTo(beforeCodes);

        // 현재 루틴 재조회(새로고침) 시에도 해당 날짜 startBlocked=true가 유지되어야 한다
        mvc.perform(get(PATH + "/current").param("week", NEXT_MONDAY.toString()).with(user(USER)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.days[0].startBlocked").value(true));

        // [문장조정] 당일 위험 신호 차단 이후 일반 문장("15분만")으로 다시 요청해도 차단이 풀리지 않는다
        String retryJson = adjust(USER, routineId, NEXT_MONDAY, "괜찮아졌어 15분만 할래")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.adjusted").value(false))
            .andExpect(jsonPath("$.startBlocked").value(true))
            .andExpect(jsonPath("$.riskLevel").value("EMERGENCY"))
            .andReturn().getResponse().getContentAsString();
        JsonNode retry = mapper.readTree(retryJson);
        assertThat(mainCodes(retry.get("day"))).isEqualTo(beforeCodes);
    }

    @Test
    void 오늘_위험신호로_차단된_뒤_같은날_루틴을_다시_받아도_오늘_차단이_유지된다() throws Exception {
        LocalDate today = LocalDate.now(ZoneId.of("Asia/Seoul"));
        // 주 6일 루틴은 월–토에 세션이 있다. 일요일에는 오늘 세션이 없어 차단할 대상이 없다.
        assumeTrue(today.getDayOfWeek() != DayOfWeek.SUNDAY, "일요일에는 오늘 운동 세션이 없음");

        JsonNode routine = createRoutine(USER, "beginner", 6, 30, List.of("none"), today);
        long routineId = routine.get("routineId").asLong();
        adjust(USER, routineId, today, "가슴이 답답하고 숨이 안 쉬어져")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.startBlocked").value(true));

        // 같은 날 루틴 재추천: 새로 생긴 오늘 세션도 차단 상태여야 한다
        JsonNode again = createRoutine(USER, "beginner", 6, 30, List.of("none"), today);
        long newRoutineId = again.get("routineId").asLong();
        assertThat(newRoutineId).isNotEqualTo(routineId);
        assertThat(dayOf(again, today).get("startBlocked").asBoolean()).isTrue();

        String currentJson = mvc.perform(get(PATH + "/current").param("week", today.toString()).with(user(USER)))
            .andExpect(status().isOk())
            .andReturn().getResponse().getContentAsString();
        assertThat(dayOf(mapper.readTree(currentJson), today).get("startBlocked").asBoolean()).isTrue();

        // 새 루틴에 일반 문장으로 조정해도 차단이 풀리지 않는다
        adjust(USER, newRoutineId, today, "괜찮아졌어 15분만 할래")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.adjusted").value(false))
            .andExpect(jsonPath("$.startBlocked").value(true))
            .andExpect(jsonPath("$.riskLevel").value("EMERGENCY"));

        // 한 번 더 재추천해도(이전 세션이 모두 비활성이어도) 오늘 차단이 이어진다
        JsonNode third = createRoutine(USER, "beginner", 6, 30, List.of("none"), today);
        assertThat(dayOf(third, today).get("startBlocked").asBoolean()).isTrue();
    }

    @Test
    void 미래_날짜의_위험신호_차단은_루틴을_다시_받으면_이어가지_않는다() throws Exception {
        JsonNode routine = createRoutine(USER, "beginner", 3, 30, List.of("none"));
        long routineId = routine.get("routineId").asLong();
        adjust(USER, routineId, NEXT_MONDAY, "가슴이 답답하고 숨이 안 쉬어져")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.startBlocked").value(true));

        // 차단은 오늘 날짜만 이어 간다 (2026-11-25 결정)
        JsonNode again = createRoutine(USER, "beginner", 3, 30, List.of("none"));
        assertThat(dayOf(again, NEXT_MONDAY).get("startBlocked").asBoolean()).isFalse();
    }

    private static JsonNode dayOf(JsonNode routine, LocalDate date) {
        for (JsonNode day : routine.get("days")) {
            if (date.toString().equals(day.get("date").asText())) {
                return day;
            }
        }
        throw new AssertionError("응답에 날짜가 없음: " + date);
    }

    @Test
    void 십오분_미만_요청은_15분으로_늘리지_않고_기존세션을_유지한다() throws Exception {
        JsonNode routine = createRoutine(USER, "beginner", 3, 30, List.of("none"));
        long routineId = routine.get("routineId").asLong();
        List<String> beforeCodes = mainCodes(routine.get("days").get(0));

        String resJson = adjust(USER, routineId, NEXT_MONDAY, "오늘은 5분만 가능해")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.adjusted").value(false))
            .andExpect(jsonPath("$.startBlocked").value(false))
            .andReturn().getResponse().getContentAsString();
        JsonNode res = mapper.readTree(resJson);
        assertThat(res.get("notices").toString()).contains("최소 15분");
        assertThat(mainCodes(res.get("day"))).isEqualTo(beforeCodes);
    }

    @Test
    void 질환_키워드는_세션을_변경하지않고_의사상담_안내만_반환한다() throws Exception {
        JsonNode routine = createRoutine(USER, "beginner", 3, 30, List.of("none"));
        long routineId = routine.get("routineId").asLong();
        List<String> beforeCodes = mainCodes(routine.get("days").get(0));

        String resJson = adjust(USER, routineId, NEXT_MONDAY, "허리 디스크가 있어서 걱정돼")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.adjusted").value(false))
            .andExpect(jsonPath("$.startBlocked").value(false))
            .andExpect(jsonPath("$.riskLevel").value("MEDICAL"))
            .andReturn().getResponse().getContentAsString();
        JsonNode res = mapper.readTree(resJson);
        assertThat(res.get("notices").toString()).contains("의사");
        assertThat(mainCodes(res.get("day"))).isEqualTo(beforeCodes);
    }

    @Test
    void 고강도_연속배치_같은부위는_차단하고_다른부위는_허용하되_컨디션저하시_차단한다() throws Exception {
        // 4일(월·화·목·금), 고급(advanced, 주당 HIGH 3회, 세션당 HIGH 3개), 바벨·풀업바 포함
        JsonNode routine = createRoutine(USER, "advanced", 4, 30, List.of("barbell", "pullup_bar"));
        long routineId = routine.get("routineId").asLong();
        LocalDate tuesday = NEXT_MONDAY.plusDays(1);

        // 월요일 세션을 LOWER + HIGH 운동 포함 상태로 DB에 맞춰 세팅
        em.flush();
        String highLowerItems = """
            [{"phase":"MAIN","code":"JUMP_SQUAT","name":"점프 스쿼트","sets":3,"reps":10,"seconds":null,"restSeconds":60}]
            """;
        jdbc.update(
            "UPDATE workout_sessions SET focus_area = 'LOWER', items = ? WHERE routine_id = ? AND session_date = ?",
            highLowerItems, routineId, NEXT_MONDAY
        );
        // 목·금 세션은 HIGH가 아닌 상태로 정리해 주간 상한 여유 확보
        String lowItems = """
            [{"phase":"MAIN","code":"GLUTE_BRIDGE","name":"글루트 브릿지","sets":2,"reps":12,"seconds":null,"restSeconds":60}]
            """;
        jdbc.update(
            "UPDATE workout_sessions SET items = ? WHERE routine_id = ? AND session_date > ?",
            lowItems, routineId, tuesday
        );
        em.clear();

        // 1) 인접일(월)이 LOWER HIGH일 때, 화요일을 같은 부위(LOWER)로 강하게 요청 -> HIGH(3) 차단
        String sameFocusJson = adjust(USER, routineId, tuesday, "하체 강하게 할래")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.adjusted").value(true))
            .andReturn().getResponse().getContentAsString();
        JsonNode sameFocus = mapper.readTree(sameFocusJson);
        assertThat(sameFocus.get("notices").toString()).contains("같은 부위 고강도");
        for (String code : mainCodes(sameFocus.get("day"))) {
            assertThat(intensityOf(code)).isLessThanOrEqualTo(2);
        }

        // 2) 인접일(월)이 LOWER HIGH일 때, 화요일을 다른 부위(UPPER) + 컨디션 저하로 강하게 요청 -> HIGH(3) 차단
        String poorCondJson = adjust(USER, routineId, tuesday, "피곤한데 상체 강하게 할래")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.adjusted").value(true))
            .andReturn().getResponse().getContentAsString();
        JsonNode poorCond = mapper.readTree(poorCondJson);
        assertThat(poorCond.get("notices").toString()).contains("컨디션");
        for (String code : mainCodes(poorCond.get("day"))) {
            assertThat(intensityOf(code)).isLessThanOrEqualTo(2);
        }

        // 3) 인접일(월)이 LOWER HIGH일 때, 화요일을 다른 부위(UPPER) + 정상 컨디션으로 강하게 요청 -> HIGH 허용
        String diffFocusJson = adjust(USER, routineId, tuesday, "상체 강하게 할래")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.adjusted").value(true))
            .andReturn().getResponse().getContentAsString();
        JsonNode diffFocus = mapper.readTree(diffFocusJson);
        assertThat(diffFocus.get("notices").toString()).doesNotContain("같은 부위 고강도");
        boolean hasHigh = mainCodes(diffFocus.get("day")).stream().anyMatch(c -> intensityOf(c) == 3);
        assertThat(hasHigh).isTrue();
    }

    @Test
    void 타인루틴과_휴식일과_빈문장은_거절한다() throws Exception {
        JsonNode routine = createRoutine(USER, "beginner", 3, 30, List.of("none"));
        long routineId = routine.get("routineId").asLong();

        // 타인 루틴 -> 404 WORKOUT_003
        adjust(OTHER, routineId, NEXT_MONDAY, "15분만")
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.code").value("WORKOUT_003"));

        // 휴식일(화요일, 3일 루틴은 월·수·금) -> 404 WORKOUT_004
        adjust(USER, routineId, NEXT_MONDAY.plusDays(1), "15분만")
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.code").value("WORKOUT_004"));

        // 빈 문장 -> 400
        adjust(USER, routineId, NEXT_MONDAY, "   ")
            .andExpect(status().isBadRequest());
    }
}
