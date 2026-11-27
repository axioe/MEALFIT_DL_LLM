package com.mealfit.domain.recipe.service;

import com.mealfit.domain.recipe.dto.RecipeDetailResponse;
import com.mealfit.domain.recipe.dto.RecipeCatalogResponse;
import com.mealfit.domain.recipe.entity.Recipe;
import com.mealfit.domain.recipe.repository.RecipeRepository;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RecipeService {

    private final RecipeRepository recipeRepository;
    private static final int CATALOG_PAGE_SIZE = 24;

    public RecipeCatalogResponse getPublicCatalog(int page) {
        if (page < 1 || page > Integer.MAX_VALUE / CATALOG_PAGE_SIZE) {
            throw new BusinessException(ErrorCode.INVALID_INPUT);
        }
        var result = recipeRepository.findPublicCatalog(PageRequest.of(page - 1, CATALOG_PAGE_SIZE))
                .map(recipe -> new RecipeCatalogResponse.Item(recipe.getId(), recipe.getName(), recipe.getCookTimeMin(), recipe.getServingSize()));
        return new RecipeCatalogResponse(result.getContent(), result.getTotalElements(), result.getTotalPages());
    }

    /** servings가 없으면 레시피 기준 인분으로 보여준다. */
    public RecipeDetailResponse getDetail(Long userId, Long recipeId, Integer servings) {
        if (servings != null && servings < 1) {
            throw new BusinessException(ErrorCode.INVALID_INPUT, "인분은 1 이상이어야 합니다.");
        }
        Recipe recipe = (userId == null ? recipeRepository.findPublicById(recipeId) : recipeRepository.findAccessibleById(recipeId, userId))
                .orElseThrow(() -> new BusinessException(ErrorCode.RECIPE_NOT_FOUND));
        return RecipeDetailResponse.from(recipe, servings != null ? servings : recipe.getServingSize());
    }
}
