package com.cinema.modules.user.controller;

import com.cinema.modules.booking.entity.Invoice;
import com.cinema.modules.booking.repository.InvoiceRepository;
import com.cinema.modules.user.dto.CoinRequest;
import com.cinema.modules.user.dto.UserRequest;
import com.cinema.modules.user.dto.VoucherRequest;
import com.cinema.modules.user.entity.User;
import com.cinema.modules.user.repository.UserRepository;
import com.cinema.modules.user.response.UserResponse;
import com.cinema.modules.user.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*") // Hỗ trợ gọi từ Live Server
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private InvoiceRepository invoiceRepository;

    @GetMapping("/profile")
    public ResponseEntity<UserResponse> getProfile(Authentication authentication) {
        String email = authentication.getName();
        return ResponseEntity.ok(userService.getProfile(email));
    }

    @PutMapping("/profile")
    public ResponseEntity<UserResponse> updateProfile(Authentication authentication, @RequestBody UserRequest request) {
        String email = authentication.getName();
        return ResponseEntity.ok(userService.updateProfile(email, request));
    }

    @GetMapping("/{userId}/coins")
    public ResponseEntity<?> getUserCoins(@PathVariable Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return ResponseEntity.ok(Map.of("coins", user.getCoin() != null ? user.getCoin() : 0));
    }

    @GetMapping("/me/coin-history")
    public ResponseEntity<?> getCoinHistory() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByEmail(email).orElseThrow();

        List<Invoice> invoices = invoiceRepository.findByUserAndUsedCoinGreaterThanOrderByCreatedDatetimeDesc(user, 0);

        List<CoinRequest> history = invoices.stream().map(inv -> new CoinRequest(
                inv.getCreatedDatetime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                "Thanh toán vé phim (Mã: " + inv.getTicketCode() + ")",
                -inv.getUsedCoin() // Chuyển thành số âm để hiển thị là chi tiêu[cite: 16]
        )).collect(Collectors.toList());

        return ResponseEntity.ok(history);
    }

    @GetMapping("/me/voucher-history")
    public ResponseEntity<?> getVoucherHistory() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByEmail(email).orElseThrow();

        // Lấy hóa đơn có mã giảm giá[cite: 14]
        List<Invoice> invoices = invoiceRepository.findByUserAndDiscountCodeIsNotNullOrderByCreatedDatetimeDesc(user);

        List<VoucherRequest> history = invoices.stream().map(inv -> new VoucherRequest(
                inv.getDiscountCode(),
                inv.getPaidAt() != null ? inv.getPaidAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "---",
        "Đã áp dụng"
        )).collect(Collectors.toList());

        return ResponseEntity.ok(history);
    }
}