package com.mealfit.nonfunctional;

import static com.mealfit.support.TestJwt.user;
import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;

import com.mealfit.domain.mealplan.client.MealPlanAiClient;
import com.mealfit.support.TestUserFixture;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.function.IntFunction;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.ResourceAccessException;

/**
 * 비기능 — 응답 시간(성능). SDD 13.1 품질 목표:
 *  핵심 비추천 API p95 ≤ 500ms, 추천(LLM 포함) p95 ≤ 15초.
 * 측정 환경: 테스트 프로필(H2, MockMvc, 같은 JVM). 네트워크·RDS 지연은 포함하지 않으므로 서버 처리 시간의 기준선으로 본다.
 * 각 API를 10회 예열한 뒤 50회 호출해 p50·p95·최대를 잰다. 결과는 build/nonfunctional/performance.csv에 남긴다.
 * LLM은 꺼진 상태(연결 실패)로 두어 운영과 같은 검수 레시피 대체 경로를 잰다.
 */
@Tag("nonfunctional")
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class NonFunctionalPerformanceTest {

    private static final long USER = 87001L;
    private static final int WARMUP = 10;
    private static final int RUNS = 50;
    private static final Map<String, long[]> RESULTS = new LinkedHashMap<>();

    @Autowired MockMvc mvc;
    @Autowired JdbcTemplate jdbc;
    @MockitoBean MealPlanAiClient aiClient;

    private long recipeId;

    @BeforeEach
    void setUp() {
        TestUserFixture.create(jdbc, USER);
        given(aiClient.recommend(any())).willThrow(new ResourceAccessException("LLM off"));
        recipeId = jdbc.queryForObject("select id from recipes where recipe_code = 'B0001'", Long.class);
        for (String name : List.of("달걀", "양파", "두부", "현미밥", "닭가슴살")) {
            jdbc.update("""
                    insert into inventory_lots (user_id, ingredient_name, quantity, unit, storage_location, status,
                        expiry_date, created_at, updated_at)
                    values (?, ?, 300, 'g', 'FRIDGE', 'ACTIVE', current_date + 3, current_timestamp, current_timestamp)
                    """, USER, name);
        }
    }

    /** 예열 후 RUNS번 호출해 [p50, p95, max] (ms) */
    private long[] measure(String label, IntFunction<RequestBuilder> request, int expectedStatus) throws Exception {
        for (int i = 0; i < WARMUP; i++) {
            mvc.perform(request.apply(i));
        }
        List<Long> ms = new ArrayList<>();
        for (int i = 0; i < RUNS; i++) {
            long start = System.nanoTime();
            int status = mvc.perform(request.apply(WARMUP + i)).andReturn().getResponse().getStatus();
            ms.add((System.nanoTime() - start) / 1_000_000);
            assertThat(status).as(label).isEqualTo(expectedStatus);
        }
        ms.sort(Long::compare);
        long[] r = {ms.get(RUNS / 2), ms.get((int) Math.ceil(RUNS * 0.95) - 1), ms.get(RUNS - 1)};
        RESULTS.put(label, r);
        return r;
    }

    @Test
    void 통합_검색_전체_대상_p95_500ms_이하() throws Exception {
        long[] r = measure("GET /search?q=달걀 (6개 대상)", i -> get("/api/v1/search").param("q", "달걀").with(user(USER)), 200);
        assertThat(r[1]).isLessThanOrEqualTo(500);
    }

    @Test
    void 통합_검색_레시피_20건_p95_500ms_이하() throws Exception {
        long[] r = measure("GET /search?q=계란&types=RECIPE&limit=20",
                i -> get("/api/v1/search").param("q", "계란").param("types", "RECIPE").param("limit", "20").with(user(USER)), 200);
        assertThat(r[1]).isLessThanOrEqualTo(500);
    }

    @Test
    void 알레르기_목록과_검색_p95_500ms_이하() throws Exception {
        assertThat(measure("GET /allergens", i -> get("/api/v1/allergens").with(user(USER)), 200)[1]).isLessThanOrEqualTo(500);
        assertThat(measure("GET /allergens/search?q=계란",
                i -> get("/api/v1/allergens/search").param("q", "계란").with(user(USER)), 200)[1]).isLessThanOrEqualTo(500);
    }

    @Test
    void 레시피_상세와_알레르기_확인_p95_500ms_이하() throws Exception {
        assertThat(measure("GET /recipes/{id}", i -> get("/api/v1/recipes/{id}", recipeId).with(user(USER)), 200)[1])
                .isLessThanOrEqualTo(500);
        assertThat(measure("GET /recipes/{id}/allergen-check",
                i -> get("/api/v1/recipes/{id}/allergen-check", recipeId).with(user(USER)), 200)[1]).isLessThanOrEqualTo(500);
    }

    @Test
    void 하루_세_끼_추천_LLM_꺼짐_대체_경로_p95_15초_이하() throws Exception {
        LocalDate base = LocalDate.now().plusDays(1);
        long[] r = measure("POST /meal-plans/recommend (LLM 꺼짐 → 검수 레시피 대체)",
                i -> post("/api/v1/meal-plans/recommend").with(user(USER)).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"planDate\":\"" + base.plusDays(i) + "\"}"), 201);
        assertThat(r[1]).isLessThanOrEqualTo(15_000);
    }

    @AfterAll
    static void writeReport() throws IOException {
        Path dir = Path.of("build", "nonfunctional");
        Files.createDirectories(dir);
        StringBuilder csv = new StringBuilder("api,runs,p50_ms,p95_ms,max_ms\n");
        RESULTS.forEach((k, v) -> csv.append('"').append(k).append("\",").append(RUNS).append(',')
                .append(v[0]).append(',').append(v[1]).append(',').append(v[2]).append('\n'));
        Files.writeString(dir.resolve("performance.csv"), csv);
    }
}
