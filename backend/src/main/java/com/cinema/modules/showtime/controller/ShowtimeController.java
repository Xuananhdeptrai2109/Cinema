package com.cinema.modules.showtime.controller;

import com.cinema.modules.showtime.response.ShowtimeResponse;
import com.cinema.modules.showtime.service.ShowtimeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/showtimes")
@CrossOrigin(origins = "*") // Cho phép tất cả các nguồn hoặc liệt kê cụ thể
public class ShowtimeController {

    @Autowired
    private ShowtimeService showtimeService;

    // 1. Hàm lấy danh sách (Đã có)
    @GetMapping
    public ResponseEntity<List<ShowtimeResponse>> getShowtimes(
            @RequestParam Long cinemaId,
            @RequestParam String date) {
        return ResponseEntity.ok(showtimeService.getShowtimesByCinemaAndDate(cinemaId, date));
    }

    // 2. BỔ SUNG HÀM NÀY: Để xử lý /api/showtimes/{id}
    @GetMapping("/{id}")
    public ResponseEntity<ShowtimeResponse> getShowtimeById(@PathVariable Long id) {
        // Gọi service để lấy chi tiết 1 suất chiếu
        return ResponseEntity.ok(showtimeService.getShowtimeById(id));
    }
}