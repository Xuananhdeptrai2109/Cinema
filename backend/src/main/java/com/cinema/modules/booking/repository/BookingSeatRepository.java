package com.cinema.modules.booking.repository;

import com.cinema.modules.booking.entity.BookingSeat;
import com.cinema.modules.booking.entity.Invoice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface BookingSeatRepository extends JpaRepository<BookingSeat, Long> {

    // Tìm ghế theo invoiceId (UUID)
    List<BookingSeat> findByInvoice_InvoiceId(UUID invoiceId);

    // Tìm ghế theo invoice object
    List<BookingSeat> findByInvoice(Invoice invoice);

    // Kiểm tra ghế đã được đặt chưa
    boolean existsByShowtimeSeat_ShowtimeSeatId(Long showtimeSeatId);

    // Lấy số ghế theo invoiceId (UUID)
    @Query("SELECT bs.showtimeSeat.seat.seatNumber FROM BookingSeat bs WHERE bs.invoice.invoiceId = :invoiceId")
    List<String> findSeatNumbersByInvoiceId(@Param("invoiceId") UUID invoiceId);
}