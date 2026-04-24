package com.cinema.modules.user.controller;

import com.cinema.modules.user.entity.User;
import com.cinema.modules.auth.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/{userId}/coins")
    public ResponseEntity<?> getUserCoins(@PathVariable Long userId) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));
        return ResponseEntity.ok(Map.of("coins", user.getCoin() != null ? user.getCoin() : 0));
    }
}