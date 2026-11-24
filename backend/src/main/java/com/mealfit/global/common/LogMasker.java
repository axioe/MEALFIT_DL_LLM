package com.mealfit.global.common;

import java.util.regex.Pattern;

/** 로그에 남기면 안 되는 토큰·비밀번호·이메일을 가린다. */
public final class LogMasker {

    private static final String HIDDEN = "***";

    private static final Pattern BEARER = Pattern.compile("(?i)\\b(Bearer\\s+)[A-Za-z0-9._~+/=-]+");
    private static final Pattern JWT = Pattern.compile("\\beyJ[A-Za-z0-9_-]+\\.[A-Za-z0-9_-]+\\.[A-Za-z0-9_-]+");
    /** 주소의 인증 값: 이메일 인증 token, 소셜 로그인 code·state */
    private static final Pattern QUERY = Pattern.compile("(?i)([?&](?:token|code|state)=)[^&\\s\"']+");
    /** 이름이 붙은 비밀값: refresh_token=..., "accessToken":"...", password=... */
    private static final Pattern NAMED = Pattern.compile(
            "(?i)(\\b(?:refresh_?token|access_?token|client_?secret|password)\"?\\s*[=:]\\s*\"?)[^\\s,;&\"'}\\])]+");
    private static final Pattern EMAIL = Pattern.compile(
            "([A-Za-z0-9])[A-Za-z0-9._%+-]*@([A-Za-z0-9-]+(?:\\.[A-Za-z0-9-]+)*\\.[A-Za-z]{2,})");

    private LogMasker() {
    }

    public static String mask(String text) {
        if (text == null || text.isEmpty()) {
            return text;
        }
        String result = BEARER.matcher(text).replaceAll("$1" + HIDDEN);
        result = JWT.matcher(result).replaceAll(HIDDEN);
        result = QUERY.matcher(result).replaceAll("$1" + HIDDEN);
        result = NAMED.matcher(result).replaceAll("$1" + HIDDEN);
        return maskEmail(result);
    }

    /** user@example.com → u***@example.com */
    public static String maskEmail(String text) {
        return text == null ? null : EMAIL.matcher(text).replaceAll("$1" + HIDDEN + "@$2");
    }
}
