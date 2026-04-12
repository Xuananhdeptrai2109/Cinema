package com.cinema.modules.seat.controller;

import com.cinema.modules.seat.response.SeatResponse;
import com.cinema.modules.seat.service.SeatService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*") // Cho phép Frontend truy cập
public class SeatController {
    private final SeatService seatService;

    public SeatController(SeatService seatService) {
        this.seatService = seatService;
    }

    @GetMapping("/showtime-seats")
    public List<SeatResponse> getSeats(@RequestParam Long showtimeId) {
        return seatService.getSeatsByShowtime(showtimeId);
    }
}