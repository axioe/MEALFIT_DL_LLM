package com.mealfit.global.security;

import com.mealfit.domain.user.service.WithdrawalReauthentication;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import lombok.extern.slf4j.Slf4j;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

/**
 * [소셜로그인] 사용자가 OAuth2 동의를 취소하거나 공급자 오류가 발생했을 때 안전하게 로그인 화면으로 돌려보냅니다.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class OAuth2FailureHandler implements AuthenticationFailureHandler {
    private final WithdrawalReauthentication withdrawalReauthentication;

    @Value("${mealfit.auth.frontend-base-url:http://localhost:5173}")
    private String frontendBaseUrl;

    @Value("${mealfit.auth.cookie-secure:false}")
    private boolean cookieSecure;

    @Override
    public void onAuthenticationFailure(
        HttpServletRequest request,
        HttpServletResponse response,
        AuthenticationException exception
    ) throws IOException {
        log.warn("[소셜로그인] OAuth2 인증 실패: {}", exception.getMessage());

        ResponseCookie deleteLinkCookie = ResponseCookie.from(OAuth2SuccessHandler.LINK_INTENT_COOKIE_NAME, "")
            .httpOnly(true)
            .secure(cookieSecure)
            .path(OAuth2SuccessHandler.LINK_INTENT_COOKIE_PATH)
            .sameSite("Lax")
            .maxAge(0)
            .build();
        response.addHeader(HttpHeaders.SET_COOKIE, deleteLinkCookie.toString());

        // [소셜로그인] 실패 시에도 임시 OAuth2 HttpSession과 JSESSIONID를 즉시 파기합니다.
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

        String base = (frontendBaseUrl == null || frontendBaseUrl.isBlank())
            ? "http://localhost:5173"
            : frontendBaseUrl.trim().replaceAll("/+$", "");
        if (WithdrawalOAuth2RequestResolver.isWithdrawalCallback(request)) {
            if (WithdrawalOAuth2RequestResolver.matchesCookie(request)) {
                withdrawalReauthentication.cancelPending(WithdrawalOAuth2RequestResolver.cookie(request));
                response.addHeader(HttpHeaders.SET_COOKIE,
                    WithdrawalOAuth2RequestResolver.responseCookie(null, cookieSecure).toString());
            }
            response.sendRedirect(base + "/mypage?withdrawal=failed");
            return;
        }
        response.sendRedirect(base + "/login?oauthError=oauth_failed");
    }
}
