package com.cinema.modules.home.service;
import com.cinema.modules.home.dto.HomeResponse;
import com.cinema.modules.showtime.response.ShowtimeResponse;
import java.util.List;

public interface HomeService {
    // 1. Lấy toàn bộ dữ liệu khởi tạo cho trang chủ (Phim, Rạp, Khuyến mãi)
    HomeResponse getHomeData();

    // 2. (Nâng cao) Lọc suất chiếu khi người dùng chọn nhanh Phim + Rạp
    List<ShowtimeResponse> getQuickBookingInfo(Long movieId, Long cinemaId);
}