package com.cinema.modules.discount.controller;

import com.cinema.modules.discount.entity.Discount;
import com.cinema.modules.discount.repository.DiscountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/discounts")
@CrossOrigin("*")
public class DiscountController {
    @Autowired
    private DiscountRepository discountRepository;

    @GetMapping("/check")
    public ResponseEntity<?> checkDiscount(@RequestParam String code) {
        Optional<Discount> discount = discountRepository.findByDiscountCode(code);

        if (discount.isPresent()) {
            return ResponseEntity.ok(discount.get());
        } else {
            return ResponseEntity.status(404).body("Mã giảm giá không tồn tại");
        }
    }
}