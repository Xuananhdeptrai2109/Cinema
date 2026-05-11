package com.cinema.modules.showtime.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class ShowtimeRequest {
    private Long movieId;
    private Long roomId;
    private LocalDate showDate;
    private LocalTime startTime;
    private LocalTime endTime;
}
