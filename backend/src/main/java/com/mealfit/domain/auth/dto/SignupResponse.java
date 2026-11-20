package com.mealfit.domain.auth.dto;

/** [이메일인증] 회원가입 성공 응답 DTO (이메일 인증 전이므로 토큰은 발급하지 않음) */
public record SignupResponse(
    String email,
    String message
) {}
