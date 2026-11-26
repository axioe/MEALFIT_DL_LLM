package com.mealfit.domain.inventory.dto;

import java.util.List;

public record BatchStockInResponse(String clientRequestId, List<LotResponse> lots) {}
