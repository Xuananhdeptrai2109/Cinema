package com.cinema.modules.user.repository;

import com.cinema.modules.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    // Tìm kiếm theo email vì email là định danh trong Token của bạn
    Optional<User> findByEmail(String email);
}