package com.mealfit.domain.user.service;

import com.mealfit.domain.auth.repository.UserSocialAccountRepository;
import com.mealfit.domain.user.dto.WithdrawRequest;
import com.mealfit.domain.user.entity.User;
import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.domain.user.repository.WithdrawalDataRepository;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.nio.charset.StandardCharsets;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/** 비밀번호 확인과 회원 데이터 삭제를 하나의 트랜잭션으로 처리합니다. */
@Service
@RequiredArgsConstructor
public class WithdrawalService {
    private static final int BCRYPT_MAX_BYTES = 72;
    private final UserRepository userRepository;
    private final WithdrawalDataRepository withdrawalDataRepository;
    private final WithdrawalReauthentication reauthentication;
    private final UserSocialAccountRepository socialAccounts;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public void withdraw(Long userId, WithdrawRequest request) {
        // 로그인·재발급과 같은 회원 → 토큰 잠금 순서로 동시 요청을 처리합니다.
        User user = lockActiveUser(userId);

        // 비밀번호 앞뒤 공백도 비밀번호의 일부이므로 trim하지 않습니다.
        // BCrypt가 처리할 수 없는 바이트 길이는 비교 전에 거절합니다.
        // [소셜로그인] 비밀번호가 없는 소셜 전용 계정도 null 안전하게 검사합니다.
        if (!user.hasPassword()
                || request.password().getBytes(StandardCharsets.UTF_8).length > BCRYPT_MAX_BYTES
                || !passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw new BusinessException(ErrorCode.USER_PASSWORD_MISMATCH);
        }

        deleteUser(user);
    }

    @Transactional
    public void withdrawSocial(Long userId, String token) {
        var link = reauthentication.consume(token, userId);
        User user = lockActiveUser(userId);
        boolean sameAccount = socialAccounts.findByUserIdAndProvider(userId, link.provider())
            .filter(account -> account.getId().equals(link.accountId())
                && account.getProviderUserId().equals(link.providerUserId()))
            .isPresent();
        if (user.hasPassword() || !sameAccount) {
            throw new BusinessException(ErrorCode.USER_WITHDRAWAL_REAUTH_REQUIRED);
        }
        deleteUser(user);
    }

    private User lockActiveUser(Long userId) {
        return userRepository.findByIdForUpdate(userId)
            .filter(user -> user.getDeletedAt() == null)
            .orElseThrow(() -> new BusinessException(ErrorCode.UNAUTHORIZED));
    }

    private void deleteUser(User user) {
        withdrawalDataRepository.deleteByUserId(user.getId());
        userRepository.delete(user);
    }
}
