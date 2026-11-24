package com.mealfit.domain.workout;

import static com.mealfit.support.TestJwt.user;
import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.support.TestUserFixture;
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

/** 실제 보안 필터·Flyway 시드·DB로 운동 루틴 생성·조회와 검수 시나리오(QA-27·28·31)를 확인한다. */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class WorkoutRoutineApiTest {

    private static final long USER = 82001L;
    private static final long OTHER = 82002L;
    private static final String PATH = "/api/v1/workout-routines";
    private static final LocalDate NEXT_MONDAY = LocalDate.now(ZoneId.of("Asia/Seoul"))
        .with(TemporalAdjusters.next(DayOfWeek.MONDAY));

    @Autowired MockMvc mvc;
    @Autowired ObjectMapper mapper;
    @Autowired JdbcTemplate jdbc;

    @BeforeEach
    void prepareUsers() {
        TestUserFixture.create(jdbc, USER);
        TestUserFixture.create(jdbc, OTHER);
    }

    private Map<String, Object> body(String goal, int days, int minutes, List<String> equipment,
                                     List<String> injuries) {
        Map<String, Object> body = new HashMap<>();
        body.put("goal", goal);
        body.put("daysPerWeek", days);
        body.put("sessionMinutes", minutes);
        body.put("equipment", equipment);
        body.put("injuries", injuries);
        body.put("startDate", NEXT_MONDAY.toString());
        return body;
    }

    private ResultActions recommend(long userId, Object body) throws Exception {
        return mvc.perform(post(PATH + "/recommend").with(user(userId))
            .contentType(MediaType.APPLICATION_JSON).content(mapper.writeValueAsString(body)));
    }

    private JsonNode recommendOk(long userId, Object body) throws Exception {
        String json = recommend(userId, body).andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();
        return mapper.readTree(json);
    }

    private static List<JsonNode> sessions(JsonNode routine) {
        List<JsonNode> sessions = new ArrayList<>();
        routine.get("days").forEach(day -> {
            if (day.hasNonNull("sessionId")) {
                sessions.add(day);
            }
        });
        return sessions;
    }

    private static List<String> codes(JsonNode day) {
        List<String> codes = new ArrayList<>();
        for (String phase : List.of("warmUp", "exercises", "coolDown")) {
            day.get(phase).forEach(item -> codes.add(item.get("code").asText()));
        }
        return codes;
    }

    private String equipmentOf(String code) {
        return jdbc.queryForObject("select equipment from exercise_catalog where code = ?", String.class, code);
    }

    private List<String> loadAreasOf(String code) {
        return jdbc.queryForList("""
            select a.body_area from exercise_catalog_load_areas a
            join exercise_catalog e on e.id = a.exercise_id where e.code = ?
            """, String.class, code);
    }

    @Test
    void QA27_주3일_30분_덤벨만으로_루틴을_만든다() throws Exception {
        JsonNode routine = recommendOk(USER, body("hypertrophy", 3, 30, List.of("dumbbell"), List.of()));

        assertThat(routine.get("routineId").asLong()).isPositive();
        assertThat(routine.get("ruleVersion").asText()).isEqualTo("wr-1.0");
        assertThat(routine.get("disclaimer").asText()).contains("의학적 진단");
        assertThat(routine.get("days")).hasSize(7);

        List<JsonNode> sessions = sessions(routine);
        assertThat(sessions).hasSize(3);
        assertThat(sessions).extracting(day -> day.get("dayOfWeek").asText()).containsExactly("MON", "WED", "FRI");
        for (JsonNode day : sessions) {
            assertThat(day.get("durationMinutes").asInt()).isBetween(1, 30);
            assertThat(day.get("exercises")).isNotEmpty();
            for (String code : codes(day)) {
                assertThat(equipmentOf(code)).isIn("BODYWEIGHT", "DUMBBELL");
            }
        }
        routine.get("days").forEach(day -> {
            if (!day.hasNonNull("sessionId")) {
                assertThat(day.get("isRestDay").asBoolean()).isTrue();
            }
        });
    }

    @Test
    void QA31_바벨을_빼고_무릎부상을_추가하면_새루틴에_바벨과_무릎부담_운동이_없다() throws Exception {
        recommendOk(USER, body("hypertrophy", 4, 45, List.of("barbell", "dumbbell"), List.of()));
        JsonNode routine = recommendOk(USER, body("hypertrophy", 4, 45, List.of("dumbbell", "band"),
            List.of("무릎")));

        assertThat(routine.get("notices").toString()).contains("무릎");
        for (JsonNode day : sessions(routine)) {
            for (String code : codes(day)) {
                assertThat(equipmentOf(code)).isNotEqualTo("BARBELL");
                assertThat(loadAreasOf(code)).doesNotContain("KNEE");
            }
        }
    }

    @Test
    void QA28_점프와_미보유장비_운동만_남은_사전이면_위반루틴을_저장하지_않고_기본루틴과_안내를_보여준다() throws Exception {
        jdbc.update("update exercise_catalog set active = false where phase = 'MAIN' and code not in "
            + "('JUMP_SQUAT', 'BB_SQUAT', 'BB_LUNGE')");

        JsonNode routine = recommendOk(USER, body("hypertrophy", 3, 30, List.of("dumbbell"), List.of("무릎")));

        assertThat(routine.get("source").asText()).isEqualTo("DEFAULT");
        assertThat(routine.get("notices").toString()).contains("기본 루틴");
        List<JsonNode> sessions = sessions(routine);
        assertThat(sessions).isNotEmpty();
        for (JsonNode day : sessions) {
            assertThat(day.get("source").asText()).isEqualTo("DEFAULT");
            assertThat(codes(day)).doesNotContain("JUMP_SQUAT", "BB_SQUAT", "BB_LUNGE");
        }
        Integer saved = jdbc.queryForObject("""
            select count(*) from workout_sessions where user_id = ? and items like '%JUMP_SQUAT%'
            """, Integer.class, USER);
        assertThat(saved).isZero();
    }

    @Test
    void 루틴을_다시_받으면_이전_루틴은_교체되고_같은날짜_활성세션은_하나다() throws Exception {
        JsonNode first = recommendOk(USER, body("loss", 5, 30, List.of("none"), List.of()));
        JsonNode second = recommendOk(USER, body("stamina", 2, 15, List.of("none"), List.of()));

        assertThat(jdbc.queryForObject("select status from workout_routines where id = ?", String.class,
            first.get("routineId").asLong())).isEqualTo("REPLACED");
        assertThat(jdbc.queryForObject("select status from workout_routines where id = ?", String.class,
            second.get("routineId").asLong())).isEqualTo("ACTIVE");

        Integer duplicates = jdbc.queryForObject("""
            select count(*) from (select active_key from workout_sessions
            where user_id = ? and active_key is not null group by active_key having count(*) > 1) d
            """, Integer.class, USER);
        assertThat(duplicates).isZero();
        // 주 2일 · 2주치
        assertThat(jdbc.queryForObject("select count(*) from workout_sessions where user_id = ? "
            + "and active_key is not null", Integer.class, USER)).isEqualTo(4);
    }

    @Test
    void 현재_루틴_조회는_루틴없음과_휴식일을_구분하고_다른회원과_섞이지_않는다() throws Exception {
        mvc.perform(get(PATH + "/current").param("week", NEXT_MONDAY.toString()).with(user(USER)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.routineId").doesNotExist())
            .andExpect(jsonPath("$.days.length()").value(7))
            .andExpect(jsonPath("$.days[1].isRestDay").value(false));

        JsonNode created = recommendOk(USER, body("health", 3, 30, List.of("band"), List.of()));

        String json = mvc.perform(get(PATH + "/current").param("week", NEXT_MONDAY.toString()).with(user(USER)))
            .andExpect(status().isOk()).andReturn().getResponse().getContentAsString();
        JsonNode current = mapper.readTree(json);
        assertThat(current.get("routineId").asLong()).isEqualTo(created.get("routineId").asLong());
        assertThat(current.get("days").get(0).get("sessionId").asLong())
            .isEqualTo(created.get("days").get(0).get("sessionId").asLong());
        assertThat(current.get("days").get(1).get("isRestDay").asBoolean()).isTrue();

        mvc.perform(get(PATH + "/current").param("week", NEXT_MONDAY.toString()).with(user(OTHER)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.routineId").doesNotExist());
    }

    @Test
    void 요청값이_없으면_프로필_운동조건을_쓴다() throws Exception {
        Map<String, Object> fitness = new HashMap<>(Map.of("workoutGoal", "loss", "workoutLevel", "beginner",
            "workoutMinutes", 40, "daysPerWeek", 2, "equipment", List.of("none"), "injuries", List.of("허리")));
        mvc.perform(put("/api/v1/me/profile/details/fitness").with(user(USER))
                .contentType(MediaType.APPLICATION_JSON).content(mapper.writeValueAsString(fitness)))
            .andExpect(status().isOk());

        JsonNode routine = recommendOk(USER, Map.of("startDate", NEXT_MONDAY.toString()));
        assertThat(routine.get("goal").asText()).isEqualTo("loss");
        assertThat(routine.get("daysPerWeek").asInt()).isEqualTo(2);
        // 40분은 가까운 아래 허용값 30분으로 내린다
        assertThat(routine.get("sessionMinutes").asInt()).isEqualTo(30);
        assertThat(routine.get("notices").toString()).contains("허리");
        for (JsonNode day : sessions(routine)) {
            for (String code : codes(day)) {
                assertThat(loadAreasOf(code)).doesNotContain("LOWER_BACK");
            }
        }
    }

    @Test
    void 운동조건이_없거나_잘못되면_거부한다() throws Exception {
        recommend(USER, Map.of("startDate", NEXT_MONDAY.toString()))
            .andExpect(status().isUnprocessableEntity())
            .andExpect(jsonPath("$.code").value("WORKOUT_001"));

        recommend(USER, body("hypertrophy", 3, 20, List.of("none"), List.of()))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("WORKOUT_002"));

        recommend(USER, body("hypertrophy", 3, 30, List.of("spaceship"), List.of()))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("WORKOUT_002"));

        Map<String, Object> past = body("hypertrophy", 3, 30, List.of("none"), List.of());
        past.put("startDate", LocalDate.now(ZoneId.of("Asia/Seoul")).minusDays(1).toString());
        recommend(USER, past)
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("WORKOUT_002"));

        recommend(USER, body("hypertrophy", 7, 30, List.of("none"), List.of()))
            .andExpect(status().isBadRequest());
    }

    @Test
    void 모르는_부상값은_강도1로_고정하고_안내한다() throws Exception {
        JsonNode routine = recommendOk(USER, body("hypertrophy", 3, 30, List.of("none"), List.of("발가락")));
        assertThat(routine.get("notices").toString()).contains("정확히 알 수 없어");
        Set<String> allowedIntensity = Set.of("1");
        for (JsonNode day : sessions(routine)) {
            for (String code : codes(day)) {
                String intensity = jdbc.queryForObject("select intensity from exercise_catalog where code = ?",
                    String.class, code);
                assertThat(intensity).isIn(allowedIntensity);
            }
        }
    }
}
