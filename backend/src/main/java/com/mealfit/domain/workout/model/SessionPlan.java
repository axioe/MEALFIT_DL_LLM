package com.mealfit.domain.workout.model;

import java.time.LocalDate;
import java.util.List;

/**
 * 하루 세션 계획. source는 RULE(규칙 생성) 또는 DEFAULT(기본 루틴 대체).
 * intensityCap은 이 세션에 적용한 강도 상한이다 (주간 HIGH 세션 제한 반영, D18 ①).
 */
public record SessionPlan(
    LocalDate date,
    SessionFocus focus,
    String title,
    List<PlannedItem> items,
    String source,
    int intensityCap
) {
    public static final String SOURCE_RULE = "RULE";
    public static final String SOURCE_DEFAULT = "DEFAULT";

    public SessionPlan {
        items = List.copyOf(items);
    }

    public List<PlannedItem> itemsOf(Phase phase) {
        return items.stream().filter(item -> item.phase() == phase).toList();
    }
}
