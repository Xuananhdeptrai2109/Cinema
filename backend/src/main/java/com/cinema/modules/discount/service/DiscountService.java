package com.cinema.modules.discount.service;

import com.cinema.modules.discount.response.DiscountResponse;
import java.util.List;

public interface DiscountService {
    // Lấy các khuyến mãi chưa hết hạn và còn lượt dùng
    List<DiscountResponse> getActivePromotions();
}