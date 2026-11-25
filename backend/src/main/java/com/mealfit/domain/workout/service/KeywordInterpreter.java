package com.mealfit.domain.workout.service;

import com.mealfit.domain.workout.model.AdjustRiskLevel;
import com.mealfit.domain.workout.model.BodyArea;
import com.mealfit.domain.workout.model.IntensityIntent;
import com.mealfit.domain.workout.model.SessionAdjustment;
import com.mealfit.domain.workout.model.SessionFocus;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.springframework.stereotype.Component;

/**
 * 사용자 자연어 문장을 규칙 기반 키워드 사전으로 해석한다 (FR-WORK-02, D18 ③-3).
 * DB·시계·외부 AI에 의존하지 않는 순수 클래스다.
 * 우선순위: 위험 신호(EMERGENCY) > 질환·상태(MEDICAL) > 일반 통증·컨디션·시간·부위·강도.
 */
// [문장조정]
@Component
public class KeywordInterpreter {

    private static final Pattern MINUTES_PATTERN = Pattern.compile("(\\d{1,3})\\s*분");
    private static final Pattern HOURS_PATTERN = Pattern.compile("(\\d)\\s*시간");

    /** 위험 신호 키워드 (D18 ③-3, 최우선). */
    private static final List<String> EMERGENCY_KEYWORDS = List.of(
        "가슴 통증", "가슴통증", "흉통", "가슴이 답답", "가슴 답답", "가슴이 아", "가슴 아",
        "숨이 안 쉬", "숨이 너무 차", "심한 호흡곤란", "호흡곤란", "호흡 곤란",
        "어지러", "어지럼", "실신", "쓰러질", "식은땀", "현기증"
    );

    /** 질환·의료 상태 키워드 (D18 ③-3, 위험 신호 다음 우선). */
    private static final List<String> MEDICAL_KEYWORDS = List.of(
        "디스크", "수술", "골절", "임신", "고혈압", "당뇨", "심장", "협심증", "관절염", "파열"
    );

    /** 일반 통증 키워드 (D18 ③-3). */
    private static final List<String> PAIN_KEYWORDS = List.of(
        "아파", "아픔", "아프", "통증", "쑤셔", "쑤시", "결려", "결림", "삐었", "다쳤", "불편", "뻐근", "시큰", "욱신"
    );

    /** 컨디션 저하 키워드 (다른 부위라도 고강도 차단 기준). */
    private static final List<String> POOR_CONDITION_KEYWORDS = List.of(
        "피곤", "피로", "잠 못", "잠을 못", "수면 부족", "수면부족", "졸려", "졸림",
        "몸살", "감기", "컨디션 안", "컨디션이 안", "컨디션 나", "컨디션 최악",
        "지쳐", "지침", "힘들어", "무기력", "과음", "숙취"
    );

    private static final List<String> LIGHTER_KEYWORDS = List.of(
        "가볍게", "살살", "약하게", "낮춰", "줄여", "쉬운", "쉽게", "부드럽게", "천천히", "무리 없이", "무리없이", "저강도"
    );

    private static final List<String> HARDER_KEYWORDS = List.of(
        "강하게", "빡세게", "세게", "높여", "고강도", "하드", "힘차게", "제대로", "컨디션 최고"
    );

    private static final List<String> NORMAL_KEYWORDS = List.of(
        "보통", "적당히", "평소처럼", "중강도"
    );

    private static final List<String> SHORT_TIME_KEYWORDS = List.of(
        "짧게", "간단히", "간단하게", "급해", "시간 없어", "시간이 없어"
    );

    private static final Map<BodyArea, List<String>> BODY_AREA_KEYWORDS = new LinkedHashMap<>();

    static {
        BODY_AREA_KEYWORDS.put(BodyArea.LOWER_BACK, List.of("허리", "요통"));
        BODY_AREA_KEYWORDS.put(BodyArea.KNEE, List.of("무릎"));
        BODY_AREA_KEYWORDS.put(BodyArea.SHOULDER, List.of("어깨"));
        BODY_AREA_KEYWORDS.put(BodyArea.NECK, List.of("목", "승모"));
        BODY_AREA_KEYWORDS.put(BodyArea.WRIST, List.of("손목"));
        BODY_AREA_KEYWORDS.put(BodyArea.ANKLE, List.of("발목"));
        BODY_AREA_KEYWORDS.put(BodyArea.HIP, List.of("고관절", "골반"));
    }

