package com.cinema.modules.showtime.response;

import lombok.*;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ShowtimeResponse {
    private Long id;
    private String title;
    private String img;
    private Integer duration;
    private String age;
    private List<String> genres; // Sửa từ 'genre' thành 'genres' (số nhiều) để khớp với Service
    private List<RoomTypeGroup> typeGroups; // Sửa từ 'rooms' thành 'typeGroups' để tránh nhầm lẫn

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class RoomTypeGroup {
        private String formatName; // Sửa từ 'type' thành 'formatName' để khớp với logic mapping
        private List<RoomDetail> rooms;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class RoomDetail {
        private String roomName; // Sửa từ 'name' thành 'roomName' để rõ nghĩa hơn
        private List<TimeDetail> times; // Sửa từ 'showtimes' thành 'times' để khớp với vòng lặp trong JS
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class TimeDetail {
        private String time;
        private Integer seats;
    }
}