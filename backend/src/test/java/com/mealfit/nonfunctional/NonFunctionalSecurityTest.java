package com.mealfit.nonfunctional;

import static com.mealfit.support.TestJwt.user;
import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.mealfit.support.TestUserFixture;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

/**
 * 비기능 — 보안(PRD NFR-SEC-01·02, NFR-API-01). PL 담당 API(검색·알레르기·레시피·식단 추천)를 대상으로
 * 인증 필수, 다른 회원 데이터 차단, SQL·LIKE 주입 무력화, 비정상 입력의 안전한 거절, 오류 응답의 내부 정보 비노출을 확인한다.
 */
@Tag("nonfunctional")
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class NonFunctionalSecurityTest {

    private static final long USER = 87101L;
    private static final long OTHER = 87102L;

    @Autowired MockMvc mvc;
    @Autowired JdbcTemplate jdbc;

    private long othersRecipe;

    @BeforeEach
    void setUp() {
        TestUserFixture.create(jdbc, USER);
        TestUserFixture.create(jdbc, OTHER);
        jdbc.update("""
                insert into inventory_lots (user_id, ingredient_name, quantity, unit, storage_location, status, created_at, updated_at)
                values (?, '비밀 재료', 1, '개', 'FRIDGE', 'ACTIVE', current_timestamp, current_timestamp)
                """, OTHER);
        jdbc.update("""
                insert into recipes (user_id, name, serving_size, cook_time_min, nutrition_estimated, source, created_at, updated_at)
                values (?, '다른 회원 개인 레시피', 1, 10, true, 'AI_GENERATED', current_timestamp, current_timestamp)
                """, OTHER);
        othersRecipe = jdbc.queryForObject("select max(id) from recipes where user_id = ?", Long.class, OTHER);
    }

    @ParameterizedTest
    @ValueSource(strings = {"/api/v1/search?q=달걀", "/api/v1/allergens", "/api/v1/allergens/search?q=계란",
            "/api/v1/me/allergies", "/api/v1/recipes/1", "/api/v1/recipes/1/allergen-check"})
    void 로그인하지_않으면_401(String url) throws Exception {
        mvc.perform(get(url)).andExpect(status().isUnauthorized());
    }

    @Test
    void 쓰기_API도_로그인하지_않으면_401() throws Exception {
        mvc.perform(post("/api/v1/meal-plans/recommend").contentType(MediaType.APPLICATION_JSON).content("{}"))
                .andExpect(status().isUnauthorized());
        mvc.perform(put("/api/v1/me/allergies").contentType(MediaType.APPLICATION_JSON).content("{\"codes\":[],\"custom\":[]}"))
                .andExpect(status().isUnauthorized());
    }

    @ParameterizedTest
    @ValueSource(strings = {"Bearer not-a-jwt", "Bearer eyJhbGciOiJIUzI1NiJ9.e30.invalidsignature", "Basic dXNlcjpwYXNz"})
    void 위조되거나_잘못된_토큰은_401(String header) throws Exception {
        mvc.perform(get("/api/v1/search").param("q", "달걀").header("Authorization", header))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void 다른_회원의_재고는_검색되지_않는다() throws Exception {
        mvc.perform(get("/api/v1/search").param("q", "비밀 재료").param("types", "INVENTORY").with(user(USER)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.inventory.total").value(0));
    }

    @Test
    void 다른_회원의_개인_레시피는_조회도_알레르기_확인도_404() throws Exception {
        mvc.perform(get("/api/v1/recipes/{id}", othersRecipe).with(user(USER))).andExpect(status().isNotFound());
        mvc.perform(get("/api/v1/recipes/{id}/allergen-check", othersRecipe).with(user(USER))).andExpect(status().isNotFound());
        mvc.perform(get("/api/v1/search").param("q", "다른 회원 개인").param("types", "RECIPE").with(user(USER)))
                .andExpect(jsonPath("$.recipes.total").value(0));
    }

    @ParameterizedTest
    @ValueSource(strings = {"' OR '1'='1", "%' OR 1=1 --", "'; DROP TABLE recipes; --", "\\' UNION SELECT * FROM users --", "%%", "_"})
    void SQL_LIKE_주입_문자열은_글자_그대로_찾고_데이터는_그대로다(String payload) throws Exception {
        Integer before = jdbc.queryForObject("select count(*) from recipes", Integer.class);
        mvc.perform(get("/api/v1/search").param("q", payload).with(user(USER)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.inventory.total").value(0))
                .andExpect(jsonPath("$.recipes.total").value(0));
        mvc.perform(get("/api/v1/allergens/search").param("q", payload).with(user(USER))).andExpect(status().isOk());
        assertThat(jdbc.queryForObject("select count(*) from recipes", Integer.class)).isEqualTo(before);
    }

    @Test
    void 지나치게_긴_입력은_500이_아니라_400() throws Exception {
        mvc.perform(get("/api/v1/search").param("q", "가".repeat(10_000)).with(user(USER))).andExpect(status().isBadRequest());
        mvc.perform(get("/api/v1/allergens/search").param("q", "가".repeat(10_000)).with(user(USER)))
                .andExpect(status().isBadRequest());
        mvc.perform(get("/api/v1/search").param("q", "달걀").param("limit", "100000").with(user(USER)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void 오류_응답에_스택_트레이스나_내부_클래스_이름이_없다() throws Exception {
        for (var request : new org.springframework.test.web.servlet.RequestBuilder[] {
                get("/api/v1/search").param("q", "가".repeat(51)).with(user(USER)),
                get("/api/v1/search").param("q", "달걀").param("types", "NOPE").with(user(USER)),
                get("/api/v1/recipes/{id}", 999_999_999L).with(user(USER)),
                post("/api/v1/meal-plans/recommend").with(user(USER)).contentType(MediaType.APPLICATION_JSON).content("{broken")}) {
            String body = mvc.perform(request).andReturn().getResponse().getContentAsString();
            assertThat(body).doesNotContain("Exception", "at com.", "org.springframework", "SQL", "jdbc");
            assertThat(body).contains("\"code\"");
        }
    }
}
