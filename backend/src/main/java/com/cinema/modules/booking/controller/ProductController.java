package com.cinema.modules.booking.controller;

import com.cinema.modules.booking.response.ProductResponse;
import com.cinema.modules.booking.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
@CrossOrigin(origins = "*") // Tránh lỗi CORS khi chạy local
public class ProductController {
    private final ProductService productService;

    @GetMapping("/combos")
    public ResponseEntity<List<ProductResponse>> getCombos() {
        return ResponseEntity.ok(productService.getAllCombos());
    }
}