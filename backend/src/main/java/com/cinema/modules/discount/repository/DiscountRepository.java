package com.cinema.modules.discount.repository;

import com.cinema.modules.discount.entity.Discount;
import com.cinema.modules.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DiscountRepository extends JpaRepository<Discount, Long> {
    Optional<Discount> findByDiscountCode(String discountCode);
}