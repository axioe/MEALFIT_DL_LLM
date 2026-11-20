package com.mealfit.domain.auth.entity;

import com.mealfit.global.common.BaseTimeEntity;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * [이메일인증] 회원가입 후 이메일 소유 여부를 확인하기 위한 1회용 인증 토큰 엔티티입니다.
 * 보안상 토큰 원문은 저장하지 않고 SHA-256 해시값(64자)만 DB에 보관합니다.
 */
@Getter
@Entity
@Table(name = "email_verification_tokens")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class EmailVerificationToken extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** [이메일인증] 인증을 요청한 회원 ID (users.id) */
    @Column(name = "user_id", nullable = false)
    private Long userId;

    /** [이메일인증] 인증 토큰 원문의 SHA-256 해시값 (16진수 64자) */
    @Column(name = "token_hash", nullable = false, unique = true, length = 64)
    private String tokenHash;

    /** [이메일인증] 토큰 만료 시각 (예: 발급 후 30분) */
    @Column(name = "expires_at", nullable = false)
    private LocalDateTime expiresAt;

    /** [이메일인증] 토큰 사용(인증 완료) 또는 재발송으로 폐기된 시각 (미사용이면 null) */
    @Column(name = "used_at")
    private LocalDateTime usedAt;

    /** [이메일인증] 신규 인증 토큰 엔티티를 생성합니다. */
    public static EmailVerificationToken create(
        Long userId,
        String tokenHash,
        LocalDateTime expiresAt
    ) {
        EmailVerificationToken token = new EmailVerificationToken();
        token.userId = userId;
        token.tokenHash = tokenHash;
        token.expiresAt = expiresAt;
        return token;
    }

    /** [이메일인증] 현재 시각 기준으로 만료되었는지 확인합니다. */
    public boolean isExpired(LocalDateTime now) {
        return !now.isBefore(expiresAt);
    }

    /** [이메일인증] 이미 사용되었거나 재발송으로 무효화된 토큰인지 확인합니다. */
    public boolean isUsed() {
        return usedAt != null;
    }

    /** [이메일인증] 토큰을 사용(또는 폐기) 처리하여 재사용을 막습니다. */
    public void markUsed(LocalDateTime now) {
        if (this.usedAt == null) {
            this.usedAt = now;
        }
    }
}
