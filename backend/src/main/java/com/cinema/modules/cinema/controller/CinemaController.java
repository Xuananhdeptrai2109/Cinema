package com.cinema.modules.cinema.controller;

import com.cinema.modules.cinema.entity.Cinema;
import com.cinema.modules.cinema.response.CinemaResponse;
import com.cinema.modules.cinema.service.CinemaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cinemas")
@CrossOrigin(origins = "http://localhost:63342") // Cho phép Frontend truy cập
public class CinemaController {

    @Autowired
    private CinemaService cinemaService;

    @GetMapping
    public ResponseEntity<List<CinemaResponse>> getCinemasByCity(@RequestParam("city") String cityName) {
        // Gọi hàm mới trong Service để lấy dữ liệu đã được lọc và map
        List<CinemaResponse> cinemas = cinemaService.getCinemasResponseByProvinceName(cityName);
        return ResponseEntity.ok(cinemas);
    }

}