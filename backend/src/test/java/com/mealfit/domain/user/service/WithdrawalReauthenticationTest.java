package com.mealfit.domain.user.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.*;

import com.mealfit.domain.auth.entity.SocialProvider;
import com.mealfit.domain.auth.entity.UserSocialAccount;
import com.mealfit.domain.auth.model.OAuth2UserInfo;
import com.mealfit.domain.auth.repository.UserSocialAccountRepository;
import com.mealfit.domain.user.entity.User;
import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.global.exception.BusinessException;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.Optional;
import org.junit.jupiter.api.Test;

class WithdrawalReauthenticationTest {
    @Test
    void 확인권한은_소셜인증_성공시점부터_5분이며_한번만_사용된다() {
        Long userId = 7L;
        var provider = SocialProvider.NAVER;
        var users = mock(UserRepository.class);
        var accounts = mock(UserSocialAccountRepository.class);
        var socialAccount = mock(UserSocialAccount.class);
        when(socialAccount.getId()).thenReturn(10L);
        when(socialAccount.getProviderUserId()).thenReturn("linked-account");
        when(users.findById(userId)).thenReturn(Optional.of(mock(User.class)));
        when(accounts.findByUserIdAndProvider(userId, provider)).thenReturn(Optional.of(socialAccount));
        var profile = new OAuth2UserInfo(provider, "linked-account", null, "테스트");
        Instant start = Instant.parse("2026-11-26T01:00:00Z");
        var clock = mock(Clock.class);
        when(clock.instant()).thenReturn(start);
        var service = new WithdrawalReauthentication(users, accounts, clock);

        String initial = service.start(userId, provider, null);
        Instant verified = start.plus(Duration.ofMinutes(4));
        when(clock.instant()).thenReturn(verified);
        String proof = service.verify(initial, profile).orElseThrow();
        assertThat(service.remainingMillis(proof, userId)).isEqualTo(300_000);
        assertThat(service.verify(initial, profile)).isEmpty();

        when(clock.instant()).thenReturn(verified.plus(Duration.ofMinutes(5)).minusMillis(1));
        assertThat(service.remainingMillis(proof, userId)).isOne();
        assertThat(service.consume(proof, userId).accountId()).isEqualTo(10L);
        assertThatThrownBy(() -> service.consume(proof, userId)).isInstanceOf(BusinessException.class);

        String another = service.start(userId, provider, null);
        String expired = service.verify(another, profile).orElseThrow();
        when(clock.instant()).thenReturn(verified.plus(Duration.ofMinutes(10)));
        assertThat(service.remainingMillis(expired, userId)).isZero();
        assertThatThrownBy(() -> service.consume(expired, userId)).isInstanceOf(BusinessException.class);
    }
}
