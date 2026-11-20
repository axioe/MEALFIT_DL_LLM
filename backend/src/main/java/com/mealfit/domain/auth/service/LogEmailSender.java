package com.mealfit.domain.auth.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

/**
 * [이메일인증] 로컬 개발/테스트용 메일 발송기입니다.
 * mealfit.auth.mail-provider=log(기본값)일 때 활성화되어 콘솔 로그에 인증 링크를 출력합니다.
 */
@Slf4j
@Component
@ConditionalOnProperty(
    name = "mealfit.auth.mail-provider",
    havingValue = "log",
    matchIfMissing = true
)
public class LogEmailSender implements EmailSender {

    @Override
    public void sendVerificationEmail(String toEmail, String verificationUrl) {
        log.info("[이메일인증] 발송 대상={}, 인증링크={}", toEmail, verificationUrl);
    }
}
