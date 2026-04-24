package com.cinema.modules.booking.dto;

import lombok.Data;
import java.util.List;

@Data
public class BookingRequest {
    private Long userId;
    private Long showtimeId;       
    private List<Long> showtimeSeatIds;
    private List<ProductSelection> products;

    @Data
    public static class ProductSelection {
        private Long productId;
        private Integer quantity;
    }
}