package com.mealfit.domain.auth;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.domain.auth.entity.SocialProvider;
import com.mealfit.domain.auth.model.OAuth2UserInfo;
import com.mealfit.domain.auth.service.SocialAuthService;
import com.mealfit.domain.auth.repository.UserSocialAccountRepository;
import com.mealfit.domain.user.entity.Profile;
import com.mealfit.domain.user.entity.User;
import com.mealfit.domain.user.repository.ProfileRepository;
import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import com.mealfit.support.TestJwt;
import jakarta.servlet.http.Cookie;
import java.util.Map;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

/**
 * [소셜로그인] Google·Naver·Kakao 파서, 신규 가입·재로그인, 이메일 중복 차단,
 * 3개 도메인 기반 계정 연동/해제 정책을 검증합니다.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class SocialAuthApiTest {

    @Autowired MockMvc mvc;
    @Autowired ObjectMapper mapper;
    @Autowired SocialAuthService socialAuthService;
    @Autowired UserRepository userRepository;
    @Autowired ProfileRepository profileRepository;
    @Autowired UserSocialAccountRepository socialAccountRepository;
    @Autowired PasswordEncoder passwordEncoder;

    private User createVerifiedPasswordUser(String email, String nickname) {
        User user = User.create(email, passwordEncoder.encode("Password123!"));
        user.markEmailVerified();
        user = userRepository.saveAndFlush(user);
        profileRepository.saveAndFlush(Profile.create(user.getId(), nickname));
        return user;
    }

    @Test
    void 구글_네이버_카카오_프로필_파서가_응답을_표준화한다() {
        OAuth2UserInfo google = OAuth2UserInfo.of("google", Map.of(
            "sub", "g-123",
            "email", "Test@Gmail.com",
            "name", "구글유저"
        ));
        assertThat(google.provider()).isEqualTo(SocialProvider.GOOGLE);
        assertThat(google.providerUserId()).isEqualTo("g-123");
        assertThat(google.email()).isEqualTo("Test@Gmail.com");
        assertThat(google.nickname()).isEqualTo("구글유저");

        OAuth2UserInfo naver = OAuth2UserInfo.of("naver", Map.of(
            "response", Map.of("id", "n-456", "email", "user@naver.com", "nickname", "네이버유저")
        ));
        assertThat(naver.provider()).isEqualTo(SocialProvider.NAVER);
        assertThat(naver.providerUserId()).isEqualTo("n-456");
        assertThat(naver.nickname()).isEqualTo("네이버유저");

        OAuth2UserInfo kakaoNoEmail = OAuth2UserInfo.of("kakao", Map.of(
            "id", 987654321L,
            "kakao_account", Map.of("profile", Map.of("nickname", "카카오유저"))
        ));
        assertThat(kakaoNoEmail.provider()).isEqualTo(SocialProvider.KAKAO);
        assertThat(kakaoNoEmail.providerUserId()).isEqualTo("987654321");
        assertThat(kakaoNoEmail.email()).isNull();
        assertThat(kakaoNoEmail.nickname()).isEqualTo("카카오유저");
    }

    @Test
    void 신규_소셜가입시_Refresh토큰이_발급되고_비밀번호_일반로그인은_차단된다() throws Exception {
        String providerId = "kakao-" + UUID.randomUUID();
        OAuth2UserInfo info = new OAuth2UserInfo(SocialProvider.KAKAO, providerId, null, "카카오신규");

        String rawRefreshToken = socialAuthService.loginOrRegister(info);
        assertThat(rawRefreshToken).isNotBlank();

        // 발급된 Refresh 쿠키로 Access JWT 재발급 성공
        mvc.perform(post("/api/v1/auth/refresh")
                .header("X-Requested-With", "XMLHttpRequest")
                .cookie(new Cookie("refresh_token", rawRefreshToken)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.accessToken").isNotEmpty())
            .andExpect(jsonPath("$.user.nickname").value("카카오신규"));

        // 비밀번호가 없는 소셜 전용 계정은 일반 비밀번호 로그인 차단(401)
        String internalEmail = "kakao_" + providerId + "@social.mealfit.local";
        mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of(
                    "email", internalEmail,
                    "password", "AnyPassword123!"
                ))))
            .andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.code").value("AUTH_002"));
    }

    @Test
    void 이미_이메일로_가입된_계정은_소셜로그인시_자동통합하지않고_AUTH_009로_차단한다() {
        String email = "dup-" + UUID.randomUUID() + "@gmail.com";
        createVerifiedPasswordUser(email, "기존회원");

        OAuth2UserInfo google = new OAuth2UserInfo(
            SocialProvider.GOOGLE, "g-" + UUID.randomUUID(), email, "구글유저"
        );

        assertThatThrownBy(() -> socialAuthService.loginOrRegister(google))
            .isInstanceOf(BusinessException.class)
            .extracting("errorCode")
            .isEqualTo(ErrorCode.AUTH_SOCIAL_EMAIL_ALREADY_REGISTERED);
    }

    @Test
    void 도메인별_연동가능여부와_연동_해제_및_기타도메인_숨김을_검증한다() throws Exception {
        // 1) @gmail.com 일반 가입자 → google 연동 가능, canManageSocialLinks=true
        User gmailUser = createVerifiedPasswordUser("user-" + UUID.randomUUID() + "@gmail.com", "지메일회원");
        mvc.perform(get("/api/v1/me/social-accounts").with(TestJwt.user(gmailUser.getId())))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.eligibleProvider").value("google"))
            .andExpect(jsonPath("$.hasPassword").value(true))
            .andExpect(jsonPath("$.canManageSocialLinks").value(true))
            .andExpect(jsonPath("$.linkedProviders").isEmpty());

        // google 연동 시작 쿠키 발급 성공
        mvc.perform(post("/api/v1/auth/social/link-intent")
                .with(TestJwt.user(gmailUser.getId()))
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("provider", "google"))))
            .andExpect(status().isNoContent())
            .andExpect(header().exists("Set-Cookie"));

        // 다른 도메인(naver) 연동 시도는 AUTH_012로 차단
        mvc.perform(post("/api/v1/auth/social/link-intent")
                .with(TestJwt.user(gmailUser.getId()))
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("provider", "naver"))))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("AUTH_012"));

        // 같은 도메인이라도 다른 구글 이메일 계정 연동 시도는 AUTH_012로 차단
        assertThatThrownBy(() -> socialAuthService.linkAccount(
            gmailUser.getId(),
            new OAuth2UserInfo(SocialProvider.GOOGLE, "g-other-" + UUID.randomUUID(), "other@gmail.com", "다른구글")
        ))
            .isInstanceOf(BusinessException.class)
            .extracting("errorCode")
            .isEqualTo(ErrorCode.AUTH_SOCIAL_LINK_DOMAIN_MISMATCH);

        // 실제 연동 후 조회 → linkedProviders=["google"]
        socialAuthService.linkAccount(
            gmailUser.getId(),
            new OAuth2UserInfo(SocialProvider.GOOGLE, "g-link-" + UUID.randomUUID(), gmailUser.getEmail(), "지메일회원")
        );
        mvc.perform(get("/api/v1/me/social-accounts").with(TestJwt.user(gmailUser.getId())))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.linkedProviders[0]").value("google"));

        // 비밀번호가 있는 일반 가입자는 소셜 연동 해제 가능
        mvc.perform(delete("/api/v1/me/social-accounts/google").with(TestJwt.user(gmailUser.getId())))
            .andExpect(status().isNoContent());

        // 2) 3개 소셜 외 도메인(@company.co.kr) 일반 가입자 → canManageSocialLinks=false, 연동 차단
        User otherDomainUser = createVerifiedPasswordUser("user-" + UUID.randomUUID() + "@company.co.kr", "회사회원");
        mvc.perform(get("/api/v1/me/social-accounts").with(TestJwt.user(otherDomainUser.getId())))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.eligibleProvider").doesNotExist())
            .andExpect(jsonPath("$.canManageSocialLinks").value(false));

        mvc.perform(post("/api/v1/auth/social/link-intent")
                .with(TestJwt.user(otherDomainUser.getId()))
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(Map.of("provider", "google"))))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("AUTH_012"));
    }

    @Test
    void 비밀번호가_없는_소셜전용_계정은_마지막_연동을_해제할수없다() throws Exception {
        String providerId = "naver-" + UUID.randomUUID();
        String email = "social-" + UUID.randomUUID() + "@naver.com";
        socialAuthService.loginOrRegister(new OAuth2UserInfo(SocialProvider.NAVER, providerId, email, "네이버전용"));

        Long userId = userRepository.findByEmail(email).orElseThrow().getId();
        assertThat(socialAccountRepository.countByUserId(userId)).isEqualTo(1L);

        mvc.perform(delete("/api/v1/me/social-accounts/naver").with(TestJwt.user(userId)))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("AUTH_013"));
    }
}
