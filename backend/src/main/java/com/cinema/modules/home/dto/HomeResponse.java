package com.cinema.modules.home.dto;

import com.cinema.modules.cinema.response.CinemaResponse;
import com.cinema.modules.cinema.response.ProvinceResponse;
import com.cinema.modules.discount.response.DiscountResponse;
import com.cinema.modules.movie.response.MovieResponse;
import com.cinema.modules.user.response.UserResponse;
import lombok.Data;
import java.util.List;

@Data
public class HomeResponse {
    // Phim đang chiếu & sắp chiếu (từ movie module)
    private List<MovieResponse> showingMovies;
    private List<MovieResponse> upcomingMovies;

    // Hệ thống rạp & Vị trí (từ cinema/room module)
    private List<ProvinceResponse> locations;

    // Ưu đãi & Khuyến mãi (từ discount module)
    private List<DiscountResponse> promotions;

    // Trạng thái người dùng (từ user/auth module)
    private UserResponse userStatus;
}