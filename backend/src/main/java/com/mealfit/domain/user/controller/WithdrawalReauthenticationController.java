package com.mealfit.domain.user.controller;

import com.mealfit.domain.auth.entity.SocialProvider;
import com.mealfit.domain.user.service.WithdrawalReauthentication;
import com.mealfit.domain.user.service.WithdrawalService;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import com.mealfit.global.security.WithdrawalOAuth2RequestResolver;
import com.mealfit.global.web.CurrentUserId;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/me/withdrawal")
@RequiredArgsConstructor
public class WithdrawalReauthenticationController {
    private static final String COOKIE = WithdrawalOAuth2RequestResolver.COOKIE;
    private final WithdrawalReauthentication reauthentication;
    private final WithdrawalService withdrawalService;

    @Value("${mealfit.auth.cookie-secure:false}")
    private boolean cookieSecure;

    public record StartRequest(@NotBlank String provider) {}
    public record ReauthenticationStatus(long remainingMillis) {}

    @PostMapping("/reauthentication")
    public ResponseEntity<Void> start(@CurrentUserId Long userId, @Valid @RequestBody StartRequest request,
                                     @CookieValue(name = COOKIE, required = false) String previousToken) {
        SocialProvider provider = SocialProvider.fromRegistrationId(request.provider())
            .orElseThrow(() -> new BusinessException(ErrorCode.AUTH_SOCIAL_PROVIDER_UNSUPPORTED));
        String token = reauthentication.start(userId, provider, previousToken);
        return ResponseEntity.noContent().header(HttpHeaders.SET_COOKIE, cookie(token)).build();
    }

    @GetMapping("/reauthentication")
    public ResponseEntity<ReauthenticationStatus> status(@CurrentUserId Long userId,
                                                        @CookieValue(name = COOKIE, required = false) String token) {
        return ResponseEntity.ok().cacheControl(CacheControl.noStore())
            .body(new ReauthenticationStatus(reauthentication.remainingMillis(token, userId)));
    }

    @DeleteMapping("/reauthentication")
    public ResponseEntity<Void> cancel(@CurrentUserId Long userId,
                                       @CookieValue(name = COOKIE, required = false) String token) {
        reauthentication.cancel(token, userId);
        return ResponseEntity.noContent().header(HttpHeaders.SET_COOKIE, cookie(null)).build();
    }

    @PostMapping("/confirm")
    public ResponseEntity<Void> confirm(@CurrentUserId Long userId,
                                        @CookieValue(name = COOKIE, required = false) String token) {
        withdrawalService.withdrawSocial(userId, token);
        reauthentication.forgetUser(userId);
        var refreshCookie = ResponseCookie.from("refresh_token", "")
            .httpOnly(true).secure(cookieSecure).path("/api/v1/auth").sameSite("Lax").maxAge(0).build();
        return ResponseEntity.noContent()
            .header(HttpHeaders.SET_COOKIE, cookie(null), refreshCookie.toString())
            .build();
    }

    private String cookie(String token) {
        return WithdrawalOAuth2RequestResolver.responseCookie(token, cookieSecure).toString();
    }
}
