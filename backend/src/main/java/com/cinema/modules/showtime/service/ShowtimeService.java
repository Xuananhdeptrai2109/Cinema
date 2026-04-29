package com.cinema.modules.showtime.service;

import com.cinema.modules.showtime.response.ShowtimeResponse;
import java.util.List;

public interface ShowtimeService {
    // Lấy danh sách suất chiếu cho trang chọn ghế
    List<ShowtimeResponse> getShowtimesByCinemaAndDate(Long cinemaId, String date);

    // BỔ SUNG: Lấy chi tiết 1 suất chiếu cho trang thanh toán
    ShowtimeResponse getShowtimeById(Long id);
}