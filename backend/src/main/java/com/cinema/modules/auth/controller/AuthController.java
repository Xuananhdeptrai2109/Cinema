package com.cinema.modules.auth.controller;

import com.cinema.modules.auth.dto.ForgotPasswordRequest;
import com.cinema.modules.auth.dto.LoginRequest;
import com.cinema.modules.auth.dto.ResetPasswordRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.cinema.modules.auth.dto.RegisterRequest;
import com.cinema.modules.auth.response.AuthResponse;
import com.cinema.modules.auth.service.AuthService;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*") // Cho phép tất cả các nguồn truy cập để test
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public AuthResponse register(@RequestBody RegisterRequest request) {
        return authService.register(request);
    }

    @PostMapping("/login")
    public AuthResponse login(@RequestBody LoginRequest request) {
        return authService.login(request);
    }

    @PostMapping("/forgot-password")
    public AuthResponse forgotPassword(@RequestBody ForgotPasswordRequest request) {
        authService.sendOtp(request.getEmail());
        return new AuthResponse(null, "Mã OTP đã được gửi đến email của bạn");
    }

    @PostMapping("/reset-password")
    public AuthResponse resetPassword(@RequestBody ResetPasswordRequest request) {
        return authService.resetPassword(request);
    }
}