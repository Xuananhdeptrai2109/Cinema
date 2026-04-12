package com.cinema.modules.discount.service;

import com.cinema.modules.discount.response.DiscountResponse;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.ArrayList;

@Service // Đánh dấu để Spring Boot "nhồi" vào HomeServiceImpl
@Transactional
public class DiscountServiceImpl implements DiscountService {

    @Override
    public List<DiscountResponse> getActivePromotions() {
        // Tạm thời trả về danh sách rỗng để ứng dụng xanh toàn bộ
        return new ArrayList<>();
    }
}