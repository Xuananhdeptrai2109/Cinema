package com.cinema.modules.seat.repository;

import com.cinema.modules.seat.entity.ShowtimeSeat;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface SeatRepository extends JpaRepository<ShowtimeSeat, Long> {
    // Sử dụng tên thuộc tính chính xác của Showtime (Showtime.showtimeId)
    List<ShowtimeSeat> findByShowtime_ShowtimeId(Long showtimeId);
}