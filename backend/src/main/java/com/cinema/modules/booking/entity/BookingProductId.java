package com.cinema.modules.booking.entity;

import lombok.*;
import java.io.Serializable;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookingProductId implements Serializable {
    private UUID invoice;
    private Long product;
}