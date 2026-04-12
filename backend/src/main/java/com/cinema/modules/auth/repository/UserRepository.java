package com.cinema.modules.auth.repository;

import com.cinema.modules.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    // Bạn nên thêm hàm này để phục vụ cho AuthService
    Optional<User> findByUserName(String userName);

    Optional<User> findByEmail(String email);
}