package com.cinema.modules.booking.dto;

import lombok.Data;
import java.util.List;

@Data
public class BookingRequest {
    private Long userId;
    private List<Long> showtimeSeatIds; // Danh sách ID ghế chọn
    private List<ProductSelection> products; // Danh sách combo chọn

    @Data
    public static class ProductSelection {
        private Long productId;
        private Integer quantity;
    }
}