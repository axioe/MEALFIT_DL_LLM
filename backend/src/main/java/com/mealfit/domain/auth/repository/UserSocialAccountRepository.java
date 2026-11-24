package com.mealfit.domain.auth.repository;

import com.mealfit.domain.auth.entity.SocialProvider;
import com.mealfit.domain.auth.entity.UserSocialAccount;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

/** 소셜 계정 연동 조회·연결·해제를 담당합니다. */
public interface UserSocialAccountRepository extends JpaRepository<UserSocialAccount, Long> {

    Optional<UserSocialAccount> findByProviderAndProviderUserId(
        SocialProvider provider,
        String providerUserId
    );

    Optional<UserSocialAccount> findByUserIdAndProvider(
        Long userId,
        SocialProvider provider
    );

    List<UserSocialAccount> findAllByUserIdOrderByIdAsc(Long userId);

    boolean existsByUserIdAndProvider(Long userId, SocialProvider provider);

    long countByUserId(Long userId);

    void deleteAllByUserId(Long userId);
}
