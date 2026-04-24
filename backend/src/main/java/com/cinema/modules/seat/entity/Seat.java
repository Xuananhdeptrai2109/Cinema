package com.cinema.modules.seat.entity;

import com.cinema.modules.room.entity.Room;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "seat", uniqueConstraints = {
        // Lưu ý: SQL của bạn để UNIQUE (room_id, seat_location)
        // nhưng bạn đã đổi trường, nên constraint này cũng cần đổi theo:
        @UniqueConstraint(columnNames = {"room_id", "row_name", "seat_number"})
})
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class Seat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "seat_id")
    private Long seatId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "seat_type_id", nullable = false)
    private SeatType seatType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;

    @Column(name = "row_name", length = 5, nullable = false)
    private String rowName;

    @Column(name = "seat_number", nullable = false)
    private Integer seatNumber;

    /**
     * Helper method để lấy tên ghế đầy đủ (VD: A1, B10)
     */
    public String getFullSeatName() {
        return rowName + seatNumber;
    }
}