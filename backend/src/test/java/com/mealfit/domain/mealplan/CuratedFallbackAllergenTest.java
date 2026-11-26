package com.mealfit.domain.mealplan;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.domain.inventory.entity.InventoryLot;
import com.mealfit.domain.inventory.entity.StorageLocation;
import com.mealfit.domain.inventory.repository.InventoryLotRepository;
import com.mealfit.domain.mealplan.repository.MealPlanRepository;
import com.mealfit.domain.recipe.entity.Recipe;
import com.mealfit.domain.recipe.entity.RecipeIngredient;
import com.mealfit.support.TestJwt;
import com.mealfit.support.TestUserFixture;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
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

/**
 * LLM이 없을 때 검수 레시피(V15·V16)로 대체하고, 알레르기 사전(V13)으로 확인 필요 재료까지 제외하는지 확인한다
 * (MEALFIT-140·143). 이 테스트 환경에는 AI 연결부가 없어 항상 로컬 대체로 간다.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class CuratedFallbackAllergenTest {

    private static final long USER = 86001L;
    private static final LocalDate DATE = LocalDate.now().plusDays(1);

    @Autowired MockMvc mvc;
    @Autowired ObjectMapper mapper;
    @Autowired JdbcTemplate jdbc;
    @Autowired MealPlanRepository mealPlanRepository;
    @Autowired InventoryLotRepository inventoryLotRepository;

    @BeforeEach
    void setUp() {
        TestUserFixture.create(jdbc, USER);
    }

    private void allergies(String... names) {
        Long profileId = jdbc.queryForObject("select id from profiles where user_id = ?", Long.class, USER);
        for (String name : names) {
            jdbc.update("insert into profile_allergies (profile_id, ingredient_name) values (?, ?)", profileId, name);
        }
    }

    private void lot(String name) {
        inventoryLotRepository.save(InventoryLot.builder().userId(USER).ingredientName(name)
                .quantity(new BigDecimal("300")).unit("g").expiryDate(LocalDate.now().plusDays(1))
                .storageLocation(StorageLocation.FRIDGE).build());
    }

    private List<Recipe> recommend() throws Exception {
        String body = mvc.perform(post("/api/v1/meal-plans/recommend").with(TestJwt.user(USER))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"planDate\":\"" + DATE + "\"}"))
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString();
        List<Recipe> recipes = new ArrayList<>();
        for (JsonNode plan : mapper.readTree(body).get("mealPlans")) {
            recipes.add(mealPlanRepository.findById(plan.get("id").asLong()).orElseThrow().getRecipe());
        }
        return recipes;
    }

    private static List<String> ingredients(Recipe recipe) {
        return recipe.getIngredients().stream().map(RecipeIngredient::getIngredientName).toList();
    }

    @Test
    void 보유_재료를_쓰는_검수_레시피로_대체한다() throws Exception {
        // 퀴노아는 기존 대체 레시피 9개에 없고 검수 레시피에만 있다
        lot("퀴노아");

        List<Recipe> recipes = recommend();

        Recipe lunch = recipes.get(1);
        assertThat(lunch.getRecipeCode()).isNotNull();
        assertThat(ingredients(lunch)).contains("퀴노아");
        assertThat(recipes.get(0).getMealSlot()).isNotEqualTo(com.mealfit.domain.recipe.entity.RecipeMealSlot.LUNCH_DINNER);
    }

    @Test
    void 같은_날_같은_요리의_변형은_다시_고르지_않는다() throws Exception {
        lot("퀴노아");

        List<Recipe> recipes = recommend();

        Recipe lunch = recipes.get(1);
        Recipe dinner = recipes.get(2);
        assertThat(lunch.getDishGroup()).isNotNull();
        assertThat(dinner.getDishGroup()).isNotEqualTo(lunch.getDishGroup());
    }

    @Test
    void 밀_알레르기는_확인_필요_재료가_든_레시피도_제외한다() throws Exception {
        allergies("밀");
        lot("오트밀");
        lot("통밀 식빵");

        for (Recipe recipe : recommend()) {
            assertThat(ingredients(recipe))
                    .doesNotContain("간장", "된장", "오트밀", "통밀 식빵", "통밀 또띠아", "메밀면", "잡곡밥", "김치");
        }
    }

    @Test
    void 레시피별로_알레르기에_걸리는_이유를_알려준다() throws Exception {
        allergies("밀", "계란", "키위");
        Long recipeId = jdbc.queryForObject("""
                select r.id from recipes r where r.recipe_code is not null
                and exists (select 1 from recipe_ingredients i where i.recipe_id = r.id and i.ingredient_name = '간장')
                and exists (select 1 from recipe_ingredients i where i.recipe_id = r.id and i.ingredient_name = '달걀')
                order by r.id limit 1""", Long.class);

        mvc.perform(get("/api/v1/recipes/{id}/allergen-check", recipeId).with(TestJwt.user(USER)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.safe").value(false))
                .andExpect(jsonPath("$.warnings[?(@.ingredientName == '간장')].reason").value("MAY_CONTAIN"))
                .andExpect(jsonPath("$.warnings[?(@.ingredientName == '간장')].allergen").value("밀"))
                .andExpect(jsonPath("$.warnings[?(@.ingredientName == '달걀')].reason").value("CONTAINS"));

        Long safeId = jdbc.queryForObject("""
                select r.id from recipes r where r.recipe_code is not null
                and not exists (select 1 from recipe_ingredients i join ingredient_allergens ia
                    on ia.ingredient_name = i.ingredient_name where i.recipe_id = r.id)
                order by r.id limit 1""", Long.class);
        mvc.perform(get("/api/v1/recipes/{id}/allergen-check", safeId).with(TestJwt.user(USER)))
                .andExpect(jsonPath("$.safe").value(true))
                .andExpect(jsonPath("$.warnings").isEmpty());
    }

    @Test
    void 직접_입력한_알레르기는_이름_포함으로_안내한다() throws Exception {
        // 양배추는 알레르기 사전에 없는 직접 입력이라 이름 포함 검사로 걸린다
        allergies("양배추");
        Long recipeId = jdbc.queryForObject("""
                select r.id from recipes r where r.recipe_code is not null
                and exists (select 1 from recipe_ingredients i where i.recipe_id = r.id and i.ingredient_name = '양배추')
                order by r.id limit 1""", Long.class);

        mvc.perform(get("/api/v1/recipes/{id}/allergen-check", recipeId).with(TestJwt.user(USER)))
                .andExpect(jsonPath("$.safe").value(false))
                .andExpect(jsonPath("$.warnings[?(@.ingredientName == '양배추')].reason").value("NAME_MATCH"))
                .andExpect(jsonPath("$.warnings[?(@.ingredientName == '양배추')].allergen").value("양배추"));
        mvc.perform(get("/api/v1/recipes/{id}/allergen-check", 999_999_999L).with(TestJwt.user(USER)))
                .andExpect(status().isNotFound());
    }
}
