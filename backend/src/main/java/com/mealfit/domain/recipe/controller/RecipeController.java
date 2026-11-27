package com.mealfit.domain.recipe.controller;

import com.mealfit.domain.recipe.dto.RecipeDetailResponse;
import com.mealfit.domain.recipe.dto.RecipeCatalogResponse;
import com.mealfit.domain.recipe.service.RecipeService;
import com.mealfit.global.web.CurrentUserId;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "Recipe", description = "레시피")
@RestController
@RequestMapping("/api/v1/recipes")
@RequiredArgsConstructor
public class RecipeController {

    private final RecipeService recipeService;

    @Operation(summary = "공용 레시피 목록", description = "비로그인 조회 가능. 검수 CSV와 기본 공용 레시피를 ID 순으로 페이지당 24개씩 제공합니다. 페이지는 1부터 시작합니다.")
    @GetMapping("/public")
    public RecipeCatalogResponse publicCatalog(@RequestParam(defaultValue = "1") int page) {
        return recipeService.getPublicCatalog(page);
    }

    @Operation(summary = "공용 레시피 상세", description = "비로그인 조회 가능. 공용 레시피의 재료·영양·조리 순서를 반환하며 개인 레시피는 404입니다.")
    @GetMapping("/public/{id}")
    public RecipeDetailResponse publicDetail(@PathVariable Long id, @RequestParam(required = false) Integer servings) {
        return recipeService.getDetail(null, id, servings);
    }

    @Operation(summary = "레시피 상세 (인분 환산)")
    @GetMapping("/{id}")
    public RecipeDetailResponse getDetail(@CurrentUserId Long userId,
                                          @PathVariable Long id,
                                          @RequestParam(required = false) Integer servings) {
        return recipeService.getDetail(userId, id, servings);
    }
}
