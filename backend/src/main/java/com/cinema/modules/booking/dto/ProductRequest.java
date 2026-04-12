package com.cinema.modules.booking.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class ProductRequest {
    private String name;
    private BigDecimal price;
    private String imageUrl;
    private Long productTypeId;
}