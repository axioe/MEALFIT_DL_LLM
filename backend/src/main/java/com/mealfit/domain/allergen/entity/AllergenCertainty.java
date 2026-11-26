package com.mealfit.domain.allergen.entity;

/** 재료가 알레르기 유발물질을 포함하는 정도. */
public enum AllergenCertainty {
    /** 확실히 포함 (예: 참기름 → 참깨) */
    CONTAINS,
    /** 제품에 따라 포함될 수 있어 확인이 필요 (예: 간장 → 밀) */
    MAY_CONTAIN
}
