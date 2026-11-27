package com.mealfit.domain.search.controller;

import com.mealfit.domain.search.dto.SearchResponse;
import com.mealfit.domain.search.dto.SearchType;
import com.mealfit.domain.search.service.SearchService;
import com.mealfit.global.web.CurrentUserId;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Set;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "Search", description = "웹 통합 검색 (레시피·냉장고·식단·장보기·운동)")
@RestController
@RequestMapping("/api/v1/search")
@RequiredArgsConstructor
public class SearchController {

    private final SearchService searchService;

    @Operation(summary = "통합 검색",
            description = """
                    공백·대소문자를 무시하고 포함 여부로 찾습니다. 재료 기준표의 이름·별칭은 함께 찾습니다 (계란 → 달걀).
                    레시피는 공용 + 본인 레시피, 나머지는 본인 데이터만. 레시피는 내 알레르기·제외 재료가 있으면
                    restricted=true로 표시만 하고 결과에서 빼지 않습니다. limit·offset은 대상마다 따로 적용됩니다
                    (한 대상의 '더보기'는 types=그 대상만 + offset).""")
    @GetMapping
    public SearchResponse search(
            @CurrentUserId Long userId,
            @Parameter(description = "검색어 (1–50자)", example = "계란") @RequestParam("q") String query,
            @Parameter(description = "대상 (생략하면 전체). 예: types=RECIPE,INVENTORY")
            @RequestParam(required = false) Set<SearchType> types,
            @Parameter(description = "대상별 최대 건수 (1–20, 기본 5)") @RequestParam(required = false) Integer limit,
            @Parameter(description = "대상별 건너뛸 건수 (기본 0)") @RequestParam(required = false) Integer offset) {
        return searchService.search(userId, query, types, limit, offset);
    }
}
