package com.cinema.modules.discount.controller;

import com.cinema.modules.booking.repository.InvoiceRepository;
import com.cinema.modules.discount.entity.Discount;
import com.cinema.modules.discount.repository.DiscountRepository;
import com.cinema.modules.user.entity.User;
import com.cinema.modules.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Optional;

@RestController
@RequestMapping("/api/discounts")
@CrossOrigin("*")
public class DiscountController {
    @Autowired
    private DiscountRepository discountRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private InvoiceRepository invoiceRepository;

    @GetMapping("/check")
    public ResponseEntity<?> checkDiscount(@RequestParam String code) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User currentUser = userRepository.findByEmail(email).orElseThrow();

        Optional<Discount> discountOpt = discountRepository.findByDiscountCode(code);
        if (discountOpt.isEmpty()) {
            return ResponseEntity.status(404).body("Mã giảm giá không tồn tại");
        }

        Discount discount = discountOpt.get();
        LocalDate now = LocalDate.now();

        // 1. Kiểm tra thời hạn hiệu lực (Ngày bắt đầu và kết thúc)
        if (discount.getStartDate() != null && now.isBefore(discount.getStartDate())) {
            return ResponseEntity.status(400).body("Mã giảm giá chưa đến ngày áp dụng");
        }
        if (discount.getEndDate() != null && now.isAfter(discount.getEndDate())) {
            return ResponseEntity.status(400).body("Mã giảm giá đã hết hạn sử dụng");
        }

        // 2. Kiểm tra các ngày được phép trong tuần (valid_days)
        if (discount.getValidDays() != null && !discount.getValidDays().isEmpty()) {
            String currentDay = now.getDayOfWeek().name();
            java.util.List<String> allowedDays = java.util.Arrays.stream(discount.getValidDays().split(","))
                    .map(String::trim)
                    .map(String::toUpperCase) // Chuẩn hóa về chữ hoa[cite: 11]
                    .collect(java.util.stream.Collectors.toList());

            if (!allowedDays.contains(currentDay)) {
                return ResponseEntity.status(400).body("Mã này không áp dụng cho ngày " + currentDay);
            }
        }

        // 3. Kiểm tra số lần sử dụng (max_usage vs current_usage)
        if (discount.getMaxUsage() != null && discount.getCurrentUsage() >= discount.getMaxUsage()) {
            return ResponseEntity.status(400).body("Mã giảm giá đã đạt giới hạn số lần sử dụng");
        }

        // 4. Kiểm tra trạng thái đã sử dụng (nếu là mã dùng 1 lần)
        if (Boolean.TRUE.equals(discount.getIsUsed())) {
            return ResponseEntity.status(400).body("Mã giảm giá này đã được sử dụng hoặc bị vô hiệu hóa");
        }

        // 5. Kiểm tra giới hạn 1 lần/người (Di chuyển logic vào đây để linh hoạt)[cite: 11, 14]
        if (discount.getUseLimitPerUser() != null && discount.getUseLimitPerUser() == 1) {
            if (invoiceRepository.existsByUserAndDiscountCode(currentUser, code)) {
                return ResponseEntity.status(400).body("Bạn đã sử dụng mã giảm giá này rồi.");
            }
        }

        return ResponseEntity.ok(discount);
    }
}