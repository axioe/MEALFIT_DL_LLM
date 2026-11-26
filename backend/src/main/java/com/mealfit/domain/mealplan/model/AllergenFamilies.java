package com.mealfit.domain.mealplan.model;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

/**
 * 알레르기 재료를 같은 계열의 재료·가공식품까지 넓혀 차단하기 위한 임시 확장표.
 *
 * <p>우유 알레르기는 치즈·버터, 달걀 알레르기는 마요네즈, 밀 알레르기는 빵·국수까지 검사한다.
 * 대상은 식품표시광고법 시행규칙 별표 2 Ⅰ.1.가의 알레르기 유발물질 19종과,
 * 식약처 공고 제2026-386호로 추가가 예고된 참깨·들깨·아몬드·캐슈너트(안 시행 2028-01-01)다.
 * 추출 성분도 표시 대상이므로 참기름·들기름처럼 그 식품에서 얻은 재료를 함께 막는다.
 * 동의어와 가공식품 목록은 팀이 작성한 것이며 고시 원문이 아니다.
 *
 * <p>알레르기에만 적용한다. 취향으로 고른 제외 재료는 IngredientRestriction에서 동의어와 함께 검사한다.
 */
public final class AllergenFamilies {

    /** 사용자가 입력하는 이름(별칭) → 함께 차단할 재료명 */
    private record Family(List<String> aliases, List<String> members) {
    }

    private static final List<Family> FAMILIES = List.of(
            new Family(List.of("우유", "유제품", "milk"),
                    List.of("우유", "치즈", "버터", "크림", "요거트", "요구르트", "분유", "연유", "유청", "카제인",
                            "모짜렐라", "리코타", "파마산", "라떼")),
            new Family(List.of("달걀", "계란", "알류", "난류", "egg"),
                    List.of("달걀", "계란", "메추리알", "오리알", "난백", "난황", "마요네즈")),
            new Family(List.of("밀", "밀가루", "글루텐", "wheat"),
                    List.of("밀", "소맥", "빵", "국수", "라면", "우동", "파스타", "스파게티", "부침가루", "튀김가루",
                            "만두피", "또띠아", "수제비", "글루텐")),
            new Family(List.of("대두", "콩", "soy"),
                    List.of("대두", "콩", "두부", "두유", "된장", "간장", "청국장", "고추장", "유부")),
            new Family(List.of("땅콩", "peanut"), List.of("땅콩", "피넛")),
            new Family(List.of("메밀"), List.of("메밀", "냉면")),
            new Family(List.of("새우"), List.of("새우", "대하", "쉬림프")),
            new Family(List.of("게", "꽃게"), List.of("게", "꽃게", "대게", "크랩", "맛살")),
            new Family(List.of("조개", "조개류", "굴", "전복", "홍합"),
                    List.of("조개", "굴", "전복", "홍합", "바지락", "가리비", "꼬막", "재첩", "모시조개")),
            new Family(List.of("고등어"), List.of("고등어")),
            new Family(List.of("오징어"), List.of("오징어")),
            new Family(List.of("복숭아"), List.of("복숭아")),
            new Family(List.of("토마토"), List.of("토마토", "케첩", "케찹")),
            new Family(List.of("호두"), List.of("호두")),
            new Family(List.of("잣"), List.of("잣")),
            new Family(List.of("돼지고기", "돼지"),
                    List.of("돼지", "돈육", "삼겹살", "목살", "베이컨", "햄", "소시지", "돈가스", "족발")),
            new Family(List.of("쇠고기", "소고기"), List.of("쇠고기", "소고기", "우육", "차돌", "양지", "사골", "우삼겹")),
            new Family(List.of("닭고기", "닭"), List.of("닭", "치킨", "계육")),
            new Family(List.of("아황산류", "아황산", "이산화황", "sulfite"), List.of("아황산", "이산화황")),
            // 아래 4종은 개정 예고(미확정)지만 미리 적용한다
            new Family(List.of("참깨", "깨", "sesame"), List.of("참깨", "참기름", "깨소금", "통깨", "타히니")),
            new Family(List.of("들깨", "perilla"), List.of("들깨", "들기름")),
            new Family(List.of("아몬드", "almond"), List.of("아몬드")),
            new Family(List.of("캐슈너트", "캐슈넛", "캐슈", "cashew"), List.of("캐슈"))
    );

    private static final Map<String, List<String>> BY_ALIAS = buildIndex();

    private AllergenFamilies() {
    }

    /** 입력한 알레르기 재료에 같은 계열 재료를 더한다. 표에 없는 재료는 그대로 둔다. */
    public static Set<String> expand(Collection<String> allergies) {
        Set<String> expanded = new LinkedHashSet<>();
        for (String allergy : allergies) {
            if (allergy == null) {
                continue;
            }
            expanded.add(allergy);
            List<String> members = BY_ALIAS.get(normalize(allergy));
            if (members != null) {
                expanded.addAll(members);
            }
        }
        return expanded;
    }

    private static Map<String, List<String>> buildIndex() {
        Map<String, List<String>> index = new java.util.HashMap<>();
        for (Family family : FAMILIES) {
            family.aliases().forEach(alias -> index.put(normalize(alias), family.members()));
        }
        return Map.copyOf(index);
    }

    private static String normalize(String value) {
        return value.replaceAll("\\s+", "").toLowerCase(Locale.ROOT);
    }
}
