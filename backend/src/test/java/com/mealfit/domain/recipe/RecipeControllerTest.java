package com.mealfit.domain.recipe;

import com.mealfit.domain.recipe.entity.Recipe;
import com.mealfit.domain.recipe.entity.RecipeSource;
import com.mealfit.domain.recipe.repository.RecipeRepository;
import com.mealfit.domain.recipe.service.RecipeService;
import com.mealfit.domain.recipe.dto.RecipeCatalogResponse;
import com.mealfit.support.TestJwt;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.assertj.core.api.Assertions.assertThat;

import java.math.BigDecimal;
import java.util.List;
import java.util.ArrayList;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class RecipeControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired JdbcTemplate jdbc;
    @Autowired RecipeService service;

    @Test
    void 비회원이_CSV_전체_목록과_마지막_레시피_상세를_열_수_있다() throws Exception {
        List<Long> curated = jdbc.queryForList("select id from recipes where recipe_code is not null order by id", Long.class);
        assertThat(curated).hasSize(2481);
        var first = service.getPublicCatalog(1);
        List<Long> ids = new ArrayList<>();
        for (int page = 1; page <= first.totalPages(); page++) {
            service.getPublicCatalog(page).items().stream().map(RecipeCatalogResponse.Item::id).forEach(ids::add);
        }
        assertThat(ids).containsAll(curated).doesNotHaveDuplicates().hasSize((int) first.total());
        mockMvc.perform(get("/api/v1/recipes/public").param("page", String.valueOf(first.totalPages())))
                .andExpect(status().isOk()).andExpect(jsonPath("$.items[0].name").isNotEmpty());
        mockMvc.perform(get("/api/v1/recipes/public/{id}", curated.getLast()))
                .andExpect(status().isOk()).andExpect(jsonPath("$.ingredients[0].ingredientName").isNotEmpty())
                .andExpect(jsonPath("$.steps[0]").isNotEmpty());
    }

    @Test
    void 개인_레시피는_공개_목록과_상세에서_제외한다() throws Exception {
        long total = service.getPublicCatalog(1).total();
        var privateRecipe = saveRecipe(7L);
        mockMvc.perform(get("/api/v1/recipes/public")).andExpect(jsonPath("$.total").value(total));
        mockMvc.perform(get("/api/v1/recipes/public/{id}", privateRecipe.getId())).andExpect(status().isNotFound());
        mockMvc.perform(get("/api/v1/recipes/public/{id}", privateRecipe.getId()).with(TestJwt.user(7L)))
                .andExpect(status().isNotFound());
        mockMvc.perform(get("/api/v1/recipes/{id}", privateRecipe.getId())).andExpect(status().isUnauthorized());
        mockMvc.perform(get("/api/v1/recipes/public").param("page", "0")).andExpect(status().isBadRequest());
    }

    private Recipe saveRecipe(Long userId) {
        Recipe recipe = Recipe.builder()
                .userId(userId)
                .name("닭가슴살 샐러드")
                .servingSize(2)
                .cookTimeMin(15)
                .calories(new BigDecimal("420.0"))
                .nutritionEstimated(true)
                .source(RecipeSource.SEED)
                .steps(List.of("닭가슴살을 굽는다.", "채소와 섞는다."))
                .build();
        recipe.addIngredient("닭가슴살", new BigDecimal("300"), "g");
        recipe.addIngredient("달걀", new BigDecimal("1"), "개");
        return recipeRepository.save(recipe);
    }

    @Test
    void 요청한_인분으로_재료량을_환산한다() throws Exception {
        Recipe recipe = saveRecipe(null);

        mockMvc.perform(get("/api/v1/recipes/{id}", recipe.getId()).with(TestJwt.user(1L)).param("servings", "3"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.servingSize").value(2))
                .andExpect(jsonPath("$.servings").value(3))
                .andExpect(jsonPath("$.source").value("SEED"))
                .andExpect(jsonPath("$.nutritionEstimated").value(true))
                .andExpect(jsonPath("$.steps[1]").value("채소와 섞는다."))
                .andExpect(jsonPath("$.ingredients[0].ingredientName").value("닭가슴살"))
                .andExpect(jsonPath("$.ingredients[0].quantity").value(450.0))
                .andExpect(jsonPath("$.ingredients[0].unit").value("g"))
                // 달걀 1개 × 3/2 = 1.5개 → 개수 단위는 올림해 2개
                .andExpect(jsonPath("$.ingredients[1].quantity").value(2.0));
    }

    @Test
    void 인분이_없으면_기준_인분() throws Exception {
        Recipe recipe = saveRecipe(null);

        mockMvc.perform(get("/api/v1/recipes/{id}", recipe.getId()).with(TestJwt.user(1L)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.servings").value(2))
                .andExpect(jsonPath("$.ingredients[0].quantity").value(300.0));
    }

    @Test
    void 본인_레시피는_조회된다() throws Exception {
        Recipe recipe = saveRecipe(7L);

        mockMvc.perform(get("/api/v1/recipes/{id}", recipe.getId()).with(TestJwt.user(7L)))
                .andExpect(status().isOk());
    }

    @Test
    void 다른_사용자의_레시피는_404() throws Exception {
        Recipe recipe = saveRecipe(7L);

        mockMvc.perform(get("/api/v1/recipes/{id}", recipe.getId()).with(TestJwt.user(8L)))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.code").value("RECIPE_001"));
    }

    @Test
    void 없는_레시피는_404() throws Exception {
        mockMvc.perform(get("/api/v1/recipes/{id}", 999_999).with(TestJwt.user(1L)))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.code").value("RECIPE_001"));
    }

    @Test
    void 인분이_1_미만이면_400() throws Exception {
        Recipe recipe = saveRecipe(null);

        mockMvc.perform(get("/api/v1/recipes/{id}", recipe.getId()).with(TestJwt.user(1L)).param("servings", "0"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("COMMON_400"));
    }
}
