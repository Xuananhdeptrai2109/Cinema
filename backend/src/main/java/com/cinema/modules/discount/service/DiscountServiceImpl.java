package com.cinema.modules.discount.service;

import com.cinema.modules.discount.repository.DiscountRepository;
import com.cinema.modules.discount.response.DiscountResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.ArrayList;

@Service // Đánh dấu để Spring Boot "nhồi" vào HomeServiceImpl
@Transactional
public class DiscountServiceImpl implements DiscountService {
    // Trong DiscountServiceImpl.java
    @Autowired
    private DiscountRepository discountRepository;

    @Override
    public List<DiscountResponse> getActivePromotions() {
        // Lấy danh sách từ DB và chuyển đổi sang DiscountResponse[cite: 21]
        return discountRepository.findAll().stream()
                .filter(d -> !Boolean.TRUE.equals(d.getIsUsed())) // Chỉ lấy mã chưa bị khóa[cite: 6]
                .map(d -> new DiscountResponse(
                        d.getDiscountTitle(),
                        d.getDiscountDescription(),
                        d.getDiscountCode(),
                        d.getDiscountType().name(),
                        d.getDiscountValue(),
                        d.getStartDate(),
                        d.getEndDate()
                )).toList();
    }
}