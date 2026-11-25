package com.mealfit.domain.workout.pose.client;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.domain.workout.pose.dto.PoseAnalysisRequest;
import com.mealfit.domain.workout.pose.dto.PoseAnalysisResponse;
import com.mealfit.domain.workout.pose.dto.PoseExerciseResponse;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.net.SocketTimeoutException;
import java.net.http.HttpTimeoutException;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestClientResponseException;

/**
 * AI 서비스 자세 판별 호출 (GET /ai/pose/exercises, POST /ai/pose/analyze). 연결 3초·읽기 20초(aiRestClient).
 * AI 서비스의 오류 내용은 그대로 노출하지 않고 WORKOUT_POSE_00x 로 바꾼다.
 */
@Component
public class PoseAiClient {
    private final RestClient ai;
    private final ObjectMapper mapper = new ObjectMapper();

    public PoseAiClient(@Qualifier("aiRestClient") RestClient ai) {
        this.ai = ai;
    }

    /** 지원 운동 목록 (모델 manifest 기준) */
    public PoseExerciseResponse exercises() {
        return call(() -> ai.get().uri("/ai/pose/exercises").retrieve().body(PoseExerciseResponse.class));
    }

    /** 관절 좌표 판정. 사용자 식별 정보는 보내지 않는다 (요청 본문 그대로) */
    public PoseAnalysisResponse analyze(PoseAnalysisRequest request) {
        return call(() -> ai.post().uri("/ai/pose/analyze").contentType(MediaType.APPLICATION_JSON)
                .body(request).retrieve().body(PoseAnalysisResponse.class));
    }

    private <T> T call(java.util.function.Supplier<T> request) {
        try {
            return request.get();
        } catch (RestClientResponseException error) {
            throw upstreamError(error);
        } catch (ResourceAccessException error) {
            for (Throwable cause = error; cause != null; cause = cause.getCause()) {
                if (cause instanceof SocketTimeoutException || cause instanceof HttpTimeoutException) {
                    throw new BusinessException(ErrorCode.WORKOUT_POSE_TIMEOUT);
                }
            }
            throw new BusinessException(ErrorCode.WORKOUT_POSE_UNAVAILABLE);
        } catch (RestClientException error) {
            throw new BusinessException(ErrorCode.WORKOUT_POSE_BAD_RESPONSE);
        }
    }

    // AI 서비스 오류 코드(POSE_001~004)·상태를 공통 오류 코드로 바꾼다
    private BusinessException upstreamError(RestClientResponseException error) {
        String code = "";
        try {
            code = mapper.readTree(error.getResponseBodyAsByteArray()).path("code").asText("");
        } catch (Exception ignored) {
            // 본문이 JSON 이 아니면 상태 코드로만 판단한다
        }
        int status = error.getStatusCode().value();
        if (status == 400 && "POSE_002".equals(code)) return new BusinessException(ErrorCode.WORKOUT_POSE_UNSUPPORTED_EXERCISE);
        return new BusinessException(switch (status) {
            case 400, 413, 415 -> ErrorCode.WORKOUT_POSE_INVALID_INPUT;
            case 503 -> ErrorCode.WORKOUT_POSE_UNAVAILABLE;
            case 504 -> ErrorCode.WORKOUT_POSE_TIMEOUT;
            default -> ErrorCode.WORKOUT_POSE_BAD_RESPONSE;
        });
    }
}
