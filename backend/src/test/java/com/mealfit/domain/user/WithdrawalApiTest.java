package com.mealfit.domain.user;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.reset;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.domain.auth.repository.EmailVerificationTokenRepository;
import com.mealfit.domain.auth.repository.RefreshTokenRepository;
import com.mealfit.domain.user.repository.ProfileRepository;
import com.mealfit.domain.user.repository.UserRepository;
import jakarta.servlet.http.Cookie;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
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
    @MockitoSpyBean RefreshTokenRepository tokens;
    @Autowired EmailVerificationTokenRepository verificationTokens;
    @Autowired PlatformTransactionManager transactionManager;
    @Autowired jakarta.persistence.EntityManager entityManager;
    private final List<Long> createdUsers = new ArrayList<>();

    private record SessionInfo(long userId, String email, String accessToken, String refreshToken) {}

    @AfterEach
    void cleanup() {
        reset(tokens);
        new TransactionTemplate(transactionManager).executeWithoutResult(status -> {
            for (long id : createdUsers) {
                verificationTokens.deleteAll(verificationTokens.findAll().stream()
                    .filter(t -> t.getUserId().equals(id)).toList());
                tokens.deleteAll(tokens.findAll().stream().filter(token -> token.getUserId().equals(id)).toList());
                profiles.findByUserId(id).ifPresent(profiles::delete);
                profiles.flush();
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
    void 성공시_탈퇴기록과_모든세션폐기가_커밋되고_기존정보는_유지된다() throws Exception {
        var first = signup();
        var second = login(first.email());
        long id = first.userId();
        withdraw(first, PASSWORD).andExpect(status().isNoContent()).andExpect(content().string(""));

        assertThat(users.findById(id).orElseThrow().getDeletedAt()).isNotNull();
        assertThat(profiles.findByUserId(id)).isPresent();
        var sessions = tokens.findAll().stream().filter(token -> token.getUserId().equals(id)).toList();
        assertThat(sessions).hasSize(2).allMatch(token -> token.isRevoked());
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

        assertThat(users.findById(first.userId()).orElseThrow().getEmail())
            .startsWith("withdrawn_")
            .endsWith("@deleted.local");

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
    void 토큰폐기에서_실패하면_탈퇴기록도_롤백된다() throws Exception {
        var session = signup();
        long id = session.userId();
        doAnswer(invocation -> {
            entityManager.flush();
            throw new IllegalStateException("테스트용 토큰 폐기 실패");
        }).when(tokens).revokeAllByUserId(id);
        try {
            withdraw(session, PASSWORD).andExpect(status().isInternalServerError());
        } finally {
            reset(tokens);
        }
        assertThat(users.findById(id).orElseThrow().getDeletedAt()).isNull();
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
            assertThat(users.findById(id).orElseThrow().getDeletedAt()).isNotNull();
            assertThat(tokens.findAll().stream().filter(token -> token.getUserId().equals(id)))
                .allMatch(token -> token.isRevoked());
        } finally {
            start.countDown();
            executor.shutdownNow();
        }
    }
}
