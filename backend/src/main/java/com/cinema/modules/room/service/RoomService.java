package com.cinema.modules.room.service;

import java.util.List;

public interface RoomService {
    // Lấy danh sách các loại hình chiếu duy nhất của một rạp
    List<String> getScreeningTypesByCinema(Long cinemaId);
}
