package com.cinema.modules.room.entity;

import com.cinema.modules.cinema.entity.Cinema;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Room")
@Data
public class Room {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "room_id")
    private Long roomId;

    @Column(name = "room_name", nullable = false, length = 50)
    private String roomName;

    @Column(name = "capacity")
    private Integer capacity;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cinemas_id", nullable = false)
    private Cinema cinema;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "screening_format_id", nullable = false)
    private ScreeningFormat screeningFormat;

    @Column(name = "status")
    private String status = "active";
}
