package com.mealfit.domain.user.entity;

import com.mealfit.global.common.BaseTimeEntity;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.Locale;
import java.util.UUID;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@Table(name = "users")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 254)
    private String email;

    // [소셜로그인] 소셜 전용 회원은 비밀번호가 없으므로 NULL을 허용합니다 (V12).
    @Column(name = "password_hash", nullable = true, length = 100)
    private String passwordHash;

    /** null이면 정상 회원이며, 탈퇴하면 최초 탈퇴 시각을 기록합니다. */
    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    /** 중복 호출되어도 최초 탈퇴 시각과 익명화된 이메일을 유지합니다. */
    public void withdraw() {
        if (deletedAt == null) {
            deletedAt = LocalDateTime.now();
            String key = (id != null ? id + "_" : "")
                + UUID.randomUUID().toString().replace("-", "");
            email = "withdrawn_" + key + "@deleted.local";
        }
    }

    public static User create(String email, String passwordHash) {
        User user = new User();
        user.email = email.trim().toLowerCase(Locale.ROOT);
        user.passwordHash = passwordHash;
        // [이메일인증] 신규 가입 직후에는 메일 인증 전이므로 false로 시작
        user.emailVerified = false;
        return user;
    }

    /** [소셜로그인] 비밀번호 없이 소셜 인증으로 가입하는 회원을 생성합니다. (이메일 인증 완료 처리) */
    public static User createSocial(String email) {
        User user = new User();
        user.email = email.trim().toLowerCase(Locale.ROOT);
        user.passwordHash = null;
        user.emailVerified = true;
        user.emailVerifiedAt = LocalDateTime.now();
        return user;
    }

    /** [소셜로그인] 일반 비밀번호가 설정된 계정인지 여부를 반환합니다. */
    public boolean hasPassword() {
        return this.passwordHash != null && !this.passwordHash.isBlank();
    }

    // [이메일인증] 이메일 인증 완료 여부 (신규 가입자는 false, 기존 가입자는 V8 마이그레이션에서 true)
    @Column(name = "email_verified", nullable = false)
    private boolean emailVerified;

    // [이메일인증] 최초 이메일 인증을 완료한 시각 (미인증이면 null)
    @Column(name = "email_verified_at")
    private LocalDateTime emailVerifiedAt;

    /** [이메일인증] 아직 미인증 상태인 회원을 인증 완료로 전환하고 인증 시각을 기록합니다. */
    public void markEmailVerified() {
        if (!this.emailVerified) {
            this.emailVerified = true;
            this.emailVerifiedAt = LocalDateTime.now();
        }
    }
}
