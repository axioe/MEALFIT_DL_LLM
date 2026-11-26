package com.mealfit.domain.allergen;

import static com.mealfit.support.TestJwt.user;
import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.contains;
import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.mealfit.domain.mealplan.model.UserDietProfile;
import com.mealfit.domain.mealplan.service.UserDietProfileProvider;
import com.mealfit.support.TestUserFixture;
import jakarta.persistence.EntityManager;
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
import org.springframework.transaction.annotation.Transactional;

/** 알레르기 목록·검색·내 알레르기 저장 API (MEALFIT-139). 실제 보안 필터·Flyway 시드·DB를 쓴다. */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class AllergenApiTest {

    private static final long USER = 85001L;
    private static final long OTHER = 85002L;

    @Autowired MockMvc mvc;
    @Autowired JdbcTemplate jdbc;
    @Autowired UserDietProfileProvider dietProfileProvider;
    @Autowired EntityManager em;

    @BeforeEach
    void setUp() {
        TestUserFixture.create(jdbc, USER);
        TestUserFixture.create(jdbc, OTHER);
    }

    @Test
    void 목록은_카테고리_8개_순서로_묶여_나온다() throws Exception {
        mvc.perform(get("/api/v1/allergens").with(user(USER)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.categories", hasSize(8)))
                .andExpect(jsonPath("$.categories[*].name").value(contains(
                        "알·유제품", "곡류", "콩류", "견과·씨앗", "해산물", "육류", "과일·채소", "첨가물")))
                .andExpect(jsonPath("$.categories[2].items[*].name").value(contains("대두", "땅콩")))
                .andExpect(jsonPath("$.categories[5].items[0].selectAll").value(false));
    }

    @Test
    void 로그인하지_않으면_목록을_볼_수_없다() throws Exception {
        mvc.perform(get("/api/v1/allergens")).andExpect(status().isUnauthorized());
    }

    @Test
    void 검색은_이름_별칭_재료_이름으로_찾는다() throws Exception {
        mvc.perform(get("/api/v1/allergens/search").param("q", "계란").with(user(USER)))
                .andExpect(jsonPath("$[0].name").value("알류"))
                .andExpect(jsonPath("$[0].matchedBy").value("ALIAS"));
        mvc.perform(get("/api/v1/allergens/search").param("q", "참기름").with(user(USER)))
                .andExpect(jsonPath("$[0].name").value("참깨"))
                .andExpect(jsonPath("$[0].matchedBy").value("INGREDIENT"))
                .andExpect(jsonPath("$[0].certainty").value("CONTAINS"));
        mvc.perform(get("/api/v1/allergens/search").param("q", " 새 우 ").with(user(USER)))
                .andExpect(jsonPath("$[0].name").value("새우"))
                .andExpect(jsonPath("$[0].matchedBy").value("NAME"));
        mvc.perform(get("/api/v1/allergens/search").param("q", "키위").with(user(USER)))
                .andExpect(jsonPath("$", hasSize(0)));
    }

    @Test
    void 고른_항목은_고시_이름으로_직접_입력은_그대로_저장되고_기존_차단에_쓰인다() throws Exception {
        mvc.perform(put("/api/v1/me/allergies").with(user(USER))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"codes\":[\"EGG\",\"SESAME\"],\"custom\":[\"키위\",\" 계란 \"]}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.selected[*].code").value(contains("EGG", "SESAME")))
                .andExpect(jsonPath("$.custom").value(contains("키위")));
        em.flush();

        assertThat(jdbc.queryForList("""
                select pa.ingredient_name from profile_allergies pa join profiles p on p.id = pa.profile_id
                where p.user_id = ?""", String.class, USER))
                .containsExactlyInAnyOrder("알류", "참깨", "키위");

        UserDietProfile profile = dietProfileProvider.getProfile(USER);
        assertThat(profile.restrictedIngredients()).contains("달걀", "마요네즈", "참기름", "키위");

        mvc.perform(get("/api/v1/me/allergies").with(user(USER)))
                .andExpect(jsonPath("$.selected[*].name").value(contains("알류", "참깨")))
                .andExpect(jsonPath("$.custom").value(contains("키위")));
        mvc.perform(get("/api/v1/me/allergies").with(user(OTHER)))
                .andExpect(jsonPath("$.selected", hasSize(0)))
                .andExpect(jsonPath("$.custom", hasSize(0)));
    }

    @Test
    void 알레르기만_바꾸고_다른_추천_조건은_그대로_둔다() throws Exception {
        jdbc.update("update profiles set cook_time_min = 20, meal_budget = 8000 where user_id = ?", USER);
        mvc.perform(put("/api/v1/me/allergies").with(user(USER))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"codes\":[\"MILK\"],\"custom\":[]}"))
                .andExpect(status().isOk());
        em.flush();

        Map<String, Object> row = jdbc.queryForMap(
                "select cook_time_min, meal_budget from profiles where user_id = ?", USER);
        assertThat(row.get("COOK_TIME_MIN").toString()).isEqualTo("20");
        assertThat(row.get("MEAL_BUDGET").toString()).isEqualTo("8000");
    }

    @Test
    void 없는_코드는_거절한다() throws Exception {
        mvc.perform(put("/api/v1/me/allergies").with(user(USER))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"codes\":[\"KIWI\"],\"custom\":[]}"))
                .andExpect(status().isBadRequest());
        assertThat(jdbc.queryForList("""
                select pa.ingredient_name from profile_allergies pa join profiles p on p.id = pa.profile_id
                where p.user_id = ?""", String.class, USER)).isEqualTo(List.of());
    }
}
