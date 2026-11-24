package com.mealfit.domain.auth.service;

import com.mealfit.domain.auth.model.OAuth2UserInfo;

import com.mealfit.domain.auth.dto.SocialAccountsResponse;
import com.mealfit.domain.auth.entity.RefreshToken;
import com.mealfit.domain.auth.entity.SocialProvider;
import com.mealfit.domain.auth.entity.UserSocialAccount;
import com.mealfit.domain.auth.repository.RefreshTokenRepository;
import com.mealfit.domain.auth.repository.UserSocialAccountRepository;
import com.mealfit.domain.user.entity.Profile;
import com.mealfit.domain.user.entity.User;
import com.mealfit.domain.user.repository.ProfileRepository;
import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import com.mealfit.global.security.JwtProperties;
import com.mealfit.global.security.RefreshTokenProvider;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.Instant;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * [소셜로그인] Google·Naver·Kakao 로그인/가입, 기존 계정 연동·해제, 1회용 연동 쿠키 서명을 처리합니다.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SocialAuthService {

    private static final long LINK_INTENT_TTL_SECONDS = 300L;

    private final UserRepository userRepository;
    private final ProfileRepository profileRepository;
    private final UserSocialAccountRepository socialAccountRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final RefreshTokenProvider refreshTokenProvider;
    private final JwtProperties jwtProperties;

    public record LinkIntent(Long userId, SocialProvider provider) {}

    /**
     * [소셜로그인] OAuth2 인증 결과로 기존 소셜 회원을 로그인시키거나 신규 소셜 회원을 생성하고
     * HttpOnly 쿠키에 담을 Refresh Token 원문을 반환합니다.
     */
    @Transactional
    public String loginOrRegister(OAuth2UserInfo info) {
        Optional<UserSocialAccount> existing = socialAccountRepository
            .findByProviderAndProviderUserId(info.provider(), info.providerUserId());

        if (existing.isPresent()) {
            User user = userRepository.findByIdForUpdate(existing.get().getUserId())
                .orElseThrow(() -> new BusinessException(ErrorCode.AUTH_LOGIN_FAILED));
            if (user.getDeletedAt() != null) {
                throw new BusinessException(ErrorCode.AUTH_LOGIN_FAILED);
            }
            return issueRefreshToken(user.getId());
        }

        // [소셜로그인] 소셜에서 실제 이메일을 받은 경우, 이미 일반 가입된 계정이 있으면 자동 통합하지 않고 안내합니다.
        String resolvedEmail;
        if (info.email() != null && !info.email().isBlank()) {
            String normalizedEmail = info.email().trim().toLowerCase(Locale.ROOT);
            Optional<User> sameEmailUser = userRepository.findByEmailForUpdate(normalizedEmail);
            if (sameEmailUser.isPresent() && sameEmailUser.get().getDeletedAt() == null) {
                throw new BusinessException(ErrorCode.AUTH_SOCIAL_EMAIL_ALREADY_REGISTERED);
            }
            resolvedEmail = normalizedEmail;
        } else {
            // [소셜로그인] 카카오 등에서 이메일 선택 동의를 하지 않은 경우 내부 고유 이메일 생성
            resolvedEmail = info.provider().getRegistrationId()
                + "_" + info.providerUserId()
                + "@social.mealfit.local";
        }

        User newUser = userRepository.saveAndFlush(User.createSocial(resolvedEmail));
        profileRepository.save(Profile.create(newUser.getId(), info.nickname()));
        socialAccountRepository.save(
            UserSocialAccount.create(newUser.getId(), info.provider(), info.providerUserId(), info.email())
        );

        return issueRefreshToken(newUser.getId());
    }

    /**
     * [소셜로그인] 로그인된 기존 계정에 소셜 계정을 명시적으로 연동합니다.
     * 이메일 도메인(@gmail/@naver/@kakao·daum·hanmail)과 일치하는 소셜 플랫폼만 허용합니다.
     */
    @Transactional
    public void linkAccount(Long userId, OAuth2UserInfo info) {
        User user = userRepository.findByIdForUpdate(userId)
            .orElseThrow(() -> new BusinessException(ErrorCode.UNAUTHORIZED));
        if (user.getDeletedAt() != null) {
            throw new BusinessException(ErrorCode.UNAUTHORIZED);
        }

        // [소셜로그인] 3개 소셜 도메인 외 이메일 가입자 또는 다른 소셜 플랫폼 연동 요청 차단
        SocialProvider eligible = SocialProvider.fromEmail(user.getEmail()).orElse(null);
        if (eligible == null || eligible != info.provider()) {
            throw new BusinessException(ErrorCode.AUTH_SOCIAL_LINK_DOMAIN_MISMATCH);
        }

        // [소셜로그인] 소셜 제공자에서 이메일이 넘어온 경우, 기존 계정의 이메일과 정확히 일치해야 연동 허용
        if (info.email() != null && !info.email().isBlank()
            && !info.email().trim().equalsIgnoreCase(user.getEmail())) {
            throw new BusinessException(ErrorCode.AUTH_SOCIAL_LINK_DOMAIN_MISMATCH);
        }

        Optional<UserSocialAccount> existingByProviderId = socialAccountRepository
            .findByProviderAndProviderUserId(info.provider(), info.providerUserId());
        if (existingByProviderId.isPresent()) {
            if (existingByProviderId.get().getUserId().equals(userId)) {
                return; // 이미 본인 계정에 연동된 경우 멱등 처리
            }
            throw new BusinessException(ErrorCode.AUTH_SOCIAL_ALREADY_LINKED_OTHER);
        }

        if (socialAccountRepository.existsByUserIdAndProvider(userId, info.provider())) {
            throw new BusinessException(ErrorCode.AUTH_SOCIAL_ALREADY_LINKED_OTHER);
        }

        socialAccountRepository.save(
            UserSocialAccount.create(userId, info.provider(), info.providerUserId(), info.email())
        );
    }

    /** [소셜로그인] 로그인한 회원의 연동 현황과 마이페이지 연동 UI 노출 여부를 조회합니다. */
    public SocialAccountsResponse getSocialAccounts(Long userId) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new BusinessException(ErrorCode.UNAUTHORIZED));
        if (user.getDeletedAt() != null) {
            throw new BusinessException(ErrorCode.UNAUTHORIZED);
        }

        List<String> linkedProviders = socialAccountRepository.findAllByUserIdOrderByIdAsc(userId)
            .stream()
            .map(account -> account.getProvider().getRegistrationId())
            .toList();

        String eligibleProvider = SocialProvider.fromEmail(user.getEmail())
            .map(SocialProvider::getRegistrationId)
            .orElse(null);

        boolean canManage = (eligibleProvider != null) || !linkedProviders.isEmpty();

        return new SocialAccountsResponse(
            linkedProviders,
            eligibleProvider,
            user.hasPassword(),
            canManage
        );
    }

    /** [소셜로그인] 연동된 소셜 계정을 해제합니다. 비밀번호가 없는 계정의 마지막 수단은 해제할 수 없습니다. */
    @Transactional
    public void unlinkAccount(Long userId, String providerValue) {
        SocialProvider provider = SocialProvider.fromRegistrationId(providerValue)
            .orElseThrow(() -> new BusinessException(ErrorCode.AUTH_SOCIAL_PROVIDER_UNSUPPORTED));

        User user = userRepository.findByIdForUpdate(userId)
            .orElseThrow(() -> new BusinessException(ErrorCode.UNAUTHORIZED));
        if (user.getDeletedAt() != null) {
            throw new BusinessException(ErrorCode.UNAUTHORIZED);
        }

        UserSocialAccount account = socialAccountRepository.findByUserIdAndProvider(userId, provider)
            .orElseThrow(() -> new BusinessException(ErrorCode.NOT_FOUND));

        if (!user.hasPassword() && socialAccountRepository.countByUserId(userId) <= 1) {
            throw new BusinessException(ErrorCode.AUTH_SOCIAL_UNLINK_NOT_ALLOWED);
        }

        socialAccountRepository.delete(account);
    }

    /**
     * [소셜로그인] 마이페이지·팝업에서 OAuth2 연동 시작 전 본인 확인용 1회성 서명 토큰(5분 유효)을 발급합니다.
     */
    public String createLinkIntentToken(Long userId, String providerValue) {
        SocialProvider provider = SocialProvider.fromRegistrationId(providerValue)
            .orElseThrow(() -> new BusinessException(ErrorCode.AUTH_SOCIAL_PROVIDER_UNSUPPORTED));

        User user = userRepository.findById(userId)
            .orElseThrow(() -> new BusinessException(ErrorCode.UNAUTHORIZED));
        if (user.getDeletedAt() != null) {
            throw new BusinessException(ErrorCode.UNAUTHORIZED);
        }

        SocialProvider eligible = SocialProvider.fromEmail(user.getEmail()).orElse(null);
        if (eligible == null || eligible != provider) {
            throw new BusinessException(ErrorCode.AUTH_SOCIAL_LINK_DOMAIN_MISMATCH);
        }

        long expiresAt = Instant.now().getEpochSecond() + LINK_INTENT_TTL_SECONDS;
        String payload = userId + ":" + provider.getRegistrationId() + ":" + expiresAt;
        String sig = hmacSign(payload);
        return Base64.getUrlEncoder().withoutPadding()
            .encodeToString((payload + ":" + sig).getBytes(StandardCharsets.UTF_8));
    }

    /** [소셜로그인] 연동 쿠키의 서명과 만료 시각을 검증하고 (userId, provider)를 복원합니다. */
    public Optional<LinkIntent> parseLinkIntentToken(String token) {
        if (token == null || token.isBlank()) {
            return Optional.empty();
        }
        try {
            String decoded = new String(Base64.getUrlDecoder().decode(token), StandardCharsets.UTF_8);
            String[] parts = decoded.split(":");
            if (parts.length != 4) {
                return Optional.empty();
            }
            String payload = parts[0] + ":" + parts[1] + ":" + parts[2];
            String expectedSig = hmacSign(payload);
            if (!MessageDigest.isEqual(
                expectedSig.getBytes(StandardCharsets.UTF_8),
                parts[3].getBytes(StandardCharsets.UTF_8))) {
                return Optional.empty();
            }
            long expiresAt = Long.parseLong(parts[2]);
            if (Instant.now().getEpochSecond() > expiresAt) {
                return Optional.empty();
            }
            Long userId = Long.parseLong(parts[0]);
            SocialProvider provider = SocialProvider.fromRegistrationId(parts[1]).orElse(null);
            if (provider == null) {
                return Optional.empty();
            }
            return Optional.of(new LinkIntent(userId, provider));
        } catch (Exception ex) {
            return Optional.empty();
        }
    }

    private String issueRefreshToken(Long userId) {
        String rawRefreshToken = refreshTokenProvider.generateToken();
        String tokenHash = refreshTokenProvider.hashToken(rawRefreshToken);
        LocalDateTime expiresAt = LocalDateTime.now().plus(jwtProperties.refreshTokenTtl());
        refreshTokenRepository.save(RefreshToken.create(userId, tokenHash, expiresAt));
        return rawRefreshToken;
    }

    private String hmacSign(String payload) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            byte[] keyBytes = Base64.getDecoder().decode(jwtProperties.secret());
            mac.init(new SecretKeySpec(keyBytes, "HmacSHA256"));
            byte[] digest = mac.doFinal(payload.getBytes(StandardCharsets.UTF_8));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(digest);
        } catch (Exception ex) {
            throw new IllegalStateException("연동 토큰 서명에 실패했습니다.", ex);
        }
    }
}
