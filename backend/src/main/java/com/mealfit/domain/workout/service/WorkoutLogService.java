package com.mealfit.domain.workout.service;

import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.domain.workout.dto.WorkoutLogRequest;
import com.mealfit.domain.workout.dto.WorkoutLogResponse;
import com.mealfit.domain.workout.dto.WorkoutWeeklySummaryResponse;
import com.mealfit.domain.workout.dto.WorkoutWeeklySummaryResponse.SessionSummaryItem;
import com.mealfit.domain.workout.entity.WorkoutLog;
import com.mealfit.domain.workout.entity.WorkoutLogStatus;
import com.mealfit.domain.workout.entity.WorkoutSession;
import com.mealfit.domain.workout.repository.WorkoutLogRepository;
import com.mealfit.domain.workout.repository.WorkoutSessionRepository;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 운동 완료 기록 및 주간 현황 집계 서비스 (FR-WORK-03·04, BR-18, DOM-05).
 * - 세션당 1건 유일, 같은 세션의 상태·시간·중량(kg) 정정 허용
 * - 미래 날짜 세션 기록 거절 (400 WORKOUT_006)
 * - 위험 신호 차단(startBlocked) 세션은 COMPLETED·PARTIAL 거절 (409 WORKOUT_007), SKIPPED만 허용
 */
// [운동기록]
@Service
@RequiredArgsConstructor
public class WorkoutLogService {

    static final ZoneId ZONE = ZoneId.of("Asia/Seoul");
    private static final int MAX_ACTUAL_MINUTES = 300;

    private final UserRepository userRepository;
    private final WorkoutSessionRepository sessionRepository;
    private final WorkoutLogRepository logRepository;

    @Transactional
    public WorkoutLogResponse record(Long userId, WorkoutLogRequest request) {
        userRepository.findByIdForUpdate(userId)
            .orElseThrow(() -> new BusinessException(ErrorCode.UNAUTHORIZED));

        WorkoutSession session = sessionRepository.findByIdAndUserId(request.sessionId(), userId)
            .orElseThrow(() -> new BusinessException(ErrorCode.WORKOUT_SESSION_NOT_FOUND));

        LocalDate today = LocalDate.now(ZONE);
        if (session.getSessionDate().isAfter(today)) {
            throw new BusinessException(ErrorCode.WORKOUT_LOG_FUTURE_DATE_NOT_ALLOWED);
        }

        if (session.isStartBlocked() && request.status() != WorkoutLogStatus.SKIPPED) {
            throw new BusinessException(ErrorCode.WORKOUT_LOG_BLOCKED_BY_EMERGENCY);
        }

        int actualMinutes = resolveActualMinutes(request.status(), request.actualMinutes(), session.getPlannedMinutes());
        BigDecimal weightKg = request.status() == WorkoutLogStatus.SKIPPED ? null : request.weightKg();
        LocalDateTime now = LocalDateTime.now(ZONE);

        Optional<WorkoutLog> existingOpt = logRepository.findByUserIdAndSessionId(userId, session.getId());
        if (existingOpt.isPresent()) {
            WorkoutLog existing = existingOpt.get();
            existing.update(request.status(), actualMinutes, weightKg, now);
            return WorkoutLogResponse.from(existing);
        }

        WorkoutLog created = WorkoutLog.create(userId, session, request.status(), actualMinutes, weightKg, now);
        logRepository.save(created);
        return WorkoutLogResponse.from(created);
    }

    @Transactional(readOnly = true)
    public List<WorkoutLogResponse> getLogs(Long userId, LocalDate from, LocalDate to) {
        LocalDate today = LocalDate.now(ZONE);
        LocalDate end = to != null ? to : today;
        LocalDate start = from != null ? from : end.minusDays(13);
        if (start.isAfter(end)) {
            throw new BusinessException(ErrorCode.WORKOUT_LOG_INVALID_INPUT,
                "조회 시작일은 종료일보다 늦을 수 없습니다.");
        }
        return logRepository.findByUserIdAndDateBetween(userId, start, end).stream()
            .map(WorkoutLogResponse::from)
            .toList();
    }

