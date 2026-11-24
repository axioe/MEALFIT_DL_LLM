package com.mealfit.domain.auth.entity;

import java.util.Locale;
import java.util.Optional;
import java.util.Set;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * 지원하는 소셜 로그인 제공자와 이메일 도메인 매핑 기준을 정의합니다.
 */
@Getter
@RequiredArgsConstructor
public enum SocialProvider {
    GOOGLE("google", "Google", Set.of("gmail.com")),
    NAVER("naver", "네이버", Set.of("naver.com")),
    KAKAO("kakao", "카카오", Set.of("kakao.com", "daum.net", "hanmail.net"));

    private final String registrationId;
    private final String displayName;
    private final Set<String> emailDomains;

    public static Optional<SocialProvider> fromRegistrationId(String value) {
        if (value == null || value.isBlank()) {
            return Optional.empty();
        }
        String normalized = value.trim().toLowerCase(Locale.ROOT);
        for (SocialProvider provider : values()) {
            if (provider.registrationId.equals(normalized)
                || provider.name().equalsIgnoreCase(normalized)) {
                return Optional.of(provider);
            }
        }
        return Optional.empty();
    }

    /** 이메일 도메인이 3개 소셜 플랫폼 중 하나에 속하면 해당 제공자를 반환합니다. */
    public static Optional<SocialProvider> fromEmail(String email) {
        if (email == null) {
            return Optional.empty();
        }
        int at = email.lastIndexOf('@');
        if (at < 0 || at == email.length() - 1) {
            return Optional.empty();
        }
        String domain = email.substring(at + 1).trim().toLowerCase(Locale.ROOT);
        for (SocialProvider provider : values()) {
            if (provider.emailDomains.contains(domain)) {
                return Optional.of(provider);
            }
        }
        return Optional.empty();
    }
}
