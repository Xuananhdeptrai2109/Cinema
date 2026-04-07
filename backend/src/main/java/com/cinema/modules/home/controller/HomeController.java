package com.cinema.modules.home.controller;

import com.cinema.modules.home.dto.HomeResponse;
import com.cinema.modules.home.service.HomeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/home")
@CrossOrigin(origins = "*") // Cho phép file HTML bên ngoài gọi vào
public class HomeController {

    @Autowired
    private HomeService homeService;

    @GetMapping("/init")
    public ResponseEntity<HomeResponse> getHomeInitialData() {
        // TRẢ VỀ DỮ LIỆU (JSON), KHÔNG TRẢ VỀ FILE HTML
        return ResponseEntity.ok(homeService.getHomeData());
    }
}