    public SessionAdjustment interpret(String prompt) {
        if (prompt == null || prompt.isBlank()) {
            return new SessionAdjustment(AdjustRiskLevel.NONE, null, false, null, null, Set.of(), false, null);
        }
        String normalized = prompt.trim().toLowerCase(Locale.ROOT);

        // 1. 위험 신호 최우선 (세션 변경 중단 + 운동 시작 차단)
        if (containsAny(normalized, EMERGENCY_KEYWORDS)) {
            return new SessionAdjustment(
                AdjustRiskLevel.EMERGENCY, null, false, null, null, Set.of(), true, SessionAdjustment.EMERGENCY_NOTE
            );
        }

        // 2. 질환·상태 (세션 변경 안 함 + 의사 상담 안내)
        if (containsAny(normalized, MEDICAL_KEYWORDS)) {
            return new SessionAdjustment(
                AdjustRiskLevel.MEDICAL, null, false, null, null, Set.of(), false, "질환:상담안내"
            );
        }

        boolean hasPain = containsAny(normalized, PAIN_KEYWORDS);
        EnumSet<BodyArea> excludedAreas = EnumSet.noneOf(BodyArea.class);
        if (hasPain) {
            // [문장조정] '손목'·'발목'에 포함된 '목'이 NECK로 오탐되지 않도록 제외 문자열을 별도 검사한다
            String withoutWristAnkle = normalized.replace("손목", "").replace("발목", "");
            for (Map.Entry<BodyArea, List<String>> entry : BODY_AREA_KEYWORDS.entrySet()) {
                String target = entry.getKey() == BodyArea.NECK ? withoutWristAnkle : normalized;
                if (containsAny(target, entry.getValue())) {
                    excludedAreas.add(entry.getKey());
                }
            }
        }

        boolean poorCondition = containsAny(normalized, POOR_CONDITION_KEYWORDS)
            || (hasPain && excludedAreas.isEmpty());
        AdjustRiskLevel riskLevel = hasPain ? AdjustRiskLevel.PAIN : AdjustRiskLevel.NONE;

        ParsedMinutes parsedMinutes = parseMinutes(normalized);
        SessionFocus focus = parseFocus(normalized);
        IntensityIntent intensityIntent = parseIntensity(normalized);

        String summary = buildSummary(parsedMinutes.minutes(), focus, intensityIntent,
            excludedAreas, poorCondition, hasPain);
        return new SessionAdjustment(
            riskLevel, parsedMinutes.minutes(), parsedMinutes.underMin(),
            focus, intensityIntent, excludedAreas, poorCondition, summary
        );
    }

    private static ParsedMinutes parseMinutes(String text) {
        Matcher m = MINUTES_PATTERN.matcher(text);
        if (m.find()) {
            int parsed = Integer.parseInt(m.group(1));
            if (parsed > 0 && parsed < 15) {
                // [문장조정] 15분 미만 요청은 15분으로 임의 증량하지 않는다
                return new ParsedMinutes(null, true);
            }
            if (parsed >= 15) {
                return new ParsedMinutes(WorkoutConditionsResolver.floorMinutes(parsed), false);
            }
        }
        if (text.contains("반시간") || text.contains("반 시간")) {
            return new ParsedMinutes(30, false);
        }
        Matcher hm = HOURS_PATTERN.matcher(text);
        if (hm.find()) {
            int hours = Integer.parseInt(hm.group(1));
            if (hours >= 1) {
                return new ParsedMinutes(60, false);
            }
        }
        if (text.contains("한시간") || text.contains("한 시간")) {
            return new ParsedMinutes(60, false);
        }
        if (containsAny(text, SHORT_TIME_KEYWORDS)) {
            return new ParsedMinutes(15, false);
        }
        return new ParsedMinutes(null, false);
    }

    private record ParsedMinutes(Integer minutes, boolean underMin) {
    }

    private static SessionFocus parseFocus(String text) {
        if (containsAny(text, List.of("회복", "스트레칭", "가동성", "이완", "몸 풀"))) {
            return SessionFocus.RECOVERY;
        }
        if (containsAny(text, List.of("상체", "팔 운동", "가슴 운동", "등 운동"))) {
            return SessionFocus.UPPER;
        }
        if (containsAny(text, List.of("하체", "다리 운동", "힙 운동"))) {
            return SessionFocus.LOWER;
        }
        if (containsAny(text, List.of("유산소", "코어", "복근", "뱃살", "카디오"))) {
            return SessionFocus.CORE_CARDIO;
        }
        if (text.contains("전신")) {
            return SessionFocus.FULL_BODY;
        }
        return null;
    }

    private static IntensityIntent parseIntensity(String text) {
        // 안전 우선: 가볍게와 강하게가 동시에 나오면 가볍게로 해석
        if (containsAny(text, LIGHTER_KEYWORDS)) {
            return IntensityIntent.LIGHTER;
        }
        if (containsAny(text, HARDER_KEYWORDS)) {
            return IntensityIntent.HARDER;
        }
        if (containsAny(text, NORMAL_KEYWORDS)) {
            return IntensityIntent.NORMAL;
        }
        return null;
    }

    private static String buildSummary(Integer minutes, SessionFocus focus, IntensityIntent intent,
                                       Set<BodyArea> excludedAreas, boolean poorCondition, boolean hasPain) {
        List<String> parts = new ArrayList<>();
        if (minutes != null) {
            parts.add("시간:" + minutes + "분");
        }
        if (focus != null) {
            parts.add("부위:" + focus.label());
        }
        if (intent != null) {
            parts.add("강도:" + intent.label());
        }
        if (!excludedAreas.isEmpty()) {
            String labels = excludedAreas.stream().map(BodyArea::label).sorted()
                .reduce((a, b) -> a + "·" + b).orElse("");
            parts.add("제외:" + labels);
        } else if (hasPain) {
            parts.add("통증:강도완화");
        }
        if (poorCondition && !(hasPain && excludedAreas.isEmpty())) {
            parts.add("컨디션:저하");
        }
        if (parts.isEmpty()) {
            return null;
        }
        String joined = String.join(", ", parts);
        return joined.length() <= 200 ? joined : joined.substring(0, 200);
    }

    private static boolean containsAny(String text, List<String> keywords) {
        for (String keyword : keywords) {
            if (text.contains(keyword)) {
                return true;
            }
        }
        return false;
    }
}
