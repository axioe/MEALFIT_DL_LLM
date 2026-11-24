package com.mealfit.domain.auth.model;

import com.mealfit.domain.auth.entity.SocialProvider;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.util.Map;

/**
 * [소셜로그인] Google·Naver·Kakao마다 다른 OAuth2 사용자 정보 응답을 공통 형식으로 표준화합니다.
 */
public record OAuth2UserInfo(
    SocialProvider provider,
    String providerUserId,
    String email,
    String nickname
) {
    private static final int MAX_NICKNAME_LENGTH = 50;

    public static OAuth2UserInfo of(String registrationId, Map<String, Object> attributes) {
        SocialProvider provider = SocialProvider.fromRegistrationId(registrationId)
            .orElseThrow(() -> new BusinessException(ErrorCode.AUTH_SOCIAL_PROVIDER_UNSUPPORTED));

        return switch (provider) {
            case GOOGLE -> parseGoogle(attributes);
            case NAVER -> parseNaver(attributes);
            case KAKAO -> parseKakao(attributes);
        };
    }

    private static OAuth2UserInfo parseGoogle(Map<String, Object> attrs) {
        String id = asString(attrs.get("sub"));
        String email = asString(attrs.get("email"));
        String name = asString(attrs.get("name"));
        return build(SocialProvider.GOOGLE, id, email, name);
    }

    @SuppressWarnings("unchecked")
    private static OAuth2UserInfo parseNaver(Map<String, Object> attrs) {
        Object responseObj = attrs.get("response");
        Map<String, Object> response = (responseObj instanceof Map<?, ?> map)
            ? (Map<String, Object>) map
            : attrs;
        String id = asString(response.get("id"));
        String email = asString(response.get("email"));
        String nickname = firstNonBlank(asString(response.get("nickname")), asString(response.get("name")));
        return build(SocialProvider.NAVER, id, email, nickname);
    }

    @SuppressWarnings("unchecked")
    private static OAuth2UserInfo parseKakao(Map<String, Object> attrs) {
        String id = asString(attrs.get("id"));
        String email = null;
        String nickname = null;

        Object accountObj = attrs.get("kakao_account");
        if (accountObj instanceof Map<?, ?> accountMap) {
            Map<String, Object> account = (Map<String, Object>) accountMap;
            email = asString(account.get("email"));
            Object profileObj = account.get("profile");
            if (profileObj instanceof Map<?, ?> profileMap) {
                nickname = asString(((Map<String, Object>) profileMap).get("nickname"));
            }
        }
        if (nickname == null || nickname.isBlank()) {
            Object propsObj = attrs.get("properties");
            if (propsObj instanceof Map<?, ?> propsMap) {
                nickname = asString(((Map<String, Object>) propsMap).get("nickname"));
            }
        }
        return build(SocialProvider.KAKAO, id, email, nickname);
    }

    private static OAuth2UserInfo build(
        SocialProvider provider,
        String id,
        String email,
        String rawNickname
    ) {
        if (id == null || id.isBlank()) {
            throw new BusinessException(ErrorCode.AUTH_INVALID_TOKEN);
        }
        String cleanEmail = (email == null || email.isBlank()) ? null : email.trim();
        String cleanNickname = normalizeNickname(rawNickname, provider);
        return new OAuth2UserInfo(provider, id.trim(), cleanEmail, cleanNickname);
    }

    private static String normalizeNickname(String rawNickname, SocialProvider provider) {
        String candidate = (rawNickname == null || rawNickname.isBlank())
            ? provider.getDisplayName() + "회원"
            : rawNickname.trim();
        return candidate.length() > MAX_NICKNAME_LENGTH
            ? candidate.substring(0, MAX_NICKNAME_LENGTH)
            : candidate;
    }

    private static String asString(Object value) {
        return value == null ? null : String.valueOf(value);
    }

    private static String firstNonBlank(String first, String second) {
        return (first != null && !first.isBlank()) ? first : second;
    }
}
