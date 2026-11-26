package com.mealfit.domain.intake;

import static com.mealfit.support.TestJwt.user;
import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.domain.intake.repository.IntakeLogRepository;
import com.mealfit.domain.mealplan.entity.MealPlan;
import com.mealfit.domain.mealplan.entity.MealType;
import com.mealfit.domain.mealplan.repository.MealPlanRepository;
import com.mealfit.domain.recipe.entity.Recipe;
import com.mealfit.domain.recipe.entity.RecipeSource;
import com.mealfit.domain.recipe.repository.RecipeRepository;
import com.mealfit.support.TestUserFixture;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
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

/** 섭취 기록(먹음·건너뜀) 저장·정정·멱등·권한·조회 통합 테스트 (FR-INT-01·02, BR-11). */
// [섭취기록]
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class IntakeLogApiTest {

    private static final long USER = 84001L;
    private static final long OTHER = 84002L;
    private static final String PATH = "/api/v1/intake-logs";
    private static final LocalDate TODAY = LocalDate.now(ZoneId.of("Asia/Seoul"));

    @Autowired MockMvc mvc;
    @Autowired ObjectMapper mapper;
    @Autowired JdbcTemplate jdbc;
    @Autowired RecipeRepository recipeRepository;
    @Autowired MealPlanRepository mealPlanRepository;
    @Autowired IntakeLogRepository intakeLogRepository;

    private Recipe recipe;

    @BeforeEach
    void setUp() {
        TestUserFixture.create(jdbc, USER);
        TestUserFixture.create(jdbc, OTHER);
        recipe = recipeRepository.save(Recipe.builder()
            .name("테스트 닭가슴살 샐러드")
            .servingSize(1)
            .cookTimeMin(15)
            .calories(BigDecimal.valueOf(420))
            .proteinG(BigDecimal.valueOf(38))
            .carbsG(BigDecimal.valueOf(20))
            .fatG(BigDecimal.valueOf(12))
            .nutritionEstimated(true)
            .source(RecipeSource.LOCAL_FALLBACK)
            .build());
    }

    private MealPlan saveMealPlan(long userId, LocalDate date, MealType type, boolean confirm, boolean cancel) {
        MealPlan plan = MealPlan.builder()
            .userId(userId)
            .planDate(date)
            .mealType(type)
            .recipe(recipe)
            .servings(1)
            .recommendationReason("테스트 식단")
            .build();
        if (confirm) {
            plan.confirm();
        }
        if (cancel) {
            plan.cancel();
        }
        return mealPlanRepository.save(plan);
    }

    private ResultActions record(long userId, Long mealPlanId, String status) throws Exception {
        return mvc.perform(post(PATH).with(user(userId))
            .contentType(MediaType.APPLICATION_JSON)
            .content(mapper.writeValueAsString(Map.of("mealPlanId", mealPlanId, "intakeStatus", status))));
    }

    @Test
    void 확정식단에_먹음_기록후_건너뜀으로_정정하고_동일상태_재요청은_멱등처리한다() throws Exception {
        MealPlan plan = saveMealPlan(USER, TODAY, MealType.LUNCH, true, false);

        // 1) 최초 기록: EATEN
        record(USER, plan.getId(), "EATEN")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.mealPlanId").value(plan.getId()))
            .andExpect(jsonPath("$.planDate").value(TODAY.toString()))
            .andExpect(jsonPath("$.mealType").value("LUNCH"))
            .andExpect(jsonPath("$.intakeStatus").value("EATEN"))
            .andExpect(jsonPath("$.loggedAt").isNotEmpty());

        // 2) 동일 상태 재요청: 멱등 (중복 행 생성 없음)
        record(USER, plan.getId(), "EATEN")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.intakeStatus").value("EATEN"));
        assertThat(intakeLogRepository.findByUserIdAndPlanDate(USER, TODAY)).hasSize(1);

        // 3) 정정: EATEN -> SKIPPED
        record(USER, plan.getId(), "SKIPPED")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.intakeStatus").value("SKIPPED"));

        // 4) 재정정: SKIPPED -> EATEN
        record(USER, plan.getId(), "EATEN")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.intakeStatus").value("EATEN"));

        // 5) 과거 날짜 확정 식단도 기록 허용
        MealPlan yesterdayPlan = saveMealPlan(USER, TODAY.minusDays(1), MealType.DINNER, true, false);
        record(USER, yesterdayPlan.getId(), "SKIPPED")
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.intakeStatus").value("SKIPPED"));
    }

    @Test
    void PLANNED_복귀와_미래날짜와_미확정_취소식단은_거절한다() throws Exception {
        MealPlan confirmedToday = saveMealPlan(USER, TODAY, MealType.BREAKFAST, true, false);
        MealPlan draftToday = saveMealPlan(USER, TODAY, MealType.LUNCH, false, false);
        MealPlan canceledToday = saveMealPlan(USER, TODAY, MealType.DINNER, true, true);
        MealPlan futureConfirmed = saveMealPlan(USER, TODAY.plusDays(1), MealType.BREAKFAST, true, false);

        // PLANNED 전송 -> 400 INTAKE_002
        record(USER, confirmedToday.getId(), "PLANNED")
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("INTAKE_002"));

        // 미확정(DRAFT) 식단 -> 409 INTAKE_001
        record(USER, draftToday.getId(), "EATEN")
            .andExpect(status().isConflict())
            .andExpect(jsonPath("$.code").value("INTAKE_001"));

        // 취소(CANCELED) 식단 -> 409 INTAKE_001
        record(USER, canceledToday.getId(), "SKIPPED")
            .andExpect(status().isConflict())
            .andExpect(jsonPath("$.code").value("INTAKE_001"));

        // 미래 날짜 식단 -> 400 INTAKE_003
        record(USER, futureConfirmed.getId(), "EATEN")
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("INTAKE_003"));
    }

    @Test
    void 타인식단은_404로_거절하고_날짜별조회는_본인기록만_반환한다() throws Exception {
        MealPlan userBreakfast = saveMealPlan(USER, TODAY, MealType.BREAKFAST, true, false);
        MealPlan otherBreakfast = saveMealPlan(OTHER, TODAY, MealType.BREAKFAST, true, false);

        // 타인 식단 기록 시도 -> 404 MEAL_PLAN_001
        record(OTHER, userBreakfast.getId(), "EATEN")
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.code").value("MEAL_PLAN_001"));

        record(USER, userBreakfast.getId(), "EATEN").andExpect(status().isOk());
        record(OTHER, otherBreakfast.getId(), "SKIPPED").andExpect(status().isOk());

        // 날짜별 조회는 본인 기록만 반환
        mvc.perform(get(PATH).param("date", TODAY.toString()).with(user(USER)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.length()").value(1))
            .andExpect(jsonPath("$[0].mealPlanId").value(userBreakfast.getId()))
            .andExpect(jsonPath("$[0].intakeStatus").value("EATEN"));
    }
}
