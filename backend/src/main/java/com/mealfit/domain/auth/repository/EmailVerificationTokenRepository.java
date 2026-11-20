package com.mealfit.domain.auth.repository;

import com.mealfit.domain.auth.entity.EmailVerificationToken;
import jakarta.persistence.LockModeType;
import java.time.LocalDateTime;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 * [이메일인증] 이메일 인증 토큰 조회·쿨다운 확인·기존 토큰 폐기를 담당합니다.
 */
public interface EmailVerificationTokenRepository
    extends JpaRepository<EmailVerificationToken, Long> {

    /**
     * [이메일인증] 잠금 순서를 회원 → 토큰으로 통일하기 위해 먼저 userId만 잠금 없이 조회합니다.
     */
    @Query("""
        select t.userId
        from EmailVerificationToken t
        where t.tokenHash = :tokenHash
        """)
    Optional<Long> findUserIdByTokenHash(
        @Param("tokenHash") String tokenHash
    );

    /**
     * [이메일인증] 토큰 해시로 조회하면서 쓰기 잠금(PESSIMISTIC_WRITE)을 겁니다.
     * 같은 인증 링크를 동시에 여러 번 클릭해도 1회만 처리되도록 보호합니다.
     */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("""
        select t
        from EmailVerificationToken t
        where t.tokenHash = :tokenHash
        """)
    Optional<EmailVerificationToken> findByTokenHashForUpdate(
        @Param("tokenHash") String tokenHash
    );

    /**
     * [이메일인증] 해당 회원의 가장 최근 토큰 발급 시각을 조회합니다. (재발송 60초 쿨다운 체크용)
     */
    Optional<EmailVerificationToken> findTopByUserIdOrderByCreatedAtDesc(Long userId);

    /**
     * [이메일인증] 메일 재발송 시 이전에 발급된 미사용 토큰을 모두 폐기(usedAt 기록)합니다.
     */
    @Modifying(flushAutomatically = true)
    @Query("""
        update EmailVerificationToken t
        set t.usedAt = :now
        where t.userId = :userId
          and t.usedAt is null
        """)
    int invalidateUnusedByUserId(
        @Param("userId") Long userId,
        @Param("now") LocalDateTime now
    );
}
