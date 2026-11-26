package com.mealfit.domain.user.service;

import com.mealfit.domain.auth.entity.SocialProvider;
import com.mealfit.domain.auth.model.OAuth2UserInfo;
import com.mealfit.domain.auth.repository.UserSocialAccountRepository;
import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/** 단일 백엔드 프로세스에서 탈퇴용 소셜 인증 요청과 1회용 확인 권한을 관리합니다. */
@Service
public class WithdrawalReauthentication {
    public static final Duration TTL = Duration.ofMinutes(5);
    private static final int MAX_PENDING = 4096;

    private final UserRepository users;
    private final UserSocialAccountRepository accounts;
    private final Clock clock;
    private final Map<String, Attempt> attempts = new HashMap<>();

    @Autowired
    public WithdrawalReauthentication(UserRepository users, UserSocialAccountRepository accounts) {
        this(users, accounts, Clock.systemUTC());
    }

    WithdrawalReauthentication(UserRepository users, UserSocialAccountRepository accounts, Clock clock) {
        this.users = users;
        this.accounts = accounts;
        this.clock = clock;
    }

    public record Link(Long userId, SocialProvider provider, Long accountId, String providerUserId) {}
    private record Attempt(Link link, Instant expiresAt, boolean verified) {}

    public String start(Long userId, SocialProvider provider, String previousToken) {
        boolean socialOnly = users.findById(userId)
            .filter(user -> user.getDeletedAt() == null && !user.hasPassword())
            .isPresent();
        if (!socialOnly) {
            throw new BusinessException(ErrorCode.USER_WITHDRAWAL_REAUTH_REQUIRED);
        }
        var account = accounts.findByUserIdAndProvider(userId, provider)
            .orElseThrow(() -> new BusinessException(ErrorCode.USER_WITHDRAWAL_REAUTH_REQUIRED));
        synchronized (attempts) {
            removeForUser(previousToken, userId);
            if (attempts.size() >= MAX_PENDING) {
                throw new BusinessException(ErrorCode.USER_WITHDRAWAL_REAUTH_BUSY);
            }
            return issue(new Link(userId, provider, account.getId(), account.getProviderUserId()), false);
        }
    }

    public Optional<SocialProvider> pendingProvider(String token) {
        synchronized (attempts) {
            return find(token, false).map(attempt -> attempt.link().provider());
        }
    }

    public Optional<String> verify(String token, OAuth2UserInfo info) {
        synchronized (attempts) {
            Optional<Attempt> pending = find(token, false);
            if (pending.isEmpty()) {
                return Optional.empty();
            }
            attempts.remove(token);
            Link link = pending.get().link();
            if (link.provider() != info.provider() || !link.providerUserId().equals(info.providerUserId())) {
                return Optional.empty();
            }
            return Optional.of(issue(link, true));
        }
    }

    public long remainingMillis(String token, Long userId) {
        synchronized (attempts) {
            return find(token, true).filter(attempt -> attempt.link().userId().equals(userId))
                .map(attempt -> Math.max(0, Duration.between(clock.instant(), attempt.expiresAt()).toMillis()))
                .orElse(0L);
        }
    }

    public Link consume(String token, Long userId) {
        synchronized (attempts) {
            Attempt attempt = find(token, true).filter(item -> item.link().userId().equals(userId))
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_WITHDRAWAL_REAUTH_REQUIRED));
            attempts.remove(token);
            return attempt.link();
        }
    }

    public void cancel(String token, Long userId) {
        synchronized (attempts) {
            removeForUser(token, userId);
        }
    }

    public void cancelPending(String token) {
        synchronized (attempts) {
            find(token, false).ifPresent(ignored -> attempts.remove(token));
        }
    }

    public void forgetUser(Long userId) {
        synchronized (attempts) {
            attempts.values().removeIf(attempt -> attempt.link().userId().equals(userId));
        }
    }

    private void removeForUser(String token, Long userId) {
        if (token != null) {
            attempts.computeIfPresent(token, (key, attempt) ->
                attempt.link().userId().equals(userId) ? null : attempt);
        }
        Instant now = clock.instant();
        attempts.values().removeIf(attempt -> !attempt.expiresAt().isAfter(now));
    }

    private Optional<Attempt> find(String token, boolean verified) {
        Attempt attempt = attempts.get(token);
        if (attempt == null || attempt.verified() != verified) {
            return Optional.empty();
        }
        if (!attempt.expiresAt().isAfter(clock.instant())) {
            attempts.remove(token);
            return Optional.empty();
        }
        return Optional.of(attempt);
    }

    private String issue(Link link, boolean verified) {
        String token = UUID.randomUUID().toString();
        attempts.put(token, new Attempt(link, clock.instant().plus(TTL), verified));
        return token;
    }
}
