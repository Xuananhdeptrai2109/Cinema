package com.cinema.modules.showtime.service;

import com.cinema.modules.movie.entity.Movie;
import com.cinema.modules.showtime.entity.Showtime;
import com.cinema.modules.showtime.repository.ShowtimeRepository;
import com.cinema.modules.showtime.response.ShowtimeDetailResponse;
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

    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

    @Override
    @Transactional(readOnly = true)
    public List<ShowtimeResponse> getShowtimesByCinemaAndDate(Long cinemaId, String date) {
        LocalDate showDate = LocalDate.parse(date);
        List<Showtime> allShowtimes = showtimeRepository.findByCinemaAndDate(cinemaId, showDate);

        return allShowtimes.stream()
                .collect(Collectors.groupingBy(s -> s.getMovie().getId())) // ✅ Sửa: group by movie ID (Long) thay vì Movie object
                .entrySet().stream()
                .map(movieEntry -> {
                    List<Showtime> movieSchedules = movieEntry.getValue();
                    Movie movie = movieSchedules.get(0).getMovie(); // ✅ Lấy movie từ list

                    List<ShowtimeResponse.RoomTypeGroup> typeGroups = movieSchedules.stream()
                            .collect(Collectors.groupingBy(s -> s.getRoom().getScreeningFormat().getType()))
                            .entrySet().stream()
                            .map(typeEntry -> {
                                String formatType = typeEntry.getKey();
                                List<Showtime> typeSchedules = typeEntry.getValue();

                                List<ShowtimeResponse.RoomDetail> roomDetails = typeSchedules.stream()
                                        .collect(Collectors.groupingBy(s -> s.getRoom().getRoomName()))
                                        .entrySet().stream()
                                        .map(roomEntry -> {
                                            String roomName = roomEntry.getKey();
                                            List<ShowtimeResponse.TimeDetail> times = roomEntry.getValue().stream()
                                                    .map(s -> new ShowtimeResponse.TimeDetail(
                                                            s.getShowtimeId(),
                                                            s.getStartTime().format(TIME_FORMATTER),
                                                            100
                                                    ))
                                                    .collect(Collectors.toList());
                                            return new ShowtimeResponse.RoomDetail(roomName, times);
                                        }).collect(Collectors.toList());

                                return new ShowtimeResponse.RoomTypeGroup(formatType, roomDetails);
                            }).collect(Collectors.toList());

                    return new ShowtimeResponse(
                            movie.getId(),
                            movie.getTitle(),
                            movie.getPosterLink(),
                            movie.getDuration(),
                            movie.getAgeRating(),
                            movie.getGenres().stream()
                                    .map(g -> g.getGenreName())
                                    .collect(Collectors.toList()),
                            typeGroups
                    );
                }).collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public ShowtimeResponse getShowtimeById(Long id) {
        // 1. Tìm suất chiếu trong DB
        Showtime showtime = showtimeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy suất chiếu ID: " + id));

        Movie movie = showtime.getMovie();

        // 2. Tạo chi tiết giờ chiếu cho suất chiếu này
        ShowtimeResponse.TimeDetail timeDetail = new ShowtimeResponse.TimeDetail(
                showtime.getShowtimeId(),
                showtime.getStartTime().format(TIME_FORMATTER),
                100 // Số ghế trống mặc định hoặc lấy từ logic đếm ghế
        );

        // 3. Tạo chi tiết phòng chiếu
        ShowtimeResponse.RoomDetail roomDetail = new ShowtimeResponse.RoomDetail(
                showtime.getRoom().getRoomName(),
                List.of(timeDetail)
        );

        // 4. Tạo nhóm định dạng (2D/3D...)
        ShowtimeResponse.RoomTypeGroup typeGroup = new ShowtimeResponse.RoomTypeGroup(
                showtime.getRoom().getScreeningFormat().getType(),
                List.of(roomDetail)
        );

        // 5. Trả về Response chứa thông tin phim và duy nhất suất chiếu đã chọn
        return new ShowtimeResponse(
                movie.getId(),
                movie.getTitle(),
                movie.getPosterLink(),
                movie.getDuration(),
                movie.getAgeRating(),
                movie.getGenres().stream()
                        .map(g -> g.getGenreName())
                        .collect(Collectors.toList()),
                List.of(typeGroup)
        );
    }
}