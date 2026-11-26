package com.mealfit.domain.intake.service;

import com.mealfit.domain.intake.dto.IntakeLogRequest;
import com.mealfit.domain.intake.dto.IntakeLogResponse;
import com.mealfit.domain.intake.entity.IntakeLog;
import com.mealfit.domain.intake.entity.IntakeStatus;
import com.mealfit.domain.intake.repository.IntakeLogRepository;
import com.mealfit.domain.mealplan.entity.MealPlan;
import com.mealfit.domain.mealplan.entity.MealPlanStatus;
import com.mealfit.domain.mealplan.repository.MealPlanRepository;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 식단 섭취 기록(먹음·건너뜀) 저장·정정·조회 서비스 (FR-INT-01·02, BR-11).
 * - 확정(CONFIRMED) 식단만 기록 가능, 미래 날짜 식단은 거절
 * - EATEN ↔ SKIPPED 정정 허용, PLANNED 복귀 금지, 동일 상태 재요청은 멱등 반환
 * - 재고 수량은 변경하지 않는다 (재고 차감/복원은 조리 도메인 전담)
 */
// [섭취기록]
@Service
@RequiredArgsConstructor
public class IntakeLogService {

    static final ZoneId ZONE = ZoneId.of("Asia/Seoul");

    private final IntakeLogRepository intakeLogRepository;
    private final MealPlanRepository mealPlanRepository;

    @Transactional
    public IntakeLogResponse record(Long userId, IntakeLogRequest request) {
        IntakeStatus targetStatus = request.intakeStatus();
        if (targetStatus != IntakeStatus.EATEN && targetStatus != IntakeStatus.SKIPPED) {
            throw new BusinessException(ErrorCode.INTAKE_INVALID_STATUS);
        }

        // [섭취기록] 본인 소유 식단을 비관적 잠금으로 조회해 동시 중복 기록을 방지한다
        MealPlan mealPlan = mealPlanRepository.findForUpdate(request.mealPlanId(), userId)
            .orElseThrow(() -> new BusinessException(ErrorCode.MEAL_PLAN_NOT_FOUND));

        if (mealPlan.getStatus() != MealPlanStatus.CONFIRMED) {
            throw new BusinessException(ErrorCode.INTAKE_MEAL_PLAN_NOT_CONFIRMED);
        }

        LocalDate today = LocalDate.now(ZONE);
        if (mealPlan.getPlanDate().isAfter(today)) {
            throw new BusinessException(ErrorCode.INTAKE_FUTURE_DATE_NOT_ALLOWED);
        }

        Optional<IntakeLog> existingOpt = intakeLogRepository.findByMealPlanIdAndUserId(mealPlan.getId(), userId);
        if (existingOpt.isPresent()) {
            IntakeLog existing = existingOpt.get();
            if (existing.getIntakeStatus() == targetStatus) {
                return IntakeLogResponse.from(existing);
            }
            existing.record(targetStatus);
            return IntakeLogResponse.from(existing);
        }

        IntakeLog created = IntakeLog.planned(userId, mealPlan);
        created.record(targetStatus);
        intakeLogRepository.save(created);
        return IntakeLogResponse.from(created);
    }

    @Transactional(readOnly = true)
    public List<IntakeLogResponse> getByDate(Long userId, LocalDate date) {
        LocalDate targetDate = date != null ? date : LocalDate.now(ZONE);
        return intakeLogRepository.findByUserIdAndPlanDate(userId, targetDate).stream()
            .map(IntakeLogResponse::from)
            .toList();
    }
}
