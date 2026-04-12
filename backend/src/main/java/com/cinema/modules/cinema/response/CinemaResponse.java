package com.cinema.modules.cinema.response;

import lombok.Data;

import java.util.List;

@Data
public class CinemaResponse {
    private Long cinemasId;
    private String cinemaName;
    private String address;
    private String imageUrl;
    private String mapUrl;
    private String hotline;
    private String provinceName; // Phẳng hóa dữ liệu để FE dễ hiển thị
    // Danh sách các loại phòng hiện có (Ví dụ: ["IMAX", "4DX", "Dolby Atmos"])
    private List<String> screeningTypes;
}
