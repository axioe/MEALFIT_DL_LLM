package com.mealfit.domain.search.dto;

/** 통합 검색 대상 */
public enum SearchType {
    /** 레시피: 공용(검수) + 본인 레시피, 요리명·재료명 */
    RECIPE,
    /** 내 냉장고: 사용 중(ACTIVE) 재고 묶음, 재료명 */
    INVENTORY,
    /** 내 식단: 메뉴명 */
    MEAL_PLAN,
    /** 내 장보기: 재료명 */
    SHOPPING,
    /** 운동 사전: 운동 이름·코드 */
    EXERCISE,
    /** 내 운동 세션: 제목·운동 항목 */
    WORKOUT
}
