package com.cinema.modules.cinema.controller;

import com.cinema.modules.cinema.service.ProvinceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cities")
@CrossOrigin(origins = "http://localhost:63342")
public class ProvinceController {

    @Autowired
    private ProvinceService provinceService;

    @GetMapping
    public List<String> getAllCities() {
        // Lấy danh sách tên tỉnh thành từ Service
        return provinceService.getAllProvinceNames();
    }
}