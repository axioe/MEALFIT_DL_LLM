package com.mealfit.domain.allergen.controller;

import com.mealfit.domain.allergen.dto.AllergenCatalogResponse;
import com.mealfit.domain.allergen.dto.AllergenSearchResult;
import com.mealfit.domain.allergen.dto.MyAllergiesRequest;
import com.mealfit.domain.allergen.dto.MyAllergiesResponse;
import com.mealfit.domain.allergen.dto.RecipeAllergenCheckResponse;
import org.springframework.web.bind.annotation.PathVariable;
import com.mealfit.domain.allergen.service.AllergenService;
import com.mealfit.global.web.CurrentUserId;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Size;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/** 알레르기 목록·검색과 내 알레르기 저장 (MEALFIT-139). 회원은 JWT로만 판단한다. */
@Validated
@RestController
@RequestMapping("/api/v1")
@Tag(name = "Allergen", description = "알레르기 목록·검색·내 알레르기 (식약처 23종)")
@RequiredArgsConstructor
public class AllergenController {

    private final AllergenService allergenService;

    @GetMapping("/allergens")
    @Operation(summary = "카테고리별 알레르기 목록 (선택 화면용)")
    public AllergenCatalogResponse catalog() {
        return allergenService.catalog();
    }

    @GetMapping("/allergens/search")
    @Operation(summary = "알레르기 검색 (이름·별칭·재료 이름, 예: 계란 → 알류, 참기름 → 참깨)")
    public List<AllergenSearchResult> search(@RequestParam("q") @Size(max = 50) String query) {
        return allergenService.search(query);
    }

    @GetMapping("/me/allergies")
    @Operation(summary = "내 알레르기 조회 (목록에서 고른 항목 + 직접 입력)")
    public MyAllergiesResponse myAllergies(@CurrentUserId Long userId) {
        return allergenService.myAllergies(userId);
    }

    @PutMapping("/me/allergies")
    @Operation(summary = "내 알레르기 저장 (전체 교체, 다른 추천 조건은 유지)")
    public MyAllergiesResponse replaceMyAllergies(@CurrentUserId Long userId,
                                                  @Valid @RequestBody MyAllergiesRequest request) {
        return allergenService.replaceMyAllergies(userId, request);
    }

    @GetMapping("/recipes/{recipeId}/allergen-check")
    @Operation(summary = "레시피가 내 알레르기에 걸리는지와 이유 (포함 / 확인 필요 / 이름 포함)")
    public RecipeAllergenCheckResponse checkRecipe(@CurrentUserId Long userId, @PathVariable Long recipeId) {
        return allergenService.checkRecipe(userId, recipeId);
    }
}
