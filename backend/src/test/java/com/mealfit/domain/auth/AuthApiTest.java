package com.mealfit.domain.auth;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.domain.auth.repository.EmailVerificationTokenRepository;
import com.mealfit.domain.auth.repository.RefreshTokenRepository;
import com.mealfit.domain.auth.service.EmailSender;
import com.mealfit.domain.user.repository.ProfileRepository;
import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.global.security.JwtProperties;
import com.mealfit.global.security.RefreshTokenProvider;
import io.jsonwebtoken.Jwts;
import jakarta.servlet.http.Cookie;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import javax.crypto.spec.SecretKeySpec;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoSpyBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

/**
 * 실제 보안 필터·Service·H2 DB를 함께 검증합니다.
 * [이메일인증][HttpOnly쿠키] 가입 → 이메일 인증 → 로그인(HttpOnly 쿠키) → 재발급/로그아웃 흐름을 검증합니다.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class AuthApiTest {
    private static final String PASSWORD = "Mealfit123!";
    @Autowired MockMvc mvc;
    @Autowired ObjectMapper mapper;
    @Autowired UserRepository users;
    @Autowired ProfileRepository profiles;
    @Autowired RefreshTokenRepository tokens;
    @Autowired EmailVerificationTokenRepository verificationTokens;
    @MockitoSpyBean EmailSender emailSender;
    @Autowired RefreshTokenProvider refreshProvider;
    @Autowired PasswordEncoder passwordEncoder;
    @Autowired JwtProperties properties;
    @Autowired PlatformTransactionManager transactionManager;
    @Autowired jakarta.persistence.EntityManager entityManager;
    private final List<Long> createdUserIds = new ArrayList<>();

    private record AuthSession(String accessToken, String refreshToken, JsonNode body) {}

    /** 다른 기능 테스트의 데이터는 건드리지 않고 이 테스트 회원만 정리합니다. */
    @AfterEach
    void cleanup() {
        Mockito.reset(emailSender);
        new TransactionTemplate(transactionManager).executeWithoutResult(status -> {
            for (Long userId : createdUserIds) {
                verificationTokens.deleteAll(verificationTokens.findAll().stream()
                    .filter(t -> t.getUserId().equals(userId)).toList());
                tokens.deleteAll(tokens.findAll().stream()
                    .filter(token -> token.getUserId().equals(userId)).toList());
                profiles.findByUserId(userId).ifPresent(profiles::delete);
                profiles.flush();
                users.deleteById(userId);
                users.flush();
            }
        });
        createdUserIds.clear();
    }

    private String email() {
        return "auth-" + UUID.randomUUID() + "@example.com";
    }

    /** [HttpOnly쿠키] Set-Cookie 헤더에서 refresh_token 값을 추출합니다. */
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

    /** [이메일인증] 회원가입만 수행하고(토큰 미발급) 생성된 회원 ID를 기록합니다. */
    private void signupOnly(String rawEmail) throws Exception {
        mvc.perform(post("/api/v1/auth/signup")
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of(
                    "email", rawEmail, "password", PASSWORD, "nickname", "테스트회원"))))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.email").value(rawEmail.trim().toLowerCase(Locale.ROOT)))
            .andExpect(jsonPath("$.accessToken").doesNotExist());

        var user = users.findByEmail(rawEmail.trim().toLowerCase(Locale.ROOT)).orElseThrow();
        createdUserIds.add(user.getId());
    }

    /** [이메일인증] 테스트 편의를 위해 DB에서 회원을 인증 완료 처리합니다. */
    private void verifyUserInDb(String rawEmail) {
        String normalized = rawEmail.trim().toLowerCase(Locale.ROOT);
        new TransactionTemplate(transactionManager).executeWithoutResult(status -> {
            users.findByEmailForUpdate(normalized).orElseThrow().markEmailVerified();
        });
    }

    /** [이메일인증][HttpOnly쿠키] 가입 → 인증 완료 → 로그인까지 수행해 세션을 반환합니다. */
    private AuthSession signupAndLogin(String rawEmail) throws Exception {
        signupOnly(rawEmail);
        verifyUserInDb(rawEmail);
        var response = mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of(
                    "email", rawEmail.trim().toLowerCase(Locale.ROOT), "password", PASSWORD))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.tokenType").value("Bearer"))
            .andExpect(jsonPath("$.expiresIn").value(1800))
            .andExpect(jsonPath("$.refreshToken").doesNotExist())
            .andReturn().getResponse();
        var body = mapper.readTree(response.getContentAsString());
        String refreshCookie = extractRefreshCookie(response.getHeaders(HttpHeaders.SET_COOKIE));
        assertThat(refreshCookie).isNotBlank();
        return new AuthSession(body.path("accessToken").asText(), refreshCookie, body);
    }

    private ResultActions refresh(String token) throws Exception {
        return mvc.perform(post("/api/v1/auth/refresh")
            .header("X-Requested-With", "XMLHttpRequest")
            .cookie(new Cookie("refresh_token", token)));
    }

    @Test
    void 가입시_해시와_기본프로필을_저장하고_대소문자_중복을_차단한다() throws Exception {
        String email = email();
        var session = signupAndLogin(email.toUpperCase(Locale.ROOT));
        var user = users.findByEmail(email).orElseThrow();
        assertThat(passwordEncoder.matches(PASSWORD, user.getPasswordHash())).isTrue();
        assertThat(user.getPasswordHash()).isNotEqualTo(PASSWORD);
        assertThat(profiles.findByUserId(user.getId())).isPresent();
        assertThat(session.body().path("user").path("email").asText()).isEqualTo(email);
        var stored = tokens.findByTokenHash(
            refreshProvider.hashToken(session.refreshToken())).orElseThrow();
        assertThat(stored.isRevoked()).isFalse();
        assertThat(stored.getTokenHash()).hasSize(64);

        mvc.perform(post("/api/v1/auth/signup")
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of(
                    "email", email, "password", PASSWORD, "nickname", "중복회원"))))
            .andExpect(status().isConflict())
            .andExpect(jsonPath("$.code").value("AUTH_001"));
    }

    @Test
    void 미인증_계정은_로그인시_403을_반환하고_이메일인증후_로그인에_성공한다() throws Exception {
        String email = email();
        signupOnly(email);

        // 미인증 상태에서는 올바른 비밀번호여도 403(AUTH_006) 차단
        mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("email", email, "password", PASSWORD))))
            .andExpect(status().isForbidden())
            .andExpect(jsonPath("$.code").value("AUTH_006"));

        // 발송된 인증 링크에서 토큰 추출 후 confirm API 호출
        var urlCaptor = ArgumentCaptor.forClass(String.class);
        Mockito.verify(emailSender).sendVerificationEmail(Mockito.eq(email), urlCaptor.capture());
        String rawToken = urlCaptor.getValue().substring(urlCaptor.getValue().indexOf("token=") + 6);

        mvc.perform(post("/api/v1/auth/email-verification/confirm")
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("token", rawToken))))
            .andExpect(status().isNoContent());

        // 같은 토큰 재사용은 400(AUTH_007) 차단
        mvc.perform(post("/api/v1/auth/email-verification/confirm")
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("token", rawToken))))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("AUTH_007"));

        // 인증 완료 후 로그인 성공 및 HttpOnly 쿠키 발급 확인
        var loginResp = mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("email", email, "password", PASSWORD))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.accessToken").isNotEmpty())
            .andReturn().getResponse();
        assertThat(loginResp.getHeader(HttpHeaders.SET_COOKIE)).contains("HttpOnly");
    }

    @Test
    void 인증메일_재발송은_60초_쿨다운을_적용하고_미가입_이메일은_동일하게_204를_반환한다() throws Exception {
        String email = email();
        signupOnly(email);

        // 가입 직후 60초 이내 재발송 요청은 429(AUTH_008) 차단
        mvc.perform(post("/api/v1/auth/email-verification/resend")
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("email", email))))
            .andExpect(status().isTooManyRequests())
            .andExpect(jsonPath("$.code").value("AUTH_008"));

        // 미가입 이메일은 계정 존재 유추 방지를 위해 204 동일 응답
        mvc.perform(post("/api/v1/auth/email-verification/resend")
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("email", "nobody-" + UUID.randomUUID() + "@example.com"))))
            .andExpect(status().isNoContent());
    }

    @Test
    void 로그인_성공과_잘못된_비밀번호를_구분한다() throws Exception {
        String email = email();
        signupOnly(email);
        verifyUserInDb(email);
        mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("email", email, "password", PASSWORD))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.accessToken").isNotEmpty());
        mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("email", email, "password", "wrong"))))
            .andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.code").value("AUTH_002"));
    }

    @Test
    void 토큰없이_또는_임시헤더만으로_보호API에_접근할수없다() throws Exception {
        mvc.perform(get("/api/v1/me")).andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.code").value("COMMON_401"));
        mvc.perform(get("/api/v1/me").header("X-User-Id", "1"))
            .andExpect(status().isUnauthorized());
    }

    @Test
    void JWT의_사용자만_조회하고_다른_사용자의_재고는_수정할수없다() throws Exception {
        var first = signupAndLogin(email());
        var second = signupAndLogin(email());
        String firstAuth = "Bearer " + first.accessToken();
        String secondAuth = "Bearer " + second.accessToken();
        mvc.perform(get("/api/v1/me").header("Authorization", firstAuth)
                .header("X-User-Id", second.body().path("user").path("id").asText()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(first.body().path("user").path("id").asLong()));
        var response = mvc.perform(post("/api/v1/inventory/lots")
                .header("Authorization", firstAuth)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ingredientName\":\"인증검증두부\",\"quantity\":1,\"unit\":\"개\",\"storageLocation\":\"FRIDGE\",\"minStockQty\":0}"))
            .andExpect(status().isCreated()).andReturn().getResponse();
        long lotId = mapper.readTree(response.getContentAsString()).path("id").asLong();
        try {
            mvc.perform(patch("/api/v1/inventory/lots/" + lotId)
                    .header("Authorization", secondAuth)
                    .contentType(MediaType.APPLICATION_JSON)
                    .content("{\"action\":\"ADJUST\",\"quantity\":2}"))
                .andExpect(status().isNotFound());
        } finally {
            new TransactionTemplate(transactionManager).executeWithoutResult(status -> {
                entityManager.createQuery(
                    "delete from InventoryTransaction t where t.lot.id = :lotId")
                    .setParameter("lotId", lotId).executeUpdate();
                entityManager.createQuery("delete from InventoryLot l where l.id = :lotId")
                    .setParameter("lotId", lotId).executeUpdate();
            });
        }
    }

    @Test
    void 변조된_JWT와_만료된_JWT를_거부한다() throws Exception {
        var session = signupAndLogin(email());
        String access = session.accessToken();
        int signatureStart = access.lastIndexOf('.') + 1;
        String tampered = access.substring(0, signatureStart)
            + (access.charAt(signatureStart) == 'A' ? "B" : "A")
            + access.substring(signatureStart + 1);
        mvc.perform(get("/api/v1/me").header("Authorization", "Bearer " + tampered))
            .andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.code").value("AUTH_003"));

        var key = new SecretKeySpec(Base64.getDecoder().decode(properties.secret()), "HmacSHA256");
        String expired = Jwts.builder().issuer("mealfit")
            .audience().add("mealfit-api").and()
            .subject(session.body().path("user").path("id").asText())
            .issuedAt(Date.from(Instant.now().minusSeconds(120)))
            .expiration(Date.from(Instant.now().minusSeconds(60)))
            .signWith(key, Jwts.SIG.HS256).compact();
        mvc.perform(get("/api/v1/me").header("Authorization", "Bearer " + expired))
            .andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.code").value("AUTH_004"));
    }

    @Test
    void 잘못된_aud_클레임_JWT는_거부한다() throws Exception {
        var session = signupAndLogin(email());
        var key = new SecretKeySpec(Base64.getDecoder().decode(properties.secret()), "HmacSHA256");
        String wrongAud = Jwts.builder().issuer("mealfit")
            .audience().add("other-service").and()
            .subject(session.body().path("user").path("id").asText())
            .issuedAt(Date.from(Instant.now()))
            .expiration(Date.from(Instant.now().plusSeconds(600)))
            .signWith(key, Jwts.SIG.HS256).compact();
        mvc.perform(get("/api/v1/me").header("Authorization", "Bearer " + wrongAud))
            .andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.code").value("AUTH_003"));
    }

    @Test
    void refresh와_logout은_CSRF헤더_누락이나_외부Origin요청을_403으로_차단한다() throws Exception {
        String token = signupAndLogin(email()).refreshToken();

        // CSRF 커스텀 헤더 누락 차단
        mvc.perform(post("/api/v1/auth/refresh")
                .cookie(new Cookie("refresh_token", token)))
            .andExpect(status().isForbidden());
        mvc.perform(post("/api/v1/auth/logout")
                .cookie(new Cookie("refresh_token", token)))
            .andExpect(status().isForbidden());

        // 외부 Origin 차단
        mvc.perform(post("/api/v1/auth/refresh")
                .header("X-Requested-With", "XMLHttpRequest")
                .header(HttpHeaders.ORIGIN, "https://evil.example")
                .cookie(new Cookie("refresh_token", token)))
            .andExpect(status().isForbidden());
        mvc.perform(post("/api/v1/auth/logout")
                .header("X-Requested-With", "XMLHttpRequest")
                .header(HttpHeaders.ORIGIN, "https://evil.example")
                .cookie(new Cookie("refresh_token", token)))
            .andExpect(status().isForbidden());
    }

    @Test
    void 재발급은_토큰을_교체하고_재사용하면_새토큰도_폐기된다() throws Exception {
        var session = signupAndLogin(email());
        String oldToken = session.refreshToken();
        var refreshed = refresh(oldToken).andExpect(status().isOk())
            .andReturn().getResponse();
        String nextToken = extractRefreshCookie(refreshed.getHeaders(HttpHeaders.SET_COOKIE));
        assertThat(nextToken).isNotBlank().isNotEqualTo(oldToken);
        refresh(oldToken).andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.code").value("AUTH_005"));
        assertThat(tokens.findByTokenHash(refreshProvider.hashToken(nextToken))
            .orElseThrow().isRevoked()).isTrue();
        refresh(nextToken).andExpect(status().isUnauthorized());
    }

    @Test
    void 로그아웃한_토큰으로는_재발급할수없다() throws Exception {
        String token = signupAndLogin(email()).refreshToken();
        var logoutResp = mvc.perform(post("/api/v1/auth/logout")
                .header("X-Requested-With", "XMLHttpRequest")
                .cookie(new Cookie("refresh_token", token)))
            .andExpect(status().isNoContent())
            .andReturn().getResponse();
        assertThat(logoutResp.getHeader(HttpHeaders.SET_COOKIE)).contains("Max-Age=0");
        refresh(token).andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.code").value("AUTH_005"));
    }

    @Test
    void 잘못된_입력과_비밀번호_바이트초과를_거부한다() throws Exception {
        for (String password : List.of("short", "한".repeat(25))) {
            mvc.perform(post("/api/v1/auth/signup").contentType(MediaType.APPLICATION_JSON)
                    .content(mapper.writeValueAsString(Map.of(
                        "email", email(), "password", password, "nickname", "회원"))))
                .andExpect(status().isBadRequest());
        }
        refresh("not-a-real-token").andExpect(status().isUnauthorized());
        // [HttpOnly쿠키] 쿠키가 비어 있으면 401(AUTH_005) 반환
        mvc.perform(post("/api/v1/auth/refresh")
                .header("X-Requested-With", "XMLHttpRequest"))
            .andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.code").value("AUTH_005"));
    }

    @Test
    void 동일토큰_동시재발급은_한건만_성공하고_재사용으로_폐기된다() throws Exception {
        var session = signupAndLogin(email());
        String token = session.refreshToken();
        var ready = new CountDownLatch(2);
        var start = new CountDownLatch(1);
        var executor = Executors.newFixedThreadPool(2);
        try {
            java.util.concurrent.Callable<Integer> action = () -> {
                ready.countDown();
                if (!start.await(10, TimeUnit.SECONDS)) throw new IllegalStateException("대기 시간 초과");
                return refresh(token).andReturn().getResponse().getStatus();
            };
            var first = executor.submit(action);
            var second = executor.submit(action);
            assertThat(ready.await(10, TimeUnit.SECONDS)).isTrue();
            start.countDown();
            assertThat(List.of(first.get(20, TimeUnit.SECONDS), second.get(20, TimeUnit.SECONDS)))
                .containsExactlyInAnyOrder(200, 401);
            long userId = session.body().path("user").path("id").asLong();
            assertThat(tokens.findAll().stream()
                .filter(row -> row.getUserId().equals(userId)))
                .allMatch(row -> row.isRevoked());
        } finally {
            start.countDown();
            executor.shutdownNow();
        }
    }

    private void withdrawUser(long userId) {
        new TransactionTemplate(transactionManager).executeWithoutResult(status -> {
            users.findByIdForUpdate(userId).orElseThrow().withdraw();
        });
    }

    @Test
    void 탈퇴회원은_올바른_비밀번호로도_로그인할수없다() throws Exception {
        String email = email();
        var session = signupAndLogin(email);
        long userId = session.body().path("user").path("id").asLong();
        withdrawUser(userId);
        var firstDeletedAt = users.findById(userId).orElseThrow().getDeletedAt();
        withdrawUser(userId);
        assertThat(users.findById(userId).orElseThrow().getDeletedAt()).isEqualTo(firstDeletedAt);

        mvc.perform(post("/api/v1/auth/login").contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("email", email, "password", PASSWORD))))
            .andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.code").value("AUTH_002"));
    }

    @Test
    void 탈퇴회원은_기존_리프레시토큰으로_재발급할수없다() throws Exception {
        var session = signupAndLogin(email());
        long userId = session.body().path("user").path("id").asLong();
        String token = session.refreshToken();
        assertThat(tokens.findByTokenHash(refreshProvider.hashToken(token)).orElseThrow().isRevoked()).isFalse();
        long before = tokens.count();
        withdrawUser(userId);

        refresh(token).andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.code").value("AUTH_005"));
        assertThat(tokens.count()).isEqualTo(before);
    }

    @Test
    void 탈퇴전_발급한_액세스토큰은_탈퇴직후_차단되고_다른회원은_영향없다() throws Exception {
        var session = signupAndLogin(email());
        var other = signupAndLogin(email());
        String access = session.accessToken();
        mvc.perform(get("/api/v1/me").header("Authorization", "Bearer " + access))
            .andExpect(status().isOk());
        withdrawUser(session.body().path("user").path("id").asLong());

        for (String path : List.of("/api/v1/me", "/api/v1/me/profile/details", "/api/v1/inventory/lots")) {
            mvc.perform(get(path).header("Authorization", "Bearer " + access))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.code").value("AUTH_003"));
        }
        mvc.perform(get("/api/v1/me").header("Authorization", "Bearer " + other.accessToken()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(other.body().path("user").path("id").asLong()));
    }

    @Test
    void 존재하지않는_회원의_유효한서명토큰도_차단한다() throws Exception {
        var key = new SecretKeySpec(Base64.getDecoder().decode(properties.secret()), "HmacSHA256");
        String ghostToken = Jwts.builder().issuer("mealfit")
            .audience().add("mealfit-api").and()
            .subject("999999999")
            .issuedAt(Date.from(Instant.now()))
            .expiration(Date.from(Instant.now().plusSeconds(600)))
            .signWith(key, Jwts.SIG.HS256).compact();
        mvc.perform(get("/api/v1/me").header("Authorization", "Bearer " + ghostToken))
            .andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.code").value("AUTH_003"));
    }
}
