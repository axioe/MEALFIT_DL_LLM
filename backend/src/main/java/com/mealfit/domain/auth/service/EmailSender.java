package com.mealfit.domain.auth.service;

/**
 * [이메일인증] 인증 메일 발송 인터페이스입니다.
 * 로컬 개발에서는 LogEmailSender(콘솔 출력)를 쓰고, 운영에서는 SMTP 구현체로 교체합니다.
 */
public interface EmailSender {
    void sendVerificationEmail(String toEmail, String verificationUrl);
}
