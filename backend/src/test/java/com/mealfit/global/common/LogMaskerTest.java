package com.mealfit.global.common;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

class LogMaskerTest {

    @Test
    void 토큰과_비밀번호를_가린다() {
        assertThat(LogMasker.mask("Authorization: Bearer abc.def-123")).isEqualTo("Authorization: Bearer ***");
        assertThat(LogMasker.mask("jwt eyJhbGci.eyJzdWIi.sig_n-ature end")).isEqualTo("jwt *** end");
        assertThat(LogMasker.mask("refresh_token=abc123; Path=/")).isEqualTo("refresh_token=***; Path=/");
        assertThat(LogMasker.mask("{\"accessToken\":\"abc\",\"x\":1}")).isEqualTo("{\"accessToken\":\"***\",\"x\":1}");
        assertThat(LogMasker.mask("LoginRequest[password=p1ss!]")).isEqualTo("LoginRequest[password=***]");
    }

    @Test
    void 주소의_인증값을_가린다() {
        assertThat(LogMasker.mask("/verify-email?token=abc123")).isEqualTo("/verify-email?token=***");
        assertThat(LogMasker.mask("/login/oauth2/code/kakao?code=a1&state=b2"))
                .isEqualTo("/login/oauth2/code/kakao?code=***&state=***");
    }

    @Test
    void 이메일은_첫_글자와_도메인만_남긴다() {
        assertThat(LogMasker.mask("Key (email)=(user.name@example.co.kr) already exists"))
                .isEqualTo("Key (email)=(u***@example.co.kr) already exists");
        assertThat(LogMasker.maskEmail(null)).isNull();
    }

    @Test
    void 일반_로그는_그대로_둔다() {
        String text = "code=AUTH_001 status=409 com.mealfit.Foo@1a2b3c 재고 state=ACTIVE";
        assertThat(LogMasker.mask(text)).isEqualTo(text);
    }
}
