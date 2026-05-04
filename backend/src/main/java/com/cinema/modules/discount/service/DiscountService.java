package com.cinema.modules.discount.service;

import com.cinema.modules.discount.response.DiscountResponse;
import java.util.List;

public interface DiscountService {
    List<DiscountResponse> getActivePromotions();
}