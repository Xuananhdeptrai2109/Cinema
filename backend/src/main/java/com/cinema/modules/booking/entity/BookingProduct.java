package com.cinema.modules.booking.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "Booking_products")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@IdClass(BookingProductId.class) // Kết nối với file thứ nhất
public class BookingProduct {
    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "invoice_id")
    private Invoice invoice;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    @Column(name = "product_quantity", nullable = false)
    private Integer productQuantity;

    @Column(name = "price_at_booking", nullable = false)
    private BigDecimal priceAtBooking;
}