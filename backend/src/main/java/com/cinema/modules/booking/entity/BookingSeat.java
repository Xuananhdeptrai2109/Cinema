package com.cinema.modules.booking.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Booking_seat")
@Getter
@Setter
public class BookingSeat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "booking_seat_id")
    private Long id;

    private Double price_at_booking;

    @ManyToOne
    @JoinColumn(name = "invoice_id")
    private Invoice invoice;
}
