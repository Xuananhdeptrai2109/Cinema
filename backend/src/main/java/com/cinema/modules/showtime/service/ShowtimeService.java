package com.cinema.modules.showtime.service;

import com.cinema.modules.showtime.response.ShowtimeDetailResponse;
import com.cinema.modules.showtime.response.ShowtimeResponse;
import java.util.List;

public interface ShowtimeService {
    List<ShowtimeResponse> getShowtimesByCinemaAndDate(Long cinemaId, String date);
    ShowtimeDetailResponse getShowtimeById(Long showtimeId);

    
}