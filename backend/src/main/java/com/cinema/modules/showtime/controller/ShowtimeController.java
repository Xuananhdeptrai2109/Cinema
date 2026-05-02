package com.cinema.modules.showtime.controller;

import com.cinema.modules.showtime.response.ShowtimeDetailResponse;
import com.cinema.modules.showtime.response.ShowtimeResponse;
import com.cinema.modules.showtime.service.ShowtimeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/showtimes")
@CrossOrigin(origins = "http://localhost:63342")
public class ShowtimeController {

    @Autowired
    private ShowtimeService showtimeService;

    @GetMapping
    public ResponseEntity<List<ShowtimeResponse>> getShowtimes(
            @RequestParam Long cinemaId,
            @RequestParam String date) {
        return ResponseEntity.ok(showtimeService.getShowtimesByCinemaAndDate(cinemaId, date));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ShowtimeDetailResponse> getShowtimeById(@PathVariable Long id) {
        return ResponseEntity.ok(showtimeService.getShowtimeById(id));
    }
}