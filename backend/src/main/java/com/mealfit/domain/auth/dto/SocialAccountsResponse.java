package com.mealfit.domain.auth.dto;

import java.util.List;

/**
 * [소셜로그인] 로그인한 회원의 소셜 계정 연동 현황과 연동 가능 여부를 반환합니다.
 * - eligibleProvider: 이메일 도메인(@gmail/@naver/@kakao·daum·hanmail)에 매핑되는 소셜 제공자 (그 외 도메인은 null)
 * - linkedProviders: 현재 계정에 연동된 소셜 제공자 목록 (google, naver, kakao)
 * - canManageSocialLinks: 마이페이지에 소셜 연동 영역을 노출할지 여부
 */
public record SocialAccountsResponse(
    List<String> linkedProviders,
    String eligibleProvider,
    boolean hasPassword,
    boolean canManageSocialLinks
) {
}
