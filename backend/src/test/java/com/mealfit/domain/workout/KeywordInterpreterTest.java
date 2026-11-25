package com.mealfit.domain.workout;

import static org.assertj.core.api.Assertions.assertThat;

import com.mealfit.domain.workout.model.AdjustRiskLevel;
import com.mealfit.domain.workout.model.BodyArea;
import com.mealfit.domain.workout.model.IntensityIntent;
import com.mealfit.domain.workout.model.SessionAdjustment;
import com.mealfit.domain.workout.model.SessionFocus;
import com.mealfit.domain.workout.service.KeywordInterpreter;
import org.junit.jupiter.api.Test;

/** 문장 키워드 해석기 순수 단위 테스트 (FR-WORK-02, D18 ③-3). */
// [문장조정]
class KeywordInterpreterTest {

    private final KeywordInterpreter interpreter = new KeywordInterpreter();

    @Test
    void 위험신호는_다른_키워드보다_항상_최우선이다() {
        SessionAdjustment result = interpreter.interpret("가슴 통증이 있고 숨이 안 쉬어져, 15분만 가볍게 할래");
        assertThat(result.riskLevel()).isEqualTo(AdjustRiskLevel.EMERGENCY);
        assertThat(result.isEmergency()).isTrue();
        assertThat(result.summaryNote()).isEqualTo(SessionAdjustment.EMERGENCY_NOTE);
    }

    @Test
    void 질환_키워드는_상담안내로_분류한다() {
        SessionAdjustment result = interpreter.interpret("허리 디스크가 있어서 상체만 하고 싶어");
        assertThat(result.riskLevel()).isEqualTo(AdjustRiskLevel.MEDICAL);
        assertThat(result.isMedical()).isTrue();
        assertThat(result.summaryNote()).isEqualTo("질환:상담안내");
    }

    @Test
    void 시간_부위_강도_통증부위를_함께_해석하고_원문은_저장하지_않는다() {
        SessionAdjustment result = interpreter.interpret("오늘 무릎이 좀 아파서 상체 위주로 15분만 가볍게 할래요");
        assertThat(result.riskLevel()).isEqualTo(AdjustRiskLevel.PAIN);
        assertThat(result.sessionMinutes()).isEqualTo(15);
        assertThat(result.focus()).isEqualTo(SessionFocus.UPPER);
        assertThat(result.intensityIntent()).isEqualTo(IntensityIntent.LIGHTER);
        assertThat(result.excludedAreas()).containsExactly(BodyArea.KNEE);
        assertThat(result.summaryNote()).contains("시간:15분", "부위:상체", "강도:가볍게", "제외:무릎");
        assertThat(result.summaryNote()).doesNotContain("할래요");
    }

    @Test
    void 시간_숫자는_허용값으로_내림하고_짧게는_15분으로_해석한다() {
        assertThat(interpreter.interpret("오늘은 15분만 가능해").sessionMinutes()).isEqualTo(15);
        assertThat(interpreter.interpret("40분 정도 운동할래").sessionMinutes()).isEqualTo(30);
        assertThat(interpreter.interpret("1시간 빡세게").sessionMinutes()).isEqualTo(60);
        assertThat(interpreter.interpret("시간 없어서 짧게만").sessionMinutes()).isEqualTo(15);
    }

    @Test
    void 컨디션_저하_표현을_감지한다() {
        SessionAdjustment result = interpreter.interpret("잠 못 자서 피곤한데 상체 강하게 할래");
        assertThat(result.poorCondition()).isTrue();
        assertThat(result.focus()).isEqualTo(SessionFocus.UPPER);
        assertThat(result.intensityIntent()).isEqualTo(IntensityIntent.HARDER);
    }

    @Test
    void 해석할_키워드가_없으면_변경없음으로_반환한다() {
        SessionAdjustment result = interpreter.interpret("안녕하세요 오늘 날씨 좋네요");
        assertThat(result.riskLevel()).isEqualTo(AdjustRiskLevel.NONE);
        assertThat(result.hasActionableChange()).isFalse();
    }

    @Test
    void 손목과_발목은_목으로_오탐되지_않고_목은_정확히_매칭된다() {
        SessionAdjustment wrist = interpreter.interpret("손목이 아파서 가볍게 할래");
        assertThat(wrist.excludedAreas()).containsExactly(BodyArea.WRIST);

        SessionAdjustment ankle = interpreter.interpret("발목이 삐었어");
        assertThat(ankle.excludedAreas()).containsExactly(BodyArea.ANKLE);

        SessionAdjustment both = interpreter.interpret("손목이랑 목이 같이 결려");
        assertThat(both.excludedAreas()).containsExactlyInAnyOrder(BodyArea.WRIST, BodyArea.NECK);
    }

    @Test
    void 십오분_미만_요청은_15분으로_늘리지_않고_최소시간_미만으로_표시한다() {
        SessionAdjustment fiveMin = interpreter.interpret("오늘은 5분만 가능해");
        assertThat(fiveMin.sessionMinutes()).isNull();
        assertThat(fiveMin.underMinMinutes()).isTrue();
    }
}
