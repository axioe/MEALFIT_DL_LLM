package com.mealfit.domain.auth.dto;

import jakarta.validation.constraints.NotBlank;

/** [이메일인증] 메일 링크의 인증 토큰 검증 요청 DTO */
public record EmailVerifyConfirmRequest(
    @NotBlank(message = "인증 토큰이 필요합니다.")
    String token
) {}
