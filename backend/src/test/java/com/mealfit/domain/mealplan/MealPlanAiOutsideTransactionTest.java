package com.mealfit.domain.mealplan;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;

import com.mealfit.domain.mealplan.client.MealPlanAiClient;
import com.mealfit.domain.mealplan.dto.MealPlanRecommendRequest;
import com.mealfit.domain.mealplan.service.MealPlanRecommender;
import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.support.TestUserFixture;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.transaction.support.TransactionTemplate;

/**
 * AI 응답을 기다리는 동안 트랜잭션·회원 잠금을 붙잡지 않는다 (TRD AI-01).
 * 붙잡으면 같은 회원의 로그인·토큰 재발급이 AI 응답 시간(최대 20초)만큼 멈춘다.
 * 실제 커밋·잠금을 봐야 하므로 테스트 트랜잭션을 쓰지 않고, 끝나면 이 사용자의 데이터를 지운다.
 */
@SpringBootTest
@ActiveProfiles("test")
class MealPlanAiOutsideTransactionTest {

    private static final Long USER = 7101L;
    private static final LocalDate DATE = LocalDate.now(ZoneId.of("Asia/Seoul")).plusDays(1);

    @Autowired
    private MealPlanRecommender mealPlanRecommender;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private TransactionTemplate transactionTemplate;
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @MockitoBean
    private MealPlanAiClient aiClient;

    private TestUserFixture userFixture;

    @BeforeEach
    void setUp() {
        userFixture = TestUserFixture.create(jdbcTemplate, USER);
    }

    @AfterEach
    void cleanUp() {
        jdbcTemplate.update("delete from meal_plans where user_id = ?", USER);
        jdbcTemplate.update("delete from recipes where user_id = ?", USER);
        if (userFixture != null) {
            userFixture.close();
        }
    }

    @Test
    void AI를_기다리는_동안_트랜잭션과_회원_잠금을_잡지_않는다() {
        AtomicBoolean inTransaction = new AtomicBoolean(true);
        AtomicBoolean otherRequestLockedUser = new AtomicBoolean(false);
        given(aiClient.recommend(any())).willAnswer(invocation -> {
            inTransaction.set(TransactionSynchronizationManager.isActualTransactionActive());
            // 로그인·재발급처럼 같은 회원 행을 잠그는 다른 요청이 바로 처리되는지 확인한다
            CompletableFuture<Boolean> other = CompletableFuture.supplyAsync(() ->
                    transactionTemplate.execute(status -> userRepository.findByIdForUpdate(USER).isPresent()));
            try {
                otherRequestLockedUser.set(other.get(3, TimeUnit.SECONDS));
            } catch (Exception timeoutOrFailure) {
                otherRequestLockedUser.set(false);
            }
            return List.of(); // 결과는 로컬 대체로 채운다
        });

        var response = mealPlanRecommender.recommend(USER, new MealPlanRecommendRequest(DATE, 1));

        assertThat(inTransaction).isFalse();
        assertThat(otherRequestLockedUser).isTrue();
        assertThat(response.mealPlans()).hasSize(3);
    }
}
