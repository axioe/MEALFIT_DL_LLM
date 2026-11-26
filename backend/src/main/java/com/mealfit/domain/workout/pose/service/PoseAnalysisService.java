package com.mealfit.domain.workout.pose.service;

import com.mealfit.domain.workout.pose.client.PoseAiClient;
import com.mealfit.domain.workout.pose.dto.PoseAnalysisRequest;
import com.mealfit.domain.workout.pose.dto.PoseAnalysisResponse;
import com.mealfit.domain.workout.pose.dto.PoseExerciseResponse;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.function.LongSupplier;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * 운동 자세 판별 (FR-WORK-05, TRD AI-05, SDD 5.9).
 * 기능 플래그(ai.pose.enabled, 기본 꺼짐) → 요청 검증 → 지원 운동 확인(AI 서비스 목록을 10분 동안 기억) → AI 서비스 판정 → 응답 검증.
 * 좌표는 저장하지 않고, 로그에는 운동·상태·반복 수·처리 시간·모델 버전만 남긴다 (NFR-SEC-05).
 */
@Slf4j
@Service
public class PoseAnalysisService {
    public static final int MIN_FPS = 5;
    public static final int MAX_FPS = 30;
    public static final int MAX_SECONDS = 60;
    public static final int MAX_FRAMES = 900;
    public static final int JOINTS = 33;
    public static final double MAX_COORD = 10.0;
    static final long EXERCISE_CACHE_NANOS = 10L * 60 * 1_000_000_000L;

    private final PoseAiClient client;
    private final boolean enabled;
    private final LongSupplier clock;
    private volatile CachedExercises cache;

    @Autowired
    public PoseAnalysisService(PoseAiClient client, @Value("${ai.pose.enabled:false}") boolean enabled) {
        this(client, enabled, System::nanoTime);
    }

    PoseAnalysisService(PoseAiClient client, boolean enabled, LongSupplier clock) {
        this.client = client;
        this.enabled = enabled;
        this.clock = clock;
    }

    /** 지원 운동 목록 (화면의 운동 선택용) */
    public PoseExerciseResponse exercises() {
        requireEnabled();
        return supported().response();
    }

    public PoseAnalysisResponse analyze(PoseAnalysisRequest request) {
        requireEnabled();
        validate(request);
        if (!supported().names().contains(request.exercise())) {
            throw new BusinessException(ErrorCode.WORKOUT_POSE_UNSUPPORTED_EXERCISE);
        }
        long started = System.nanoTime();
        PoseAnalysisResponse result = client.analyze(request);
        validateResponse(result, request.exercise());
        log.info("pose analyze exercise={} status={} reps={} ms={} model={}", request.exercise(), result.status(),
                result.repCount(), (System.nanoTime() - started) / 1_000_000, result.modelVersion());
        return result;
    }

    private void requireEnabled() {
        if (!enabled) throw new BusinessException(ErrorCode.WORKOUT_POSE_UNAVAILABLE);
    }

    // AI 서비스 목록을 10분 동안 기억한다. 모델을 바꿔도 Spring 은 고칠 필요가 없다
    private CachedExercises supported() {
        CachedExercises current = cache;
        long now = clock.getAsLong();
        if (current != null && now - current.fetchedAt() < EXERCISE_CACHE_NANOS) return current;
        synchronized (this) {
            current = cache;
            if (current != null && now - current.fetchedAt() < EXERCISE_CACHE_NANOS) return current;
            PoseExerciseResponse response = client.exercises();
            Set<String> names = new HashSet<>();
            if (response == null || response.exercises() == null || response.exercises().isEmpty()) {
                throw new BusinessException(ErrorCode.WORKOUT_POSE_BAD_RESPONSE);
            }
            for (PoseExerciseResponse.Exercise exercise : response.exercises()) {
                if (exercise == null || exercise.name() == null || exercise.name().isBlank()
                        || exercise.conditions() == null || exercise.conditions().isEmpty() || !names.add(exercise.name())) {
                    throw new BusinessException(ErrorCode.WORKOUT_POSE_BAD_RESPONSE);
                }
            }
            cache = new CachedExercises(response, Set.copyOf(names), now);
            return cache;
        }
    }

    // AI 서비스와 같은 기준으로 먼저 걸러서, 잘못된 요청은 AI 서비스로 보내지 않는다
    private void validate(PoseAnalysisRequest request) {
        if (request == null || request.exercise() == null || request.exercise().isBlank() || request.exercise().length() > 50
                || request.fps() == null || !Double.isFinite(request.fps())
                || request.fps() < MIN_FPS || request.fps() > MAX_FPS
                || request.frames() == null || request.frames().isEmpty() || request.frames().size() > MAX_FRAMES
                || request.frames().size() / request.fps() > MAX_SECONDS) {
            throw new BusinessException(ErrorCode.WORKOUT_POSE_INVALID_INPUT);
        }
        for (List<List<Double>> frame : request.frames()) {
            if (frame == null) continue;  // 사람을 못 찾은 프레임
            if (frame.size() != JOINTS) throw new BusinessException(ErrorCode.WORKOUT_POSE_INVALID_INPUT);
            for (List<Double> point : frame) {
                if (point == null || point.size() != 4) throw new BusinessException(ErrorCode.WORKOUT_POSE_INVALID_INPUT);
                for (int i = 0; i < 4; i++) {
                    Double v = point.get(i);
                    boolean ok = v != null && Double.isFinite(v)
                            && (i < 3 ? Math.abs(v) <= MAX_COORD : v >= 0 && v <= 1);
                    if (!ok) throw new BusinessException(ErrorCode.WORKOUT_POSE_INVALID_INPUT);
                }
            }
        }
    }

    // AI 결과를 검증 없이 사용자에게 보내지 않는다 (가이드라인 4장)
    private void validateResponse(PoseAnalysisResponse r, String exercise) {
        boolean ok = r != null && exercise.equals(r.exercise()) && r.modelVersion() != null && !r.modelVersion().isBlank()
                && r.reps() != null && r.conditions() != null && r.repCount() == r.reps().size();
        if (ok && "RETAKE".equals(r.status())) {
            ok = r.retakeCode() != null && r.repCount() == 0 && r.conditions().isEmpty();
        } else if (ok && "OK".equals(r.status())) {
            ok = r.repCount() > 0 && !r.conditions().isEmpty();
            for (int i = 0; ok && i < r.reps().size(); i++) {
                PoseAnalysisResponse.Rep rep = r.reps().get(i);
                ok = rep != null && rep.conditions() != null && rep.conditions().size() == r.conditions().size()
                        && rep.startFrame() >= 0 && rep.endFrame() >= rep.startFrame()
                        && rep.conditions().stream().allMatch(c -> c != null && c.name() != null
                        && Double.isFinite(c.probability()) && c.probability() >= 0 && c.probability() <= 1);
            }
            for (int i = 0; ok && i < r.conditions().size(); i++) {
                PoseAnalysisResponse.ConditionSummary c = r.conditions().get(i);
                ok = c != null && c.name() != null && c.feedback() != null && c.totalReps() == r.repCount()
                        && c.correctReps() >= 0 && c.correctReps() <= c.totalReps()
                        && (c.accuracy() == null || (c.accuracy() >= 0 && c.accuracy() <= 1));
            }
        } else {
            ok = false;
        }
        if (!ok) throw new BusinessException(ErrorCode.WORKOUT_POSE_BAD_RESPONSE);
    }

    private record CachedExercises(PoseExerciseResponse response, Set<String> names, long fetchedAt) { }
}
