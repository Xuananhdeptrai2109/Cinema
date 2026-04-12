package com.cinema.modules.booking.repository; // Kiểm tra lại package xem là .seat hay .booking

import com.cinema.modules.seat.entity.ShowtimeSeat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ShowtimeSeatRepository extends JpaRepository<ShowtimeSeat, Long> {

    // 1. Lấy tất cả ghế của một suất chiếu cụ thể
    List<ShowtimeSeat> findByShowtime_ShowtimeId(Long showtimeId);

    // 2. Tìm một ghế cụ thể dựa trên ID suất chiếu và ID ghế (để kiểm tra trước khi đặt)
    @Query("SELECT ss FROM ShowtimeSeat ss WHERE ss.showtime.showtimeId = :showtimeId AND ss.seat.seatId = :seatId")
    ShowtimeSeat findByShowtimeAndSeat(@Param("showtimeId") Long showtimeId, @Param("seatId") Long seatId);

    // 3. Tìm danh sách ghế theo trạng thái (VD: lấy các ghế đang trống - 'available')
    List<ShowtimeSeat> findByShowtime_ShowtimeIdAndStatus(Long showtimeId, String status);
}