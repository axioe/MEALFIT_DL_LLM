package com.mealfit.domain.mealplan.service;

import com.mealfit.domain.mealplan.client.MealPlanAiClient;
import com.mealfit.domain.mealplan.dto.AiMealSuggestion;
import com.mealfit.domain.mealplan.dto.MealPlanRecommendRequest;
import com.mealfit.domain.mealplan.dto.MealPlanRecommendResponse;
import com.mealfit.domain.mealplan.dto.MealPlanResponse;
import com.mealfit.domain.mealplan.entity.MealType;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Service;

/**
 * 식단 추천·한 끼 재추천의 순서를 잡는다: 준비(짧은 읽기) → AI 호출 → 저장(짧은 쓰기·잠금).
 *
 * <p>이 클래스에는 일부러 트랜잭션을 걸지 않는다. AI 응답은 최대 20초까지 걸리므로, 그동안 회원 행 잠금이나
 * DB 연결을 붙잡으면 같은 회원의 로그인·토큰 재발급이 멈추고 연결 풀이 바닥난다 (TRD AI-01:
 * "외부 요청은 DB 쓰기 트랜잭션과 재고 잠금 밖에서 실행한다").
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class MealPlanRecommender {

    private final MealPlanService mealPlanService;
    private final ObjectProvider<MealPlanAiClient> aiClientProvider;

    /** 하루 세 끼 추천 (FR-MEAL-01·03) */
    public MealPlanRecommendResponse recommend(Long userId, MealPlanRecommendRequest request) {
        MealPlanService.AiPreparation preparation = mealPlanService.prepareRecommend(userId, request);
        return mealPlanService.saveRecommendation(userId, request, requestAi(preparation));
    }

    /** 한 끼 재추천 (FR-MEAL-04) */
    public MealPlanResponse regenerate(Long userId, Long mealPlanId) {
        MealPlanService.AiPreparation preparation = mealPlanService.prepareRegenerate(userId, mealPlanId);
        return mealPlanService.saveRegeneration(userId, mealPlanId, requestAi(preparation));
    }

    /** AI 제안 중 요청한 끼니이고 서버 검증을 통과한 것만 남긴다. 실패하면 빈 결과(전부 로컬 대체). */
    private Map<MealType, AiMealSuggestion> requestAi(MealPlanService.AiPreparation preparation) {
        MealPlanAiClient aiClient = aiClientProvider.getIfAvailable();
        if (aiClient == null) {
            return Map.of();
        }
        List<AiMealSuggestion> suggestions;
        try {
            suggestions = aiClient.recommend(preparation.request());
        } catch (RuntimeException e) {
            log.warn("AI 식단 추천 실패, 로컬 대체로 전환합니다: {}", e.getMessage());
            return Map.of();
        }
        Map<MealType, AiMealSuggestion> valid = new EnumMap<>(MealType.class);
        for (AiMealSuggestion suggestion : suggestions == null ? List.<AiMealSuggestion>of() : suggestions) {
            if (suggestion == null || !preparation.request().mealTypes().contains(suggestion.mealType())
                    || valid.containsKey(suggestion.mealType())) {
                continue;
            }
            Optional<String> problem = AiSuggestionValidator.validate(suggestion, preparation.restricted());
            if (problem.isPresent()) {
                log.warn("AI 제안을 버리고 로컬 대체로 전환합니다 ({}): {}", suggestion.mealType(), problem.get());
                continue;
            }
            valid.put(suggestion.mealType(), suggestion);
        }
        return valid;
    }
}
