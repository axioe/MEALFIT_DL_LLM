package com.mealfit.domain.auth.controller;

import com.mealfit.domain.auth.dto.EmailVerifyConfirmRequest;
import com.mealfit.domain.auth.dto.EmailVerifyResendRequest;
import com.mealfit.domain.auth.dto.LoginRequest;
import com.mealfit.domain.auth.dto.SignupRequest;
import com.mealfit.domain.auth.dto.SignupResponse;
import com.mealfit.domain.auth.dto.TokenResponse;
import com.mealfit.domain.auth.service.AuthService;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import java.net.URI;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/** 인증 요청을 검증한 뒤 AuthService에 전달합니다. */
@Tag(name = "Auth", description = "회원가입·로그인·토큰 관리")
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    // [HttpOnly쿠키] Refresh Token 쿠키 이름 및 만료 기간(14일)
    private static final String REFRESH_COOKIE_NAME = "refresh_token";
    private static final long REFRESH_COOKIE_MAX_AGE = 14L * 24 * 60 * 60;
    private static final String CSRF_HEADER_NAME = "X-Requested-With";
    private static final String CSRF_HEADER_VALUE = "XMLHttpRequest";

    private final AuthService authService;

    // [HttpOnly쿠키][보안] 운영(prod) 프로필에서는 true로 설정되어 HTTPS 전용 전송
    @Value("${mealfit.auth.cookie-secure:false}")
    private boolean cookieSecure;

    // [보안] /refresh, /logout 동일 출처 검증 허용 목록
    @Value("${mealfit.auth.allowed-origins:http://localhost:5173,http://127.0.0.1:5173,http://localhost:8080}")
    private List<String> allowedOrigins;

    /** [HttpOnly쿠키] Refresh Token 쿠키 생성/삭제 헬퍼 */
    private ResponseCookie buildRefreshCookie(String value, long maxAgeSeconds) {
        return ResponseCookie.from(REFRESH_COOKIE_NAME, value)
            .httpOnly(true)
            .secure(cookieSecure)
            .path("/api/v1/auth")
            .sameSite("Lax")
            .maxAge(maxAgeSeconds)
            .build();
    }

    /** [보안] 쿠키 기반 엔드포인트(/refresh, /logout)에 동일 출처(Origin/Referer) 및 CSRF 헤더를 검증합니다. */
    private void verifySameOriginAndCsrf(HttpServletRequest request) {
        String csrfHeader = request.getHeader(CSRF_HEADER_NAME);
        if (!CSRF_HEADER_VALUE.equals(csrfHeader)) {
            throw new BusinessException(ErrorCode.FORBIDDEN);
        }

        String origin = request.getHeader(HttpHeaders.ORIGIN);
        if (origin == null || origin.isBlank()) {
            String referer = request.getHeader(HttpHeaders.REFERER);
            if (referer != null && !referer.isBlank()) {
                origin = extractOrigin(referer);
                if (origin == null) {
                    throw new BusinessException(ErrorCode.FORBIDDEN);
                }
            }
        }

        if (origin != null && !origin.isBlank() && !isAllowedOrigin(origin, request)) {
            throw new BusinessException(ErrorCode.FORBIDDEN);
        }
    }

    private String extractOrigin(String url) {
        try {
            URI uri = URI.create(url);
            if (uri.getScheme() == null || uri.getHost() == null) {
                return null;
            }
            int port = uri.getPort();
            return port > 0
                ? uri.getScheme() + "://" + uri.getHost() + ":" + port
                : uri.getScheme() + "://" + uri.getHost();
        } catch (IllegalArgumentException ex) {
            return null;
        }
    }

    private boolean isAllowedOrigin(String origin, HttpServletRequest request) {
        String normalized = origin.trim().replaceAll("/+$", "");
        if (allowedOrigins != null) {
            for (String allowed : allowedOrigins) {
                if (normalized.equalsIgnoreCase(allowed.trim().replaceAll("/+$", ""))) {
                    return true;
                }
            }
        }
        String selfOrigin = request.getScheme() + "://" + request.getServerName()
            + ((request.getServerPort() == 80 || request.getServerPort() == 443)
                ? ""
                : ":" + request.getServerPort());
        return normalized.equalsIgnoreCase(selfOrigin);
    }

    /** [HttpOnly쿠키] 응답 바디에서 refreshToken만 null로 제거해 노출을 막습니다. */
    private TokenResponse withoutRefreshToken(TokenResponse tokens) {
        return new TokenResponse(
            tokens.accessToken(),
            null,
            tokens.tokenType(),
            tokens.expiresIn(),
            tokens.user()
        );
    }

    /** [이메일인증] 회원가입 시 미인증 상태로 저장하고 인증 메일을 발송합니다. (토큰 미발급) */
    @Operation(summary = "회원가입 및 인증 메일 발송")
    @PostMapping("/signup")
    @ResponseStatus(HttpStatus.CREATED)
    public SignupResponse signup(
        @Valid @RequestBody SignupRequest request
    ) {
        return authService.signup(request);
    }

    /** [이메일인증] 메일 링크의 인증 토큰을 검증해 이메일 인증을 완료합니다. */
    @Operation(summary = "이메일 인증 완료")
    @PostMapping("/email-verification/confirm")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void confirmEmail(
        @Valid @RequestBody EmailVerifyConfirmRequest request
    ) {
        authService.confirmEmailVerification(request.token());
    }

    /** [이메일인증] 미인증 계정에 인증 메일을 재발송합니다. */
    @Operation(summary = "이메일 인증 메일 재발송")
    @PostMapping("/email-verification/resend")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void resendEmail(
        @Valid @RequestBody EmailVerifyResendRequest request
    ) {
        authService.resendVerificationEmail(request.email());
    }

    /** [HttpOnly쿠키] 이메일 로그인 성공 시 Refresh Token을 HttpOnly 쿠키로 발급합니다. */
    @Operation(summary = "이메일 로그인")
    @PostMapping("/login")
    public ResponseEntity<TokenResponse> login(
        @Valid @RequestBody LoginRequest request
    ) {
        TokenResponse tokens = authService.login(request);
        ResponseCookie cookie = buildRefreshCookie(
            tokens.refreshToken(),
            REFRESH_COOKIE_MAX_AGE
        );
        return ResponseEntity.ok()
            .header(HttpHeaders.SET_COOKIE, cookie.toString())
            .body(withoutRefreshToken(tokens));
    }

    /** [HttpOnly쿠키][보안] 동일 출처·CSRF 검증 후 쿠키에서 Refresh Token을 읽어 재발급합니다. */
    @Operation(summary = "토큰 재발급")
    @PostMapping("/refresh")
    public ResponseEntity<TokenResponse> refresh(
        HttpServletRequest request,
        @CookieValue(name = REFRESH_COOKIE_NAME, required = false) String refreshToken
    ) {
        verifySameOriginAndCsrf(request);
        if (refreshToken == null || refreshToken.isBlank()) {
            throw new BusinessException(ErrorCode.AUTH_INVALID_REFRESH_TOKEN);
        }
        TokenResponse tokens = authService.refresh(refreshToken);
        ResponseCookie cookie = buildRefreshCookie(
            tokens.refreshToken(),
            REFRESH_COOKIE_MAX_AGE
        );
        return ResponseEntity.ok()
            .header(HttpHeaders.SET_COOKIE, cookie.toString())
            .body(withoutRefreshToken(tokens));
    }

    /** [HttpOnly쿠키][보안] 동일 출처·CSRF 검증 후 DB 토큰을 폐기하고 쿠키를 즉시 삭제합니다. */
    @Operation(summary = "로그아웃")
    @PostMapping("/logout")
    public ResponseEntity<Void> logout(
        HttpServletRequest request,
        @CookieValue(name = REFRESH_COOKIE_NAME, required = false) String refreshToken
    ) {
        verifySameOriginAndCsrf(request);
        if (refreshToken != null && !refreshToken.isBlank()) {
            authService.logout(refreshToken);
        }
        ResponseCookie deleteCookie = buildRefreshCookie("", 0);
        return ResponseEntity.noContent()
            .header(HttpHeaders.SET_COOKIE, deleteCookie.toString())
            .build();
    }
}
