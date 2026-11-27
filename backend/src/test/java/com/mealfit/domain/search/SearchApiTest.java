package com.mealfit.domain.search;

import static com.mealfit.support.TestJwt.user;
import static org.hamcrest.Matchers.everyItem;
import static org.hamcrest.Matchers.greaterThan;
import static org.hamcrest.Matchers.hasItem;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.mealfit.support.TestUserFixture;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

/** 웹 통합 검색 API. 실제 보안 필터·Flyway 시드(검수 레시피·재료 기준표·운동 사전)를 쓴다. */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class SearchApiTest {

    private static final long USER = 86001L;
    private static final long OTHER = 86002L;

    @Autowired MockMvc mvc;
    @Autowired JdbcTemplate jdbc;

    @BeforeEach
    void setUp() {
        TestUserFixture.create(jdbc, USER);
        TestUserFixture.create(jdbc, OTHER);
    }

    private void lot(long userId, String name, String status) {
        jdbc.update("""
                insert into inventory_lots (user_id, ingredient_name, quantity, unit, storage_location,
                    status, created_at, updated_at)
                values (?, ?, 2, '개', 'FRIDGE', ?, current_timestamp, current_timestamp)
                """, userId, name, status);
    }

    private void shopping(long userId, String name) {
        jdbc.update("""
                insert into shopping_items (user_id, ingredient_name, required_qty, unit, status, created_at, updated_at)
                values (?, ?, 1, '개', 'NEEDED', current_timestamp, current_timestamp)
                """, userId, name);
    }

    private long ownRecipe(long userId, String name) {
        jdbc.update("""
                insert into recipes (user_id, name, serving_size, cook_time_min, nutrition_estimated, source,
                    created_at, updated_at)
                values (?, ?, 1, 10, true, 'AI_GENERATED', current_timestamp, current_timestamp)
                """, userId, name);
        return jdbc.queryForObject("select max(id) from recipes where user_id = ? and name = ?", Long.class, userId, name);
    }

    private void mealPlan(long userId, long recipeId) {
        jdbc.update("""
                insert into meal_plans (user_id, plan_date, meal_type, recipe_id, servings, status, created_at, updated_at)
                values (?, current_date, 'LUNCH', ?, 1, 'CONFIRMED', current_timestamp, current_timestamp)
                """, userId, recipeId);
    }

    private void workout(long userId, String title) {
        jdbc.update("""
                insert into workout_routines (user_id, goal, level, days_per_week, session_minutes, equipment_snapshot,
                    injuries_snapshot, intensity_cap, source, rule_version, status, start_date, planned_until,
                    created_at, updated_at)
                values (?, 'FITNESS', 'BEGINNER', 2, 15, '[]', '[]', 1, 'RULE', 'v1', 'ACTIVE',
                    current_date, current_date, current_timestamp, current_timestamp)
                """, userId);
        Long routineId = jdbc.queryForObject("select max(id) from workout_routines where user_id = ?", Long.class, userId);
        jdbc.update("""
                insert into workout_sessions (user_id, routine_id, session_date, focus_area, title, planned_minutes,
                    items, source, created_at, updated_at)
                values (?, ?, current_date, 'LOWER', ?, 15, '[{"name":"맨몸 스쿼트"}]', 'RULE',
                    current_timestamp, current_timestamp)
                """, userId, routineId, title);
    }

    @Test
    void 로그인하지_않으면_검색할_수_없다() throws Exception {
        mvc.perform(get("/api/v1/search").param("q", "달걀")).andExpect(status().isUnauthorized());
    }

    @Test
    void 공개_검색은_공용_레시피와_운동_사전만_반환한다() throws Exception {
        long personalRecipe = ownRecipe(USER, "검색전용 개인반찬");
        mealPlan(USER, personalRecipe);
        lot(OTHER, "검색전용 개인반찬", "ACTIVE");
        shopping(USER, "검색전용 개인반찬");
        workout(USER, "검색전용 개인반찬");
        mvc.perform(get("/api/v1/search/public").param("q", "검색전용 개인반찬"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.recipes.total").value(0))
                .andExpect(jsonPath("$.exercises.total").value(0))
                .andExpect(jsonPath("$.inventory").doesNotExist())
                .andExpect(jsonPath("$.mealPlans").doesNotExist())
                .andExpect(jsonPath("$.shoppingItems").doesNotExist())
                .andExpect(jsonPath("$.workouts").doesNotExist());
        mvc.perform(get("/api/v1/search/public").param("q", "검색전용 개인반찬").with(user(USER)))
                .andExpect(jsonPath("$.recipes.total").value(0));
        mvc.perform(get("/api/v1/search/public").param("q", "계란").param("limit", "2"))
                .andExpect(jsonPath("$.terms", hasItem("달걀")))
                .andExpect(jsonPath("$.recipes.items", hasSize(2)))
                .andExpect(jsonPath("$.recipes.items[*].mine", everyItem(is(false))));
        mvc.perform(get("/api/v1/search/public").param("q", "스쿼트").param("types", "EXERCISE")
                        .param("limit", "1").param("offset", "1"))
                .andExpect(jsonPath("$.exercises.items", hasSize(1)))
                .andExpect(jsonPath("$.recipes").doesNotExist());
    }

    @Test
    void 공개_검색에서_개인_범위를_명시해도_조회할_수_없다() throws Exception {
        mvc.perform(get("/api/v1/search/public").param("q", "달걀").param("types", "RECIPE,INVENTORY"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void 별칭으로_같은_재료를_함께_찾고_내_데이터만_보여준다() throws Exception {
        lot(USER, "달걀", "ACTIVE");
        lot(USER, "달걀", "DEPLETED");
        lot(OTHER, "달걀", "ACTIVE");
        shopping(USER, "계란");
        shopping(OTHER, "계란");

        mvc.perform(get("/api/v1/search").param("q", "계란").with(user(USER)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.query").value("계란"))
                .andExpect(jsonPath("$.terms", hasItem("달걀")))
                .andExpect(jsonPath("$.recipes.total", greaterThan(0)))
                .andExpect(jsonPath("$.recipes.items[0].matchedIngredients", hasItem("달걀")))
                .andExpect(jsonPath("$.inventory.total").value(1))
                .andExpect(jsonPath("$.inventory.items[0].ingredientName").value("달걀"))
                .andExpect(jsonPath("$.inventory.items[0].expirationStatus").value("UNKNOWN"))
                .andExpect(jsonPath("$.shoppingItems.total").value(1))
                .andExpect(jsonPath("$.shoppingItems.items[0].status").value("NEEDED"));
    }

    @Test
    void 공백과_대소문자를_무시한다() throws Exception {
        lot(USER, "방울 토마토", "ACTIVE");
        lot(USER, "Greek Yogurt", "ACTIVE");

        mvc.perform(get("/api/v1/search").param("q", "방울토마토").param("types", "INVENTORY").with(user(USER)))
                .andExpect(jsonPath("$.inventory.items[0].ingredientName").value("방울 토마토"));
        mvc.perform(get("/api/v1/search").param("q", "  greek   YOGURT ").param("types", "INVENTORY").with(user(USER)))
                .andExpect(jsonPath("$.query").value("greek YOGURT"))
                .andExpect(jsonPath("$.inventory.total").value(1));
    }

    @Test
    void 알레르기_재료가_든_레시피는_빼지_않고_restricted로_표시한다() throws Exception {
        jdbc.update("""
                insert into profile_allergies (profile_id, ingredient_name)
                select id, '달걀' from profiles where user_id = ?""", USER);

        mvc.perform(get("/api/v1/search").param("q", "달걀").param("types", "RECIPE").param("limit", "20")
                        .with(user(USER)))
                .andExpect(jsonPath("$.recipes.items", hasSize(20)))
                .andExpect(jsonPath("$.recipes.items[*].restricted", everyItem(is(true))))
                .andExpect(jsonPath("$.recipes.items[0].restrictedIngredients", hasItem("달걀")));
        mvc.perform(get("/api/v1/search").param("q", "달걀").param("types", "RECIPE").with(user(OTHER)))
                .andExpect(jsonPath("$.recipes.items[0].restricted").value(false));
    }

    @Test
    void 본인_레시피와_식단은_본인만_찾는다() throws Exception {
        long mine = ownRecipe(USER, "검색전용 비밀 볶음밥");
        long others = ownRecipe(OTHER, "검색전용 비밀 볶음밥");
        mealPlan(USER, mine);
        mealPlan(OTHER, others);

        mvc.perform(get("/api/v1/search").param("q", "검색전용 비밀").param("types", "RECIPE,MEAL_PLAN")
                        .with(user(USER)))
                .andExpect(jsonPath("$.recipes.total").value(1))
                .andExpect(jsonPath("$.recipes.items[0].id").value(mine))
                .andExpect(jsonPath("$.recipes.items[0].mine").value(true))
                .andExpect(jsonPath("$.mealPlans.total").value(1))
                .andExpect(jsonPath("$.mealPlans.items[0].recipeName").value("검색전용 비밀 볶음밥"))
                .andExpect(jsonPath("$.inventory").doesNotExist())
                .andExpect(jsonPath("$.exercises").doesNotExist());
    }

    @Test
    void 운동_사전과_내_운동_세션을_찾는다() throws Exception {
        workout(USER, "하체 루틴");
        workout(OTHER, "하체 루틴");

        mvc.perform(get("/api/v1/search").param("q", "스쿼트").param("types", "EXERCISE,WORKOUT").with(user(USER)))
                .andExpect(jsonPath("$.exercises.total", greaterThan(3)))
                .andExpect(jsonPath("$.exercises.items[0].name").exists())
                .andExpect(jsonPath("$.workouts.total").value(1));
        mvc.perform(get("/api/v1/search").param("q", "하체").param("types", "WORKOUT").with(user(USER)))
                .andExpect(jsonPath("$.workouts.items[0].title").value("하체 루틴"));
    }

    @Test
    void limit과_offset은_대상마다_적용된다() throws Exception {
        String first = mvc.perform(get("/api/v1/search").param("q", "달걀").param("types", "RECIPE")
                        .param("limit", "2").with(user(USER)))
                .andExpect(jsonPath("$.recipes.items", hasSize(2)))
                .andReturn().getResponse().getContentAsString();
        mvc.perform(get("/api/v1/search").param("q", "달걀").param("types", "RECIPE")
                        .param("limit", "2").param("offset", "1").with(user(USER)))
                .andExpect(jsonPath("$.recipes.items", hasSize(2)))
                .andExpect(jsonPath("$.recipes.items[0].id").value(
                        com.jayway.jsonpath.JsonPath.<Integer>read(first, "$.recipes.items[1].id")));
    }

    @Test
    void LIKE_특수문자는_글자_그대로_찾는다() throws Exception {
        lot(USER, "달걀", "ACTIVE");
        mvc.perform(get("/api/v1/search").param("q", "%").param("types", "INVENTORY").with(user(USER)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.inventory.total").value(0));
        mvc.perform(get("/api/v1/search").param("q", "_").param("types", "INVENTORY").with(user(USER)))
                .andExpect(jsonPath("$.inventory.total").value(0));
    }

    @Test
    void 잘못된_요청은_400() throws Exception {
        mvc.perform(get("/api/v1/search").param("q", "   ").with(user(USER))).andExpect(status().isBadRequest());
        mvc.perform(get("/api/v1/search").param("q", "가".repeat(51)).with(user(USER))).andExpect(status().isBadRequest());
        mvc.perform(get("/api/v1/search").param("q", "달걀").param("limit", "21").with(user(USER)))
                .andExpect(status().isBadRequest());
        mvc.perform(get("/api/v1/search").param("q", "달걀").param("offset", "-1").with(user(USER)))
                .andExpect(status().isBadRequest());
        mvc.perform(get("/api/v1/search").param("q", "달걀").param("types", "UNKNOWN").with(user(USER)))
                .andExpect(status().isBadRequest());
    }
}
