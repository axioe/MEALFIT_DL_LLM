package com.mealfit.domain.recipe.dto;

import java.util.List;

public record RecipeCatalogResponse(List<Item> items, long total, int totalPages) {
    public record Item(Long id, String name, int cookTimeMin, int servingSize) {}
}