    /** 조회한 주(월~일)의 계획 세션 대비 완료·일부·건너뜀 및 실제 운동 시간을 집계한다 (FR-WORK-04). */
    @Transactional(readOnly = true)
    public WorkoutWeeklySummaryResponse getWeeklySummary(Long userId, LocalDate week) {
        LocalDate anchor = week != null ? week : LocalDate.now(ZONE);
        LocalDate monday = anchor.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate sunday = monday.plusDays(6);

        List<WorkoutSession> activeSessions = sessionRepository.findActiveBetween(userId, monday, sunday);
        List<WorkoutLog> logs = logRepository.findByUserIdAndDateBetween(userId, monday, sunday);

        Map<Long, WorkoutLog> logBySessionId = new LinkedHashMap<>();
        for (WorkoutLog log : logs) {
            logBySessionId.put(log.getSession().getId(), log);
        }

        // 활성 세션 + (루틴 재추천 전 기록이 남아 있는) 지난 세션 모두 포함해 기록 유실 방지
        Map<Long, WorkoutSession> sessionsById = new LinkedHashMap<>();
        for (WorkoutSession session : activeSessions) {
            sessionsById.put(session.getId(), session);
        }
        for (WorkoutLog log : logs) {
            sessionsById.putIfAbsent(log.getSession().getId(), log.getSession());
        }

        List<SessionSummaryItem> items = new ArrayList<>();
        int completed = 0;
        int partial = 0;
        int skipped = 0;
        int pending = 0;
        int totalPlannedMinutes = 0;
        int totalActualMinutes = 0;

        List<WorkoutSession> orderedSessions = sessionsById.values().stream()
            .sorted(Comparator.comparing(WorkoutSession::getSessionDate).thenComparing(WorkoutSession::getId))
            .toList();

        for (WorkoutSession session : orderedSessions) {
            WorkoutLog log = logBySessionId.get(session.getId());
            totalPlannedMinutes += session.getPlannedMinutes();
            if (log == null) {
                pending++;
                items.add(new SessionSummaryItem(
                    session.getId(), session.getSessionDate(), session.getFocusArea(), session.getTitle(),
                    session.getPlannedMinutes(), session.isAdjusted(), null, 0, null
                ));
            } else {
                totalActualMinutes += log.getActualMinutes();
                switch (log.getStatus()) {
                    case COMPLETED -> completed++;
                    case PARTIAL -> partial++;
                    case SKIPPED -> skipped++;
                }
                items.add(new SessionSummaryItem(
                    session.getId(), session.getSessionDate(), session.getFocusArea(), session.getTitle(),
                    session.getPlannedMinutes(), session.isAdjusted(),
                    log.getStatus(), log.getActualMinutes(), log.getWeightKg()
                ));
            }
        }

        int plannedSessions = orderedSessions.size();
        int completionRate = plannedSessions == 0 ? 0 : (int) Math.round(completed * 100.0 / plannedSessions);

        return new WorkoutWeeklySummaryResponse(
            monday, sunday, plannedSessions, completed, partial, skipped, pending,
            totalPlannedMinutes, totalActualMinutes, completionRate, items
        );
    }

    private static int resolveActualMinutes(WorkoutLogStatus status, Integer actualMinutes, int plannedMinutes) {
        if (status == WorkoutLogStatus.SKIPPED) {
            if (actualMinutes != null && actualMinutes != 0) {
                throw new BusinessException(ErrorCode.WORKOUT_LOG_INVALID_INPUT,
                    "건너뛴 운동의 실제 운동 시간은 0분이어야 합니다.");
            }
            return 0;
        }
        if (status == WorkoutLogStatus.COMPLETED && actualMinutes == null) {
            return Math.max(1, plannedMinutes);
        }
        if (actualMinutes == null || actualMinutes < 1 || actualMinutes > MAX_ACTUAL_MINUTES) {
            throw new BusinessException(ErrorCode.WORKOUT_LOG_INVALID_INPUT,
                "실제 운동 시간은 1분 이상 300분 이하로 입력해 주세요.");
        }
        return actualMinutes;
    }
}
