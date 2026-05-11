package com.cinema.modules.cinema.controller;

import com.cinema.modules.cinema.entity.ProvinceCity;
import com.cinema.modules.cinema.repository.ProvinceRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/provinces")
public class AdminProvinceController {
    private final ProvinceRepository provinceRepository;

    public AdminProvinceController(ProvinceRepository provinceRepository) {
        this.provinceRepository = provinceRepository;
    }

    @GetMapping
    public ResponseEntity<List<ProvinceCity>> getAll() {
        return ResponseEntity.ok(provinceRepository.findAll());
    }
}
