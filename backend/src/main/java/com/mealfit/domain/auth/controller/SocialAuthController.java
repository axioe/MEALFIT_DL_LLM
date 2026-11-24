package com.mealfit.domain.auth.controller;

import com.mealfit.domain.auth.dto.SocialAccountsResponse;
import com.mealfit.domain.auth.service.SocialAuthService;
import com.mealfit.global.security.OAuth2SuccessHandler;
import com.mealfit.global.web.CurrentUserId;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * [소셜로그인] 로그인한 회원의 소셜 연동 현황 조회, 연동 시작 쿠키 발급, 연동 해제를 제공합니다.
 */
@Tag(name = "Auth", description = "소셜 계정 연동 관리")
@RestController
@RequiredArgsConstructor
public class SocialAuthController {

    private final SocialAuthService socialAuthService;

    @Value("${mealfit.auth.cookie-secure:false}")
    private boolean cookieSecure;

    public record LinkIntentRequest(@NotBlank String provider) {}

    /** [소셜로그인] 내 연동된 소셜 계정과 이메일 도메인 기준 연동 가능 플랫폼을 조회합니다. */
    @Operation(summary = "내 소셜 연동 현황 조회")
    @GetMapping("/api/v1/me/social-accounts")
    public SocialAccountsResponse getSocialAccounts(@CurrentUserId Long userId) {
        return socialAuthService.getSocialAccounts(userId);
    }

    /** [소셜로그인] 마이페이지·팝업에서 OAuth2 연동을 시작하기 전 1회용 연동 쿠키(5분)를 발급합니다. */
    @Operation(summary = "소셜 계정 연동 시작 토큰 쿠키 발급")
    @PostMapping("/api/v1/auth/social/link-intent")
    public ResponseEntity<Void> prepareSocialLink(
        @CurrentUserId Long userId,
        @Valid @RequestBody LinkIntentRequest request
    ) {
        String token = socialAuthService.createLinkIntentToken(userId, request.provider());
        ResponseCookie cookie = ResponseCookie.from(OAuth2SuccessHandler.LINK_INTENT_COOKIE_NAME, token)
            .httpOnly(true)
            .secure(cookieSecure)
            .path(OAuth2SuccessHandler.LINK_INTENT_COOKIE_PATH)
            .sameSite("Lax")
            .maxAge(300L)
            .build();
        return ResponseEntity.noContent()
            .header(HttpHeaders.SET_COOKIE, cookie.toString())
            .build();
    }

    /** [소셜로그인] 연동된 특정 소셜 계정을 해제합니다. */
    @Operation(summary = "소셜 계정 연동 해제")
    @DeleteMapping("/api/v1/me/social-accounts/{provider}")
    public ResponseEntity<Void> unlinkSocialAccount(
        @CurrentUserId Long userId,
        @PathVariable String provider
    ) {
        socialAuthService.unlinkAccount(userId, provider);
        return ResponseEntity.noContent().build();
    }
}
