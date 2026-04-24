package com.cinema.modules.seat.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "seat_type")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class SeatType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "seat_type_id")
    private Long seatTypeId;

    @Column(name = "type_name", length = 50, nullable = false)
    private String typeName;

    @Column(name = "price", precision = 10, scale = 2, nullable = false)
    private BigDecimal price;
}