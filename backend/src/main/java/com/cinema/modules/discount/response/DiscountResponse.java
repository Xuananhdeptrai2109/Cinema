package com.cinema.modules.discount.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DiscountResponse {
    private String discountTitle;       // Tiêu đề khuyến mãi[cite: 24, 27]
    private String discountDescription; // Mô tả chi tiết[cite: 24, 27]
    private String discountCode;        // Mã code (ví dụ: HAPPYTUE)[cite: 24, 27]
    private String discountType;        // Loại: percent hoặc fixed[cite: 24, 27]
    private BigDecimal discountValue;   // Giá trị giảm[cite: 24, 27]
    private LocalDate startDate;        // Ngày bắt đầu hiệu lực[cite: 24, 27]
    private LocalDate endDate;          // Ngày hết hạn[cite: 24, 27]
}