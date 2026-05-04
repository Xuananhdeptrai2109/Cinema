package com.cinema.modules.booking.repository;

import com.cinema.modules.booking.entity.Invoice;
import com.cinema.modules.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.UUID;
import java.util.List;

@Repository
public interface InvoiceRepository extends JpaRepository<Invoice, UUID> {
    // Tìm danh sách hóa đơn của một user
    List<Invoice> findByUser_UserIdOrderByCreatedDatetimeDesc(Long userId);
    List<Invoice> findByUserAndUsedCoinGreaterThanOrderByCreatedDatetimeDesc(User user, Integer usedCoin);
    List<Invoice> findByUserAndDiscountCodeIsNotNullOrderByCreatedDatetimeDesc(User user);
}