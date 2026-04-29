package com.cinema.modules.showtime.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ShowtimeDetailResponse {
    private Long showtimeId;
    private String startTime;
    private String endTime;
    private String showDate;
    private String roomName;
    private String roomType;
    private String cinemaName;

    // Thông tin phim
    private Long movieId;
    private String movieName;
    private String posterUrl;
    private Integer duration;
    private String ageRating;
    private String genre;
}