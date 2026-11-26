package com.mealfit.global.security;

import com.mealfit.domain.auth.entity.SocialProvider;
import com.mealfit.domain.user.service.WithdrawalReauthentication;
import jakarta.servlet.http.HttpServletRequest;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HexFormat;
import java.time.Duration;
import org.springframework.http.ResponseCookie;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.web.DefaultOAuth2AuthorizationRequestResolver;
import org.springframework.security.oauth2.client.web.OAuth2AuthorizationRequestResolver;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.endpoint.OAuth2AuthorizationRequest;
import org.springframework.web.util.WebUtils;

/** 기존 로그인·연동과 구분된 탈퇴 OAuth state에 시작 쿠키를 연결합니다. */
public class WithdrawalOAuth2RequestResolver implements OAuth2AuthorizationRequestResolver {
    public static final String COOKIE = "withdrawal_reauth";
    public static final String START_PARAM = "withdrawal";
    private static final String PREFIX = "withdrawal.";
    private final DefaultOAuth2AuthorizationRequestResolver delegate;
    private final WithdrawalReauthentication reauthentication;

    public WithdrawalOAuth2RequestResolver(ClientRegistrationRepository registrations,
                                           WithdrawalReauthentication reauthentication) {
        this.delegate = new DefaultOAuth2AuthorizationRequestResolver(registrations, "/oauth2/authorization");
        this.reauthentication = reauthentication;
    }

    @Override
    public OAuth2AuthorizationRequest resolve(HttpServletRequest request) {
        return customize(request, delegate.resolve(request));
    }

    @Override
    public OAuth2AuthorizationRequest resolve(HttpServletRequest request, String registrationId) {
        return customize(request, delegate.resolve(request, registrationId));
    }

    private OAuth2AuthorizationRequest customize(HttpServletRequest request, OAuth2AuthorizationRequest authorization) {
        if (authorization == null || !"1".equals(request.getParameter(START_PARAM))) {
            return authorization;
        }
        String token = cookie(request);
        SocialProvider provider = reauthentication.pendingProvider(token)
            .filter(value -> value.getRegistrationId().equals(authorization.getAttribute("registration_id")))
            .orElseThrow(() -> new OAuth2AuthenticationException("withdrawal_request_expired"));
        return OAuth2AuthorizationRequest.from(authorization)
            .state(statePrefix(token) + authorization.getState())
            .additionalParameters(params -> {
                switch (provider) {
                    case GOOGLE -> params.put("prompt", "select_account");
                    case NAVER -> params.put("auth_type", "reauthenticate");
                    case KAKAO -> params.put("prompt", "login");
                }
            })
            .build();
    }

    public static boolean isWithdrawalCallback(HttpServletRequest request) {
        String state = request.getParameter("state");
        return state != null && state.startsWith(PREFIX);
    }

    public static boolean matchesCookie(HttpServletRequest request) {
        String token = cookie(request);
        return token != null && request.getParameter("state").startsWith(statePrefix(token));
    }

    public static String cookie(HttpServletRequest request) {
        var cookie = WebUtils.getCookie(request, COOKIE);
        return cookie == null ? null : cookie.getValue();
    }

    public static ResponseCookie responseCookie(String token, boolean secure) {
        return ResponseCookie.from(COOKIE, token == null ? "" : token)
            .httpOnly(true).secure(secure).path("/").sameSite("Lax")
            .maxAge(token == null ? Duration.ZERO : WithdrawalReauthentication.TTL)
            .build();
    }

    private static String statePrefix(String token) {
        try {
            byte[] digest = MessageDigest.getInstance("SHA-256").digest(token.getBytes(StandardCharsets.UTF_8));
            return PREFIX + HexFormat.of().formatHex(digest) + ".";
        } catch (NoSuchAlgorithmException exception) {
            throw new IllegalStateException(exception);
        }
    }
}
