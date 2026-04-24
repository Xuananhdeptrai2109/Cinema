package com.cinema.modules.booking.repository;

import com.cinema.modules.booking.entity.Invoice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface InvoiceRepository extends JpaRepository<Invoice, java.util.UUID> {
    List<Invoice> findByUser_UserIdOrderByCreatedDatetimeDesc(Long userId);
}