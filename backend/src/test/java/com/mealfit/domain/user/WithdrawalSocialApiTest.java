package com.mealfit.domain.user;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.mealfit.domain.auth.entity.SocialProvider;
import com.mealfit.domain.auth.model.OAuth2UserInfo;
import com.mealfit.domain.auth.repository.UserSocialAccountRepository;
import com.mealfit.domain.auth.service.SocialAuthService;
import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.global.security.JwtTokenProvider;
import com.mealfit.global.security.OAuth2FailureHandler;
import com.mealfit.global.security.OAuth2SuccessHandler;
import com.mealfit.global.security.WithdrawalOAuth2RequestResolver;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;
import jakarta.servlet.http.Cookie;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.AfterAll;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.UriComponentsBuilder;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class WithdrawalSocialApiTest {
    private static final String PATH = "/api/v1/me/withdrawal";
    private static final String COOKIE = WithdrawalOAuth2RequestResolver.COOKIE;
    private static final HttpServer PROVIDER = providerServer();
    @Autowired MockMvc mvc;
    @Autowired JwtTokenProvider jwt;
    @Autowired SocialAuthService auth;
    @Autowired UserSocialAccountRepository accounts;
    @Autowired UserRepository users;
    @Autowired OAuth2SuccessHandler successHandler;
    @Autowired OAuth2FailureHandler failureHandler;

    @DynamicPropertySource
    static void providerUrls(DynamicPropertyRegistry registry) {
        String base = "http://127.0.0.1:" + PROVIDER.getAddress().getPort();
        registry.add("spring.security.oauth2.client.provider.naver.token-uri", () -> base + "/token");
        registry.add("spring.security.oauth2.client.provider.naver.user-info-uri", () -> base + "/user");
    }

    @AfterAll
    static void stopProvider() {
        PROVIDER.stop(0);
    }

    @Test
    void 소셜인증_복귀_후_최종확정에서만_계정이_삭제되고_재가입하면_새계정이_된다() throws Exception {
        var member = socialMember();
        var intent = start(member);
        var authorization = beginAuthorization(intent);
        assertThat(authorization.state()).startsWith("withdrawal.");

        mvc.perform(post(PATH + "/confirm").header("Authorization", member.bearer()).cookie(intent))
            .andExpect(status().isForbidden());
        var callback = mvc.perform(get("/login/oauth2/code/naver").servletPath("/login/oauth2/code/naver")
                .param("state", authorization.state()).param("code", member.providerId())
                .session(authorization.session()).cookie(intent))
            .andExpect(status().is3xxRedirection()).andReturn().getResponse();
        assertThat(callback.getRedirectedUrl()).endsWith("/mypage?withdrawal=verified");
        assertThat(callback.getHeaders("Set-Cookie")).noneMatch(header -> header.startsWith("refresh_token="));
        Cookie proof = readCookie(callback);
        assertThat(proof.getValue()).isNotEqualTo(intent.getValue());
        assertThat(users.findById(member.id())).isPresent();

        mvc.perform(get(PATH + "/reauthentication").header("Authorization", member.bearer()).cookie(proof))
            .andExpect(status().isOk()).andExpect(jsonPath("$.remainingMillis").isNumber());
        mvc.perform(post(PATH + "/confirm").header("Authorization", member.bearer()).cookie(proof))
            .andExpect(status().isNoContent())
            .andExpect(header().stringValues("Set-Cookie", org.hamcrest.Matchers.hasItem(
                org.hamcrest.Matchers.startsWith("refresh_token=;"))));
        assertThat(users.findById(member.id())).isEmpty();
        mvc.perform(post(PATH + "/confirm").header("Authorization", member.bearer()).cookie(proof))
            .andExpect(status().isUnauthorized());
        mvc.perform(post("/api/v1/auth/refresh").header("X-Requested-With", "XMLHttpRequest")
                .cookie(new Cookie("refresh_token", member.refresh())))
            .andExpect(status().isUnauthorized());

        auth.loginOrRegister(new OAuth2UserInfo(SocialProvider.NAVER, member.providerId(), member.email(), "재가입"));
        assertThat(accounts.findByProviderAndProviderUserId(SocialProvider.NAVER, member.providerId())
            .orElseThrow().getUserId()).isNotEqualTo(member.id());
    }

    @Test
    void 쿠키가_다른_콜백과_다른_소셜계정은_거절한다() throws Exception {
        var member = socialMember();
        var other = socialMember();
        var intent = start(member);
        var otherIntent = start(other);
        var state = beginAuthorization(intent).state();

        assertThat(result(state, otherIntent, member.providerId()).getRedirectedUrl())
            .endsWith("/mypage?withdrawal=failed");
        assertThat(result(state, intent, other.providerId()).getRedirectedUrl())
            .endsWith("/mypage?withdrawal=failed");
        assertThat(result(state, intent, member.providerId()).getRedirectedUrl())
            .endsWith("/mypage?withdrawal=failed");
        assertThat(users.findById(member.id())).isPresent();
        assertThat(users.findById(other.id())).isPresent();
    }

    @Test
    void 콜백취소와_확인화면취소는_권한을_폐기한다() throws Exception {
        var member = socialMember();
        var intent = start(member);
        var state = beginAuthorization(intent).state();
        var failed = new MockHttpServletResponse();
        failureHandler.onAuthenticationFailure(callbackRequest(state, intent), failed,
            new OAuth2AuthenticationException("access_denied"));
        assertThat(failed.getRedirectedUrl()).endsWith("/mypage?withdrawal=failed");
        assertThat(result(state, intent, member.providerId()).getRedirectedUrl())
            .endsWith("/mypage?withdrawal=failed");

        var retry = start(member);
        var proof = readCookie(result(beginAuthorization(retry).state(), retry, member.providerId()));
        var other = socialMember();
        mvc.perform(post(PATH + "/confirm").header("Authorization", other.bearer()).cookie(proof))
            .andExpect(status().isForbidden());
        mvc.perform(delete(PATH + "/reauthentication").header("Authorization", member.bearer()).cookie(proof))
            .andExpect(status().isNoContent());
        mvc.perform(post(PATH + "/confirm").header("Authorization", member.bearer()).cookie(proof))
            .andExpect(status().isForbidden());
        assertThat(users.findById(member.id())).isPresent();
    }

    private Member socialMember() {
        String id = UUID.randomUUID().toString();
        String email = id + "@naver.com";
        String refresh = auth.loginOrRegister(new OAuth2UserInfo(SocialProvider.NAVER, id, email, "테스트"));
        Long userId = accounts.findByProviderAndProviderUserId(SocialProvider.NAVER, id).orElseThrow().getUserId();
        return new Member(id, email, userId, "Bearer " + jwt.createAccessToken(userId, email), refresh);
    }

    private Cookie start(Member member) throws Exception {
        var response = mvc.perform(post(PATH + "/reauthentication").header("Authorization", member.bearer())
                .contentType(MediaType.APPLICATION_JSON).content("{\"provider\":\"naver\"}"))
            .andExpect(status().isNoContent()).andReturn().getResponse();
        return readCookie(response);
    }

    private Authorization beginAuthorization(Cookie intent) throws Exception {
        var result = mvc.perform(get("/oauth2/authorization/naver").servletPath("/oauth2/authorization/naver")
                .param("withdrawal", "1").cookie(intent))
            .andExpect(status().is3xxRedirection()).andReturn();
        var query = UriComponentsBuilder.fromUriString(result.getResponse().getRedirectedUrl()).build().getQueryParams();
        assertThat(query.getFirst("auth_type")).isEqualTo("reauthenticate");
        String state = URLDecoder.decode(query.getFirst("state"), StandardCharsets.UTF_8);
        return new Authorization(state, (MockHttpSession) result.getRequest().getSession(false));
    }

    private MockHttpServletResponse result(String state, Cookie cookie, String providerId) throws Exception {
        var authorities = List.of(new SimpleGrantedAuthority("ROLE_USER"));
        var user = new DefaultOAuth2User(authorities, Map.of("response", Map.of("id", providerId)), "response");
        var response = new MockHttpServletResponse();
        successHandler.onAuthenticationSuccess(callbackRequest(state, cookie), response,
            new OAuth2AuthenticationToken(user, authorities, "naver"));
        return response;
    }

    private MockHttpServletRequest callbackRequest(String state, Cookie cookie) {
        var request = new MockHttpServletRequest();
        request.setParameter("state", state);
        request.setCookies(cookie);
        return request;
    }

    private Cookie readCookie(MockHttpServletResponse response) {
        String header = response.getHeaders("Set-Cookie").stream().filter(value -> value.startsWith(COOKIE + "="))
            .findFirst().orElseThrow();
        assertThat(header).contains("HttpOnly", "SameSite=Lax", "Max-Age=300");
        return new Cookie(COOKIE, header.substring(COOKIE.length() + 1, header.indexOf(';')));
    }

    private static HttpServer providerServer() {
        try {
            var server = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
            server.createContext("/token", request -> {
                String form = new String(request.getRequestBody().readAllBytes(), StandardCharsets.UTF_8);
                String code = java.util.Arrays.stream(form.split("&"))
                    .filter(field -> field.startsWith("code=")).findFirst().orElseThrow().substring(5);
                respond(request, """
                    {"access_token":"%s","token_type":"Bearer","expires_in":300}
                    """.formatted(UUID.fromString(code)));
            });
            server.createContext("/user", request -> {
                String providerId = request.getRequestHeaders().getFirst("Authorization").substring("Bearer ".length());
                respond(request, """
                    {"response":{"id":"%s","nickname":"Test"}}
                    """.formatted(UUID.fromString(providerId)));
            });
            server.start();
            return server;
        } catch (IOException exception) {
            throw new UncheckedIOException(exception);
        }
    }

    private static void respond(HttpExchange request, String payload) throws IOException {
        try (request) {
            byte[] response = payload.getBytes(StandardCharsets.UTF_8);
            request.getResponseHeaders().add("Content-Type", "application/json");
            request.sendResponseHeaders(200, response.length);
            request.getResponseBody().write(response);
        }
    }

    private record Authorization(String state, MockHttpSession session) {}
    private record Member(String providerId, String email, Long id, String bearer, String refresh) {}
}
