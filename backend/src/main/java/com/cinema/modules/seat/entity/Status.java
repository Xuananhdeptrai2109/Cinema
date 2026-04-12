package com.cinema.modules.seat.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Status")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class Status {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "status_id")
    private Long statusId;

    @Enumerated(EnumType.STRING)
    @Column(name = "status_name", nullable = false, unique = true)
    private SeatStatusName statusName;

    // Enum định nghĩa các trạng thái
    public enum SeatStatusName {
        available, holding, booked
    }
}