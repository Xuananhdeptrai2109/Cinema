package com.cinema.modules.seat.entity;

import com.cinema.modules.room.entity.Room;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Seat")
@Getter
@Setter
public class Seat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "seat_id")
    private Long id;

    private String row_name;

    private Integer seat_number;

    @ManyToOne
    @JoinColumn(name = "seat_type_id")
    private SeatType seatType;

    @ManyToOne
    @JoinColumn(name = "room_id")
    private Room room;
}