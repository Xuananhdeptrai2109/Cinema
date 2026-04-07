package com.cinema.modules.seat.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Seat_type")
@Getter
@Setter
public class SeatType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "seat_type_id")
    private Long id;

    private String type_name;

    private Double price;
}
