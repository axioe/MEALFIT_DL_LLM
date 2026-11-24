package com.mealfit.domain.inventory.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "사진 인식 후보이며 사용자 확인 전에는 재고에 반영하지 않음")
public record IngredientRecognitionResponse(
        @Schema(example = "efficientnet-b0-stage3-epoch19") String modelVersion,
        List<Candidate> candidates,
        @JsonInclude(JsonInclude.Include.NON_NULL) OcrResult ocr
) {
    // 기존 Top-3 응답 생성 방식도 유지함.
    public IngredientRecognitionResponse(String modelVersion, List<Candidate> candidates) {
        this(modelVersion, candidates, null);
    }

    @Schema(description = "상품 라벨의 문자 인식 후보이며 모델 확률과 합산하지 않음")
    public record OcrResult(OcrStatus status, List<OcrCandidate> candidates, long elapsedMs) { }

    public record OcrCandidate(
            String ingredientName,
            @Schema(description = "OCR 문자 신뢰도이며 식재료 정답 확률이 아님") Double textConfidence
    ) { }

    public enum OcrStatus { SUCCESS, NO_TEXT, NO_MATCH, TIMEOUT, UNAVAILABLE, ERROR }

    public record Candidate(
            @Schema(example = "tomato", description = "모델의 영어 클래스명이며 표준 재료명이 아님") String className,
            @Schema(example = "0.98", description = "0~1 모델 확률이며 보정된 신뢰도를 의미하지 않음") Double confidence,
            @Schema(description = "표준 식재료 사전 미연결 상태") MappingStatus mappingStatus
    ) {
    }

    public enum MappingStatus { UNMAPPED }
}
