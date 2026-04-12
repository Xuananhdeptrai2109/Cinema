package com.cinema.modules.seat.dto;

import lombok.Data;
import java.util.List;

@Data
public class SeatRequest {
    private Long showtimeId;
    private List<Long> selectedSeatIds;
    private Long userId;
}