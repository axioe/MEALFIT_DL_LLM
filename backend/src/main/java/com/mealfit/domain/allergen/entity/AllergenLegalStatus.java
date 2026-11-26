package com.mealfit.domain.allergen.entity;

/** 알레르기 유발물질의 법적 상태. */
public enum AllergenLegalStatus {
    /** 식품표시광고법 시행규칙 별표 2 Ⅰ.1.가 현행 표시 대상 */
    CURRENT,
    /** 식약처 공고 제2026-386호 개정 예고(미확정). 시행 전이지만 미리 적용한다 */
    PROPOSED
}
