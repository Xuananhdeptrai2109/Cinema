package com.cinema.modules.auth.repository;

import com.cinema.modules.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository("authRepository") // Đặt tên Bean cụ thể để tránh nhầm lẫn
public interface AuthRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    Optional<User> findByUserName(String userName);
}