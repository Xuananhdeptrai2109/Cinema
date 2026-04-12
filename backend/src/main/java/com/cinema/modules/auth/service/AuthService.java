package com.cinema.modules.auth.service;

import com.cinema.modules.user.entity.User;
import com.cinema.modules.auth.repository.UserRepository;
import com.cinema.modules.auth.dto.LoginRequest;
import com.cinema.modules.auth.dto.RegisterRequest;
import com.cinema.modules.auth.response.AuthResponse;
import com.cinema.security.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional // Đảm bảo mọi thay đổi sẽ được commit xuống DB
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    // REGISTER
    public AuthResponse register(RegisterRequest request) {

        if (userRepository.findByUserName(request.getUsername()).isPresent()) {
            throw new RuntimeException("Tên đăng nhập đã tồn tại");
        }

        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new RuntimeException("Email đã tồn tại");
        }
        User user = new User();
        user.setUserName(request.getUsername());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));

        userRepository.save(user);

        String token = jwtUtil.generateToken(user.getEmail());
        return new AuthResponse(token, "Đăng kí thành công");
    }

    // LOGIN
    public AuthResponse login(LoginRequest request) {

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Sai mật khẩu");
        }

        String token = jwtUtil.generateToken(user.getEmail());

        return new AuthResponse(token, "Đăng nhập thành công");
    }
}