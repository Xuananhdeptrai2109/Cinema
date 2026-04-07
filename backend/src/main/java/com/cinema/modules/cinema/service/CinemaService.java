package com.cinema.modules.cinema.service;

import com.cinema.modules.cinema.entity.Cinema;
import com.cinema.modules.cinema.response.CinemaResponse;
import com.cinema.modules.cinema.response.ProvinceResponse;
import java.util.List;

public interface CinemaService {
    // Trả về danh sách Tỉnh/Thành, mỗi Tỉnh chứa danh sách Rạp của nó
    List<ProvinceResponse> getAllLocationsWithCinemas();

    List<CinemaResponse> getCinemasResponseByProvinceName(String cityName);
}