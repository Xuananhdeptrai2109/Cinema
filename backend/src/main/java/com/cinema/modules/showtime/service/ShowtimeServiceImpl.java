package com.cinema.modules.showtime.service;

import com.cinema.modules.movie.entity.Movie;
import com.cinema.modules.showtime.entity.Showtime;
import com.cinema.modules.showtime.repository.ShowtimeRepository;
import com.cinema.modules.showtime.response.ShowtimeResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ShowtimeServiceImpl implements ShowtimeService {

    @Autowired
    private ShowtimeRepository showtimeRepository;

    // Định dạng giờ để tránh lỗi substring nếu dữ liệu thời gian không đồng nhất
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

    @Override
    @Transactional(readOnly = true)
    public List<ShowtimeResponse> getShowtimesByCinemaAndDate(Long cinemaId, String date) {
        // 1. Chuyển đổi String sang LocalDate an toàn
        LocalDate showDate = LocalDate.parse(date);

        // 2. Lấy dữ liệu từ Repository (Đã JOIN qua Room -> Cinema)
        List<Showtime> allShowtimes = showtimeRepository.findByCinemaAndDate(cinemaId, showDate);

        // 3. Nhóm dữ liệu theo cấu trúc 3 tầng: Phim -> Định dạng (2D/3D) -> Phòng
        return allShowtimes.stream()
                .collect(Collectors.groupingBy(Showtime::getMovie)) // Tầng 1: Movie
                .entrySet().stream()
                .map(movieEntry -> {
                    Movie movie = movieEntry.getKey();
                    List<Showtime> movieSchedules = movieEntry.getValue();

                    // Tầng 2: Nhóm theo Loại phòng (IMAX, 2D, 3D...) lấy từ ScreeningFormat
                    List<ShowtimeResponse.RoomTypeGroup> typeGroups = movieSchedules.stream()
                            .collect(Collectors.groupingBy(s -> s.getRoom().getScreeningFormat().getType()))
                            .entrySet().stream()
                            .map(typeEntry -> {
                                String formatType = typeEntry.getKey();
                                List<Showtime> typeSchedules = typeEntry.getValue();

                                // Tầng 3: Nhóm theo Tên phòng (Phòng A, Phòng B...)
                                List<ShowtimeResponse.RoomDetail> roomDetails = typeSchedules.stream()
                                        .collect(Collectors.groupingBy(s -> s.getRoom().getRoomName()))
                                        .entrySet().stream()
                                        .map(roomEntry -> {
                                            String roomName = roomEntry.getKey();

                                            // Tầng 4: Danh sách giờ chiếu (TimeDetail)
                                            List<ShowtimeResponse.TimeDetail> times = roomEntry.getValue().stream()
                                                    .map(s -> new ShowtimeResponse.TimeDetail(
                                                            s.getShowtimeId(), // LẤY ID TỪ ENTITY SHOWTIME
                                                            s.getStartTime().format(TIME_FORMATTER),
                                                            100
                                                    ))
                                                    .collect(Collectors.toList());

                                            return new ShowtimeResponse.RoomDetail(roomName, times);
                                        }).collect(Collectors.toList());

                                return new ShowtimeResponse.RoomTypeGroup(formatType, roomDetails);
                            }).collect(Collectors.toList());

                    // Trả về Response cuối cùng cho mỗi phim
                    return new ShowtimeResponse(
                            movie.getId(),
                            movie.getTitle(),
                            movie.getPosterLink(),
                            movie.getDuration(),
                            movie.getAgeRating(),
                            movie.getGenres().stream()
                                    .map(g -> g.getGenreName()) // Lấy tên thể loại từ bảng Genre
                                    .collect(Collectors.toList()),
                            typeGroups
                    );
                }).collect(Collectors.toList());
    }
}