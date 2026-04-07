package com.cinema.modules.room.response;

import lombok.Data;

@Data
public class ScreeningFormatResponse {
    private String type;        // Để hiện text: "IMAX"
    private String description; // Hiện tooltip nếu cần
}