package com.mealfit.global.security;

import com.mealfit.domain.auth.model.OAuth2UserInfo;
import com.mealfit.domain.auth.service.SocialAuthService;
import com.mealfit.domain.user.service.WithdrawalReauthentication;

import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

/**
 * [소셜로그인] OAuth2 인증 성공 후 로그인(Refresh 쿠키 발급) 또는 기존 계정 연동을 분기 처리합니다.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class OAuth2SuccessHandler implements AuthenticationSuccessHandler {

    public static final String LINK_INTENT_COOKIE_NAME = "oauth_link_intent";
    public static final String LINK_INTENT_COOKIE_PATH = "/login/oauth2";
    private static final String REFRESH_COOKIE_NAME = "refresh_token";
    private static final long REFRESH_COOKIE_MAX_AGE = 14L * 24 * 60 * 60;

    private final SocialAuthService socialAuthService;
    private final WithdrawalReauthentication withdrawalReauthentication;

    @Value("${mealfit.auth.frontend-base-url:http://localhost:5173}")
    private String frontendBaseUrl;

    @Value("${mealfit.auth.cookie-secure:false}")
    private boolean cookieSecure;

    @Override
    public void onAuthenticationSuccess(
        HttpServletRequest request,
        HttpServletResponse response,
        Authentication authentication
    ) throws IOException {
        OAuth2AuthenticationToken oauthToken = (OAuth2AuthenticationToken) authentication;
        OAuth2User oauthUser = oauthToken.getPrincipal();
        String registrationId = oauthToken.getAuthorizedClientRegistrationId();

        if (WithdrawalOAuth2RequestResolver.isWithdrawalCallback(request)) {
            clearOAuthSession(request, response);
            handleWithdrawalCallback(request, response, registrationId, oauthUser);
            return;
        }

        String rawLinkIntent = extractCookie(request, LINK_INTENT_COOKIE_NAME);
        // [소셜로그인] 1회용 연동 쿠키는 성공/실패 여부와 무관하게 즉시 삭제합니다.
        if (rawLinkIntent != null) {
            expireLinkIntentCookie(response);
        }

        OAuth2UserInfo info = OAuth2UserInfo.of(registrationId, oauthUser.getAttributes());

        // [소셜로그인] OAuth2 state 검증이 끝난 직후 서버 세션과 SecurityContext를 즉시 파기합니다.
        // (이후 API 요청은 JWT/Refresh 쿠키로만 인증해 JSESSIONID 잔존 및 CSRF 위험을 차단합니다.)
        clearOAuthSession(request, response);

        // [소셜로그인] 마이페이지·팝업에서 연동을 시작한 경우 → 기존 계정에 연동 후 /mypage로 복귀
        if (rawLinkIntent != null && !rawLinkIntent.isBlank()) {
            Optional<SocialAuthService.LinkIntent> intent = socialAuthService.parseLinkIntentToken(rawLinkIntent);
            if (intent.isEmpty() || intent.get().provider() != info.provider()) {
                redirect(response, "/mypage?socialError=invalid_intent");
                return;
            }
            try {
                socialAuthService.linkAccount(intent.get().userId(), info);
                redirect(response, "/mypage?socialLinked=" + encode(info.provider().getRegistrationId()));
            } catch (BusinessException ex) {
                redirect(response, "/mypage?socialError=" + encode(mapErrorCode(ex.getErrorCode())));
            }
            return;
        }

        // [소셜로그인] 일반 소셜 로그인·신규 가입 → HttpOnly Refresh 쿠키 발급 후 /dashboard 이동
        try {
            String rawRefreshToken = socialAuthService.loginOrRegister(info);
            ResponseCookie refreshCookie = ResponseCookie.from(REFRESH_COOKIE_NAME, rawRefreshToken)
                .httpOnly(true)
                .secure(cookieSecure)
                .path("/api/v1/auth")
                .sameSite("Lax")
                .maxAge(REFRESH_COOKIE_MAX_AGE)
                .build();
            response.addHeader(HttpHeaders.SET_COOKIE, refreshCookie.toString());
            redirect(response, "/dashboard");
        } catch (BusinessException ex) {
            redirect(response, "/login?oauthError=" + encode(mapErrorCode(ex.getErrorCode())));
        }
    }

    private void handleWithdrawalCallback(HttpServletRequest request, HttpServletResponse response,
                                          String registrationId, OAuth2User oauthUser) throws IOException {
        if (!WithdrawalOAuth2RequestResolver.matchesCookie(request)) {
            redirect(response, "/mypage?withdrawal=failed");
            return;
        }
        String token = WithdrawalOAuth2RequestResolver.cookie(request);
        Optional<String> verified;
        try {
            verified = withdrawalReauthentication.verify(token,
                OAuth2UserInfo.of(registrationId, oauthUser.getAttributes()));
        } catch (BusinessException exception) {
            withdrawalReauthentication.cancelPending(token);
            verified = Optional.empty();
        }
        response.addHeader(HttpHeaders.SET_COOKIE,
            WithdrawalOAuth2RequestResolver.responseCookie(verified.orElse(null), cookieSecure).toString());
        redirect(response, verified.isPresent() ? "/mypage?withdrawal=verified" : "/mypage?withdrawal=failed");
    }

    private String extractCookie(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }
        for (Cookie cookie : cookies) {
            if (name.equals(cookie.getName())) {
                return cookie.getValue();
            }
        }
        return null;
    }

    private void expireLinkIntentCookie(HttpServletResponse response) {
        ResponseCookie deleteCookie = ResponseCookie.from(LINK_INTENT_COOKIE_NAME, "")
            .httpOnly(true)
            .secure(cookieSecure)
            .path(LINK_INTENT_COOKIE_PATH)
            .sameSite("Lax")
            .maxAge(0)
            .build();
        response.addHeader(HttpHeaders.SET_COOKIE, deleteCookie.toString());
    }

    /** [소셜로그인] OAuth2 인가 흐름에 쓰인 임시 HttpSession과 JSESSIONID 쿠키를 즉시 제거합니다. */
    private void clearOAuthSession(HttpServletRequest request, HttpServletResponse response) {
        SecurityContextHolder.clearContext();
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        ResponseCookie deleteSessionCookie = ResponseCookie.from("JSESSIONID", "")
            .httpOnly(true)
            .secure(cookieSecure)
            .path("/")
            .sameSite("Lax")
            .maxAge(0)
            .build();
        response.addHeader(HttpHeaders.SET_COOKIE, deleteSessionCookie.toString());
    }

    private String mapErrorCode(ErrorCode code) {
        return switch (code) {
            case AUTH_SOCIAL_EMAIL_ALREADY_REGISTERED -> "email_exists";
            case AUTH_SOCIAL_ALREADY_LINKED_OTHER -> "already_linked";
            case AUTH_SOCIAL_LINK_DOMAIN_MISMATCH -> "domain_mismatch";
            default -> "oauth_failed";
        };
    }

    private void redirect(HttpServletResponse response, String path) throws IOException {
        String base = (frontendBaseUrl == null || frontendBaseUrl.isBlank())
            ? "http://localhost:5173"
            : frontendBaseUrl.trim().replaceAll("/+$", "");
        response.sendRedirect(base + path);
    }

    private String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
