package com.mealfit.domain.inventory.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record ReceiptResponse(String modelVersion, String status, LocalDate purchaseDate,
        List<Item> items, List<String> warnings, long elapsedMs) {
    public record Item(String productName, String ingredientName, BigDecimal quantity, String unit,
            BigDecimal netQuantity, String netUnit, BigDecimal price, double textConfidence,
            String parsingStatus, boolean requiresConfirmation, String mappingStatus,
            BigDecimal packageCount, BigDecimal purchaseQuantity, String purchaseUnit, String quantityStatus) {}
}
