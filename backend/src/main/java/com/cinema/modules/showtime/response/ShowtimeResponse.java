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
    private List<String> genres;
    private List<RoomTypeGroup> typeGroups;

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class RoomTypeGroup {
        private String formatName;
        private List<RoomDetail> rooms;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class RoomDetail {
        private String roomName;
        private List<TimeDetail> times;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class TimeDetail {
        private Long showtimeId;
        private String time;
        private Integer seats;
    }
}