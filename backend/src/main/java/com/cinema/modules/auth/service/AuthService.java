package com.cinema.modules.auth.service;

import com.cinema.modules.auth.dto.ResetPasswordRequest;
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

    @Autowired
    private org.springframework.mail.javamail.JavaMailSender mailSender;

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

    // GỬI OTP
    public void sendOtp(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Email không tồn tại"));

        String otp = String.valueOf(new java.util.Random().nextInt(900000) + 100000); // 6 số
        user.setOtp(otp);
        user.setOtpExpiry(java.time.LocalDateTime.now().plusMinutes(5)); // Hết hạn sau 5p
        userRepository.save(user);

        // Gửi mail (Chạy bất đồng bộ nếu cần)
        org.springframework.mail.SimpleMailMessage message = new org.springframework.mail.SimpleMailMessage();
        message.setTo(email);
        message.setSubject("Mã OTP đặt lại mật khẩu CineMax");
        message.setText("Mã OTP của bạn là: " + otp + ". Mã có hiệu lực trong 5 phút.");
        mailSender.send(message);
    }

    // RESET MẬT KHẨU
    public AuthResponse resetPassword(ResetPasswordRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Email không tồn tại"));

        if (user.getOtp() == null || !user.getOtp().equals(request.getOtp())) {
            throw new RuntimeException("Mã OTP không chính xác");
        }

        if (user.getOtpExpiry().isBefore(java.time.LocalDateTime.now())) {
            throw new RuntimeException("Mã OTP đã hết hạn");
        }

        // Cập nhật mật khẩu mới
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        user.setOtp(null); // Xóa OTP sau khi dùng xong
        user.setOtpExpiry(null);
        userRepository.save(user);

        return new AuthResponse(null, "Đặt lại mật khẩu thành công");
    }
}