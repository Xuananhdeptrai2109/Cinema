package com.cinema.modules.booking.repository;

import com.cinema.modules.booking.entity.BookingSeat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface BookingSeatRepository extends JpaRepository<BookingSeat, Long> {

    // 1. Tìm tất cả các ghế thuộc về một hóa đơn cụ thể (UUID)
    List<BookingSeat> findByInvoice_InvoiceId(UUID invoiceId);

    // 2. Kiểm tra xem một ghế trong suất chiếu đã được đặt chưa (tránh đặt trùng)
    boolean existsByShowtime_ShowtimeIdAndShowtimeSeat_ShowtimeSeatId(Long showtimeId, Long showtimeSeatId);

    // 3. Xóa các ghế thuộc về một hóa đơn (Dùng khi khách hàng hủy thanh toán)
    void deleteByInvoice_InvoiceId(UUID invoiceId);

    // 4. Custom query lấy tên ghế từ bảng ShowtimeSeat (Ví dụ: "A1", "A2")
    @Query("SELECT bs.showtimeSeat.seat.seatNumber FROM BookingSeat bs WHERE bs.invoice.invoiceId = :invoiceId")
    List<String> findSeatNumbersByInvoiceId(@Param("invoiceId") UUID invoiceId);
}