package com.cinema.modules.showtime.controller;

import com.cinema.modules.showtime.dto.ShowtimeRequest;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.sql.Date;
import java.sql.Time;
import java.time.LocalTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/showtimes")
public class AdminShowtimeController {
    private final JdbcTemplate jdbcTemplate;

    public AdminShowtimeController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> getAll() {
        return ResponseEntity.ok(findShowtimes(null));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getById(@PathVariable Long id) {
        List<Map<String, Object>> rows = findShowtimes(id);
        return rows.isEmpty()
                ? ResponseEntity.notFound().build()
                : ResponseEntity.ok(rows.get(0));
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody ShowtimeRequest request) {
        try {
            LocalTime endTime = resolveEndTime(request);
            Long showtimeId = jdbcTemplate.queryForObject(
                    "CALL sp_create_showtime(?, ?, ?, ?, ?)",
                    Long.class,
                    request.getMovieId(),
                    request.getRoomId(),
                    Date.valueOf(request.getShowDate()),
                    Time.valueOf(request.getStartTime()),
                    Time.valueOf(endTime)
            );

            List<Map<String, Object>> rows = findShowtimes(showtimeId);
            return rows.isEmpty()
                    ? ResponseEntity.status(HttpStatus.CREATED).body(Map.of("showtimeId", showtimeId))
                    : ResponseEntity.status(HttpStatus.CREATED).body(rows.get(0));
        } catch (DataAccessException ex) {
            return badRequest(ex);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody ShowtimeRequest request) {
        try {
            LocalTime endTime = resolveEndTime(request);
            jdbcTemplate.update(
                    "CALL sp_update_showtime(?, ?, ?, ?, ?, ?)",
                    id,
                    request.getMovieId(),
                    request.getRoomId(),
                    Date.valueOf(request.getShowDate()),
                    Time.valueOf(request.getStartTime()),
                    Time.valueOf(endTime)
            );

            List<Map<String, Object>> rows = findShowtimes(id);
            return rows.isEmpty()
                    ? ResponseEntity.notFound().build()
                    : ResponseEntity.ok(rows.get(0));
        } catch (DataAccessException ex) {
            return badRequest(ex);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            jdbcTemplate.update("CALL sp_delete_showtime(?)", id);
        } catch (DataAccessException ex) {
            return badRequest(ex);
        }
        return ResponseEntity.noContent().build();
    }

    private LocalTime resolveEndTime(ShowtimeRequest request) {
        if (request.getMovieId() == null || request.getRoomId() == null
                || request.getShowDate() == null || request.getStartTime() == null) {
            throw new IllegalArgumentException("Thieu thong tin bat buoc de tao suat chieu");
        }

        if (request.getEndTime() != null) {
            return request.getEndTime();
        }

        Integer duration = jdbcTemplate.queryForObject(
                "SELECT duration FROM movie WHERE movie_id = ?",
                Integer.class,
                request.getMovieId()
        );

        if (duration == null) {
            throw new IllegalArgumentException("Khong tim thay thoi luong phim");
        }

        return request.getStartTime().plusMinutes(duration);
    }

    private List<Map<String, Object>> findShowtimes(Long id) {
        String whereClause = id == null ? "" : "WHERE st.showtime_id = ?";
        String sql = """
                SELECT st.showtime_id,
                       st.show_date,
                       TIME_FORMAT(st.start_time, '%%H:%%i') AS start_time,
                       TIME_FORMAT(st.end_time, '%%H:%%i') AS end_time,
                       m.movie_id,
                       m.title,
                       m.poster_link,
                       m.duration,
                       r.room_id,
                       r.room_name,
                       sf.type AS room_type,
                       sf.price AS base_price,
                       c.cinemas_id,
                       c.cinema_name,
                       CASE
                           WHEN TIMESTAMP(st.show_date, st.end_time) < NOW() THEN 'ENDED'
                           ELSE 'NOW_SHOWING'
                       END AS status
                FROM showtime st
                JOIN movie m ON m.movie_id = st.movie_id
                JOIN room r ON r.room_id = st.room_id
                JOIN cinemas c ON c.cinemas_id = r.cinemas_id
                LEFT JOIN screening_format sf ON sf.screening_format_id = r.screening_format_id
                %s
                ORDER BY st.show_date DESC, st.start_time DESC, st.showtime_id DESC
                """.formatted(whereClause);

        Object[] args = id == null ? new Object[]{} : new Object[]{id};
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Map<String, Object> movie = new LinkedHashMap<>();
            movie.put("id", rs.getLong("movie_id"));
            movie.put("title", rs.getString("title"));
            movie.put("posterLink", rs.getString("poster_link"));
            movie.put("duration", rs.getInt("duration"));

            Map<String, Object> cinema = new LinkedHashMap<>();
            cinema.put("cinemasId", rs.getLong("cinemas_id"));
            cinema.put("cinemaName", rs.getString("cinema_name"));

            Map<String, Object> room = new LinkedHashMap<>();
            room.put("roomId", rs.getLong("room_id"));
            room.put("roomName", rs.getString("room_name"));
            room.put("roomType", rs.getString("room_type"));
            room.put("cinema", cinema);

            Map<String, Object> showtime = new LinkedHashMap<>();
            showtime.put("showtimeId", rs.getLong("showtime_id"));
            showtime.put("showDate", rs.getDate("show_date").toLocalDate().toString());
            showtime.put("startTime", rs.getString("start_time"));
            showtime.put("endTime", rs.getString("end_time"));
            showtime.put("basePrice", rs.getBigDecimal("base_price"));
            showtime.put("status", rs.getString("status"));
            showtime.put("movie", movie);
            showtime.put("room", room);
            return showtime;
        }, args);
    }

    private ResponseEntity<Map<String, String>> badRequest(DataAccessException ex) {
        String message = ex.getMostSpecificCause() != null
                ? ex.getMostSpecificCause().getMessage()
                : ex.getMessage();
        return ResponseEntity.badRequest().body(Map.of("message", message));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Map<String, String>> badRequest(IllegalArgumentException ex) {
        return ResponseEntity.badRequest().body(Map.of("message", ex.getMessage()));
    }
}
