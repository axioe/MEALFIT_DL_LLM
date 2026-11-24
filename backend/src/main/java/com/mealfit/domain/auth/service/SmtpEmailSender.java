package com.mealfit.domain.auth.service;

import com.mealfit.global.common.LogMasker;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import java.io.UnsupportedEncodingException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

/**
 * [이메일인증][SMTP] 실제 이메일(Gmail/네이버/SES 등 SMTP)로 인증 링크를 발송하는 구현체입니다.
 * .env에 MAIL_PROVIDER=smtp 및 SMTP 계정 정보를 설정하면 자동으로 활성화됩니다.
 */
@Slf4j
@Component
@RequiredArgsConstructor
@ConditionalOnProperty(name = "mealfit.auth.mail-provider", havingValue = "smtp")
public class SmtpEmailSender implements EmailSender {

    private final JavaMailSender mailSender;

    @Value("${mealfit.auth.mail-from:}")
    private String mailFrom;

    @Value("${mealfit.auth.mail-from-name:MealFit}")
    private String mailFromName;

    @Override
    public void sendVerificationEmail(String toEmail, String verificationUrl) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");
            if (mailFrom != null && !mailFrom.isBlank()) {
                String personal = (mailFromName == null || mailFromName.isBlank())
                    ? "MealFit"
                    : mailFromName.trim();
                helper.setFrom(mailFrom.trim(), personal);
            }
            helper.setTo(toEmail);
            helper.setSubject("[MealFit] 이메일 인증을 완료해 주세요");
            helper.setText(buildHtmlBody(verificationUrl), true);
            mailSender.send(message);
            log.info("[이메일인증][SMTP] 인증 메일 발송 완료: to={}", LogMasker.maskEmail(toEmail));
        } catch (MessagingException | UnsupportedEncodingException ex) {
            log.error("[이메일인증][SMTP] 인증 메일 구성 실패: to={}", LogMasker.maskEmail(toEmail), ex);
            throw new IllegalStateException("이메일 인증 메일을 발송하지 못했습니다.", ex);
        }
    }

    private String buildHtmlBody(String verificationUrl) {
        return """
            <div style="font-family: 'Malgun Gothic', sans-serif; max-width: 520px; margin: 0 auto; padding: 24px; border: 1px solid #e5e7eb; border-radius: 16px;">
              <h2 style="color: #059669; margin: 0 0 12px;">MealFit 이메일 인증</h2>
              <p style="color: #374151; font-size: 14px; line-height: 1.6;">
                MealFit 회원가입을 환영합니다.<br/>
                아래 버튼을 눌러 이메일 인증을 완료한 뒤 로그인해 주세요. (유효시간 30분)
              </p>
              <div style="margin: 24px 0; text-align: center;">
                <a href="%s"
                   style="display: inline-block; background: #059669; color: #ffffff; text-decoration: none; font-weight: bold; padding: 12px 24px; border-radius: 10px; font-size: 14px;">
                  이메일 인증 완료하기
                </a>
              </div>
              <p style="color: #6b7280; font-size: 12px; word-break: break-all;">
                버튼이 동작하지 않으면 아래 링크를 브라우저에 복사해 열어주세요.<br/>
                %s
              </p>
            </div>
            """.formatted(verificationUrl, verificationUrl);
    }
}
