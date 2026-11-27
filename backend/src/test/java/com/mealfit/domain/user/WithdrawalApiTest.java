package com.mealfit.domain.user;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doAnswer;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.domain.auth.repository.RefreshTokenRepository;
import com.mealfit.domain.inventory.service.InventoryService;
import com.mealfit.domain.user.repository.ProfileRepository;
import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.domain.user.repository.WithdrawalDataRepository;
import jakarta.servlet.http.Cookie;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoSpyBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

/** 테스트 트랜잭션으로 감싸지 않고 실제 커밋·롤백과 기존 토큰 차단을 확인합니다. */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class WithdrawalApiTest {
    private static final String PASSWORD = "Withdrawal123!";
    @Autowired MockMvc mvc;
    @Autowired ObjectMapper mapper;
    @Autowired UserRepository users;
    @Autowired ProfileRepository profiles;
    @Autowired RefreshTokenRepository tokens;
    @Autowired WithdrawalDataRepository withdrawalData;
    @Autowired JdbcTemplate jdbc;
    @Autowired PlatformTransactionManager transactionManager;
    @MockitoSpyBean InventoryService inventory;
    private final List<Long> createdUsers = new ArrayList<>();

    private record SessionInfo(long userId, String email, String accessToken, String refreshToken) {}

    @AfterEach
    void cleanup() {
        new TransactionTemplate(transactionManager).executeWithoutResult(status -> {
            for (long id : createdUsers.reversed()) {
                withdrawalData.deleteByUserId(id);
                users.deleteById(id);
            }
        });
        createdUsers.clear();
    }

    private String extractRefreshCookie(List<String> setCookies) {
        for (String header : setCookies) {
            if (header.startsWith("refresh_token=")) {
                String value = header.substring("refresh_token=".length());
                int semi = value.indexOf(';');
                return semi >= 0 ? value.substring(0, semi) : value;
            }
        }
        return "";
    }

    private SessionInfo signup() throws Exception {
        String email = "withdraw-" + UUID.randomUUID() + "@example.com";
        mvc.perform(post("/api/v1/auth/signup").contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("email", email,
                    "password", PASSWORD, "nickname", "탈퇴테스트"))))
            .andExpect(status().isCreated());
        long userId = users.findByEmail(email).orElseThrow().getId();
        createdUsers.add(userId);
        // [이메일인증] 탈퇴 테스트용 회원을 인증 완료 상태로 전환 후 로그인
        new TransactionTemplate(transactionManager).executeWithoutResult(status -> {
            users.findByIdForUpdate(userId).orElseThrow().markEmailVerified();
        });
        return login(email);
    }

    private SessionInfo login(String email) throws Exception {
        var response = mvc.perform(post("/api/v1/auth/login").contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("email", email, "password", PASSWORD))))
            .andExpect(status().isOk()).andReturn().getResponse();
        JsonNode body = mapper.readTree(response.getContentAsString());
        String refreshCookie = extractRefreshCookie(response.getHeaders(HttpHeaders.SET_COOKIE));
        return new SessionInfo(
            body.path("user").path("id").asLong(),
            body.path("user").path("email").asText(),
            body.path("accessToken").asText(),
            refreshCookie
        );
    }

    private ResultActions withdraw(SessionInfo session, String password) throws Exception {
        return mvc.perform(delete("/api/v1/me").header("Authorization", "Bearer " + session.accessToken())
            .contentType(MediaType.APPLICATION_JSON).content(mapper.writeValueAsString(Map.of("password", password))));
    }

    private ResultActions refresh(SessionInfo session) throws Exception {
        return mvc.perform(post("/api/v1/auth/refresh")
            .header("X-Requested-With", "XMLHttpRequest")
            .cookie(new Cookie("refresh_token", session.refreshToken())));
    }

    @Test
    void 성공시_본인계정과_전체세션을_삭제하고_기존토큰을_차단한다() throws Exception {
        var first = signup();
        var second = login(first.email());
        long id = first.userId();
        withdraw(first, PASSWORD).andExpect(status().isNoContent()).andExpect(content().string(""));

        assertThat(users.findById(id)).isEmpty();
        assertThat(profiles.findByUserId(id)).isEmpty();
        assertThat(countBy("refresh_tokens", "user_id", id)).isZero();
        assertThat(countBy("email_verification_tokens", "user_id", id)).isZero();
        refresh(first).andExpect(status().isUnauthorized());
        refresh(second).andExpect(status().isUnauthorized());
        mvc.perform(get("/api/v1/me").header("Authorization", "Bearer " + second.accessToken()))
            .andExpect(status().isUnauthorized());
        mvc.perform(post("/api/v1/auth/login").contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("email", first.email(), "password", PASSWORD))))
            .andExpect(status().isUnauthorized());
    }

    @Test
    void 탈퇴한_이메일로_재가입하고_인증후_로그인할수있다() throws Exception {
        var first = signup();
        String originalEmail = first.email();
        withdraw(first, PASSWORD).andExpect(status().isNoContent());

        assertThat(users.findById(first.userId())).isEmpty();
        assertThat(users.findByEmail(originalEmail)).isEmpty();

        // 같은 이메일로 재가입 가능
        mvc.perform(post("/api/v1/auth/signup").contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of(
                    "email", originalEmail,
                    "password", PASSWORD,
                    "nickname", "재가입회원"
                ))))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.email").value(originalEmail));

        long rejoinedId = users.findByEmail(originalEmail).orElseThrow().getId();
        createdUsers.add(rejoinedId);
        assertThat(rejoinedId).isNotEqualTo(first.userId());

        // 새 계정 인증 후 로그인 및 보호 API 호출 성공
        new TransactionTemplate(transactionManager).executeWithoutResult(status -> {
            users.findByIdForUpdate(rejoinedId).orElseThrow().markEmailVerified();
        });
        var rejoined = login(originalEmail);
        assertThat(rejoined.userId()).isEqualTo(rejoinedId);
        mvc.perform(get("/api/v1/me").header("Authorization", "Bearer " + rejoined.accessToken()))
            .andExpect(status().isOk());
    }

    @Test
    void 비밀번호가_틀리면_회원과_토큰을_변경하지않는다() throws Exception {
        var session = signup();
        long id = session.userId();
        withdraw(session, "Wrong123!").andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("USER_001"));
        assertThat(users.findById(id).orElseThrow().getDeletedAt()).isNull();
        assertThat(tokens.findAll().stream().filter(token -> token.getUserId().equals(id)))
            .noneMatch(token -> token.isRevoked());
        refresh(session).andExpect(status().isOk());
    }

    @Test
    void 비밀번호누락과_공백과_길이초과를_거절한다() throws Exception {
        var session = signup();
        for (String password : List.of("", " ", "x".repeat(73), "한".repeat(25))) {
            withdraw(session, password).andExpect(status().isBadRequest());
        }
        mvc.perform(delete("/api/v1/me").header("Authorization", "Bearer " + session.accessToken())
                .contentType(MediaType.APPLICATION_JSON).content("{}"))
            .andExpect(status().isBadRequest());
        assertThat(users.findById(session.userId()).orElseThrow().getDeletedAt()).isNull();
    }

    @Test
    void 인증없이_다른회원ID만_전달해서는_탈퇴할수없다() throws Exception {
        var session = signup();
        long id = session.userId();
        mvc.perform(delete("/api/v1/me").header("X-User-Id", id).contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("password", PASSWORD))))
            .andExpect(status().isUnauthorized());
        assertThat(users.findById(id).orElseThrow().getDeletedAt()).isNull();
    }

    @Test
    void 요청의_다른회원ID는_무시하고_본인만_탈퇴한다() throws Exception {
        var own = signup();
        var other = signup();
        long otherId = other.userId();
        mvc.perform(delete("/api/v1/me").header("Authorization", "Bearer " + own.accessToken())
                .header("X-User-Id", otherId).queryParam("userId", Long.toString(otherId))
                .contentType(MediaType.APPLICATION_JSON).content(mapper.writeValueAsString(Map.of("password", PASSWORD, "userId", otherId))))
            .andExpect(status().isNoContent());
        assertThat(users.findById(otherId).orElseThrow().getDeletedAt()).isNull();
        assertThat(tokens.findAll().stream().filter(token -> token.getUserId().equals(otherId)))
            .noneMatch(token -> token.isRevoked());
        refresh(other).andExpect(status().isOk());
    }

    @Test
    void 레시피삭제에서_실패하면_앞에서_지운_본인식단과_섭취기록도_롤백된다() throws Exception {
        var session = signup();
        long id = session.userId();
        long otherId = signup().userId();
        long recipeId = createRecipe(id);
        long mealId = createMealPlan(id, recipeId);
        saveIntake(id, mealId);
        // 레거시 데이터에서 다른 회원이 참조하는 경우 그 회원의 식단은 삭제할 수 없다.
        long otherMealId = createMealPlan(otherId, recipeId);

        withdraw(session, PASSWORD).andExpect(status().isInternalServerError())
            .andExpect(jsonPath("$.code").value("COMMON_500"));
        assertThat(users.findById(id).orElseThrow().getDeletedAt()).isNull();
        assertThat(countBy("meal_plans", "id", mealId)).isOne();
        assertThat(countBy("intake_logs", "meal_plan_id", mealId)).isOne();
        assertThat(countBy("meal_plans", "id", otherMealId)).isOne();
        assertThat(countBy("recipes", "id", recipeId)).isOne();
        assertThat(tokens.findAll().stream().filter(token -> token.getUserId().equals(id)))
            .noneMatch(token -> token.isRevoked());
        refresh(session).andExpect(status().isOk());
    }

    @Test
    void 탈퇴와_재발급이_동시에와도_탈퇴완료후_활성세션이_남지않는다() throws Exception {
        var session = signup();
        long id = session.userId();
        var ready = new CountDownLatch(2);
        var start = new CountDownLatch(1);
        var executor = Executors.newFixedThreadPool(2);
        try {
            var withdrawal = executor.submit(() -> {
                ready.countDown();
                if (!start.await(10, TimeUnit.SECONDS)) throw new IllegalStateException("대기 시간 초과");
                return withdraw(session, PASSWORD).andReturn().getResponse().getStatus();
            });
            var refreshing = executor.submit(() -> {
                ready.countDown();
                if (!start.await(10, TimeUnit.SECONDS)) throw new IllegalStateException("대기 시간 초과");
                return refresh(session).andReturn().getResponse().getStatus();
            });
            assertThat(ready.await(10, TimeUnit.SECONDS)).isTrue();
            start.countDown();
            assertThat(withdrawal.get(20, TimeUnit.SECONDS)).isEqualTo(204);
            assertThat(refreshing.get(20, TimeUnit.SECONDS)).isIn(200, 401);
            assertThat(users.findById(id)).isEmpty();
            assertThat(countBy("refresh_tokens", "user_id", id)).isZero();
        } finally {
            start.countDown();
            executor.shutdownNow();
        }
    }

    @Test
    void 탈퇴는_진행중인_입고를_기다린_뒤_재고를_삭제한다() throws Exception {
        var member = signup();
        var saving = new CountDownLatch(1);
        var finishSaving = new CountDownLatch(1);
        var withdrawing = new CountDownLatch(1);
        doAnswer(invocation -> {
            saving.countDown();
            if (!finishSaving.await(10, TimeUnit.SECONDS)) throw new IllegalStateException("입고 대기 시간 초과");
            return invocation.callRealMethod();
        }).when(inventory).stockIn(eq(member.userId()), any());

        var executor = Executors.newFixedThreadPool(2);
        try {
            var stock = executor.submit(() -> mvc.perform(post("/api/v1/inventory/lots")
                    .header("Authorization", "Bearer " + member.accessToken())
                    .contentType(MediaType.APPLICATION_JSON)
                    .content("""
                        {"ingredientName":"rice","quantity":100,"unit":"g","storageLocation":"PANTRY"}
                        """))
                .andReturn().getResponse().getStatus());
            assertThat(saving.await(10, TimeUnit.SECONDS)).isTrue();
            var deletion = executor.submit(() -> {
                withdrawing.countDown();
                return withdraw(member, PASSWORD).andReturn().getResponse().getStatus();
            });
            assertThat(withdrawing.await(10, TimeUnit.SECONDS)).isTrue();
            assertThatThrownBy(() -> deletion.get(250, TimeUnit.MILLISECONDS)).isInstanceOf(TimeoutException.class);
            finishSaving.countDown();
            assertThat(stock.get(10, TimeUnit.SECONDS)).isEqualTo(201);
            assertThat(deletion.get(10, TimeUnit.SECONDS)).isEqualTo(204);
            assertThat(countBy("inventory_lots", "user_id", member.userId())).isZero();
            assertThat(countBy("inventory_transactions", "user_id", member.userId())).isZero();
        } finally {
            finishSaving.countDown();
            executor.shutdownNow();
        }
    }

    @Test
    void 본인_운동_섭취_재고_프로필_소셜기록만_삭제한다() throws Exception {
        var own = signup();
        var other = signup();
        long ownId = own.userId();
        long otherId = other.userId();
        var ownData = createMemberData(ownId);
        var otherData = createMemberData(otherId);
        int sharedRecipes = jdbc.queryForObject("select count(*) from recipes where user_id is null", Integer.class);
        assertThat(sharedRecipes).isPositive();

        withdraw(own, PASSWORD).andExpect(status().isNoContent());

        assertThat(users.findById(ownId)).isEmpty();
        assertThat(users.findById(otherId)).isPresent();
        for (String table : List.of("inventory_batch_requests", "workout_logs", "workout_sessions", "workout_routines",
            "inventory_transactions", "inventory_lots", "intake_logs", "cooking_events", "meal_plans", "recipes",
            "shopping_items", "profiles", "user_social_accounts", "refresh_tokens", "email_verification_tokens")) {
            assertThat(countBy(table, "user_id", ownId)).as(table).isZero();
            assertThat(countBy(table, "user_id", otherId)).as(table).isOne();
        }
        for (String table : List.of("profile_allergies", "profile_excluded_ingredients", "profile_details",
            "profile_detail_equipment", "profile_detail_injuries", "profile_detail_preferred_foods")) {
            assertThat(countBy(table, "profile_id", ownData.profileId())).as(table).isZero();
            assertThat(countBy(table, "profile_id", otherData.profileId())).as(table).isOne();
        }
        for (String table : List.of("recipe_steps", "recipe_ingredients")) {
            assertThat(countBy(table, "recipe_id", ownData.recipeId())).as(table).isZero();
            assertThat(countBy(table, "recipe_id", otherData.recipeId())).as(table).isOne();
        }
        assertThat(jdbc.queryForObject("select count(*) from recipes where user_id is null", Integer.class))
            .isEqualTo(sharedRecipes);
    }

    private record MemberData(long profileId, long recipeId) {}

    private MemberData createMemberData(long userId) {
        long profileId = profiles.findByUserId(userId).orElseThrow().getId();
        jdbc.update("insert into profile_allergies (profile_id, ingredient_name) values (?, 'egg')", profileId);
        jdbc.update("insert into profile_excluded_ingredients (profile_id, ingredient_name) values (?, 'onion')", profileId);
        jdbc.update("""
            insert into profile_details (profile_id, created_at, updated_at)
            values (?, current_timestamp, current_timestamp)
            """, profileId);
        jdbc.update("insert into profile_detail_equipment (profile_id, item_name) values (?, 'mat')", profileId);
        jdbc.update("insert into profile_detail_injuries (profile_id, item_name) values (?, 'knee')", profileId);
        jdbc.update("insert into profile_detail_preferred_foods (profile_id, item_name) values (?, 'apple')", profileId);
        jdbc.update("""
            insert into user_social_accounts (user_id, provider, provider_user_id, created_at, updated_at)
            values (?, 'GOOGLE', ?, current_timestamp, current_timestamp)
            """, userId, "withdrawal-" + userId);
        // 영수증 일괄 등록의 중복 방지 기록 (V17)
        jdbc.update("""
            insert into inventory_batch_requests (user_id, client_request_id, payload_sha256, response_json, created_at)
            values (?, ?, repeat('0', 64), '{}', current_timestamp)
            """, userId, "batch-" + userId);

        createWorkoutData(userId);
        long recipeId = createRecipe(userId);
        jdbc.update("insert into recipe_steps (recipe_id, step_order, description) values (?, 1, 'cook')", recipeId);
        jdbc.update("""
            insert into recipe_ingredients (recipe_id, ingredient_name, required_qty, unit)
            values (?, 'rice', 100, 'g')
            """, recipeId);
        long mealId = createMealPlan(userId, recipeId);
        saveIntake(userId, mealId);
        createInventoryData(userId, recipeId, mealId);
        return new MemberData(profileId, recipeId);
    }

    private void createWorkoutData(long userId) {
        jdbc.update("""
            insert into workout_routines (user_id, goal, level, days_per_week, session_minutes, equipment_snapshot,
                injuries_snapshot, intensity_cap, source, rule_version, status, start_date, planned_until, created_at, updated_at)
            values (?, 'FITNESS', 'BEGINNER', 2, 15, '[]', '[]', 1, 'RULE', 'v1', 'ACTIVE',
                current_date, current_date, current_timestamp, current_timestamp)
            """, userId);
        jdbc.update("""
            insert into workout_sessions (user_id, routine_id, session_date, focus_area, title, planned_minutes,
                items, source, created_at, updated_at)
            values (?, ?, current_date, 'FULL_BODY', 'Session', 15, '[]', 'RULE', current_timestamp, current_timestamp)
            """, userId, findOwnedId("workout_routines", userId));
        jdbc.update("""
            insert into workout_logs (user_id, session_id, workout_date, status, logged_at, created_at, updated_at)
            values (?, ?, current_date, 'COMPLETED', current_timestamp, current_timestamp, current_timestamp)
            """, userId, findOwnedId("workout_sessions", userId));
    }

    private long createRecipe(long userId) {
        jdbc.update("""
            insert into recipes (user_id, name, serving_size, cook_time_min, source, created_at, updated_at)
            values (?, 'Recipe', 1, 10, 'AI_GENERATED', current_timestamp, current_timestamp)
            """, userId);
        return findOwnedId("recipes", userId);
    }

    private long createMealPlan(long userId, long recipeId) {
        jdbc.update("""
            insert into meal_plans (user_id, plan_date, meal_type, recipe_id, status, created_at, updated_at)
            values (?, current_date, 'LUNCH', ?, 'CONFIRMED', current_timestamp, current_timestamp)
            """, userId, recipeId);
        return findOwnedId("meal_plans", userId);
    }

    private void saveIntake(long userId, long mealId) {
        jdbc.update("""
            insert into intake_logs (user_id, meal_plan_id, intake_status, logged_at, created_at, updated_at)
            values (?, ?, 'EATEN', current_timestamp, current_timestamp, current_timestamp)
            """, userId, mealId);
    }

    private void createInventoryData(long userId, long recipeId, long mealId) {
        jdbc.update("""
            insert into cooking_events (user_id, recipe_id, meal_plan_id, servings, status, recipe_name,
                cooked_at, created_at, updated_at)
            values (?, ?, ?, 1, 'COOKED', 'Recipe', current_timestamp, current_timestamp, current_timestamp)
            """, userId, recipeId, mealId);
        jdbc.update("""
            insert into inventory_lots (user_id, ingredient_name, quantity, unit, storage_location,
                status, created_at, updated_at)
            values (?, 'rice', 100, 'g', 'PANTRY', 'ACTIVE', current_timestamp, current_timestamp)
            """, userId);
        jdbc.update("""
            insert into inventory_transactions (user_id, lot_id, cooking_event_id, type, qty_change, created_at, updated_at)
            values (?, ?, ?, 'COOK_DEDUCT', -10, current_timestamp, current_timestamp)
            """, userId, findOwnedId("inventory_lots", userId), findOwnedId("cooking_events", userId));
        jdbc.update("""
            insert into shopping_items (user_id, ingredient_name, required_qty, unit, status, created_at, updated_at)
            values (?, 'rice', 100, 'g', 'NEEDED', current_timestamp, current_timestamp)
            """, userId);
    }

    private long findOwnedId(String table, long userId) {
        return jdbc.queryForObject("select id from " + table + " where user_id = ?", Long.class, userId);
    }

    private int countBy(String table, String column, long id) {
        return jdbc.queryForObject("select count(*) from " + table + " where " + column + " = ?", Integer.class, id);
    }
}
