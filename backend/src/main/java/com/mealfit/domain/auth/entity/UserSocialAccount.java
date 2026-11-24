package com.mealfit.domain.auth.entity;

import com.mealfit.global.common.BaseTimeEntity;
import jakarta.persistence.*;
import java.util.Locale;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 회원과 소셜 계정(Google·Naver·Kakao)의 1:N 연동 정보를 저장합니다.
 */
@Getter
@Entity
@Table(
    name = "user_social_accounts",
    uniqueConstraints = {
        @UniqueConstraint(name = "uk_social_provider_user", columnNames = {"provider", "provider_user_id"}),
        @UniqueConstraint(name = "uk_social_user_provider", columnNames = {"user_id", "provider"})
    }
)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UserSocialAccount extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private SocialProvider provider;

    @Column(name = "provider_user_id", nullable = false, length = 128)
    private String providerUserId;

    @Column(name = "provider_email", length = 254)
    private String providerEmail;

    public static UserSocialAccount create(
        Long userId,
        SocialProvider provider,
        String providerUserId,
        String providerEmail
    ) {
        UserSocialAccount account = new UserSocialAccount();
        account.userId = userId;
        account.provider = provider;
        account.providerUserId = providerUserId.trim();
        account.providerEmail = (providerEmail == null || providerEmail.isBlank())
            ? null
            : providerEmail.trim().toLowerCase(Locale.ROOT);
        return account;
    }
}
