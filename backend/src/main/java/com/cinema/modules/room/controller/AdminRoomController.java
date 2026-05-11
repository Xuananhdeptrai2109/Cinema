package com.cinema.modules.room.controller;

import com.cinema.modules.cinema.entity.Cinema;
import com.cinema.modules.cinema.repository.CinemaRepository;
import com.cinema.modules.room.entity.Room;
import com.cinema.modules.room.repository.RoomRepository;
import com.cinema.modules.room.repository.ScreeningFormatRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/rooms")
public class AdminRoomController {
    private final RoomRepository roomRepository;
    private final CinemaRepository cinemaRepository;
    private final ScreeningFormatRepository screeningFormatRepository;
    private final NamedParameterJdbcTemplate jdbc;

    public AdminRoomController(
            RoomRepository roomRepository,
            CinemaRepository cinemaRepository,
            ScreeningFormatRepository screeningFormatRepository,
            NamedParameterJdbcTemplate jdbc
    ) {
        this.roomRepository = roomRepository;
        this.cinemaRepository = cinemaRepository;
        this.screeningFormatRepository = screeningFormatRepository;
        this.jdbc = jdbc;
    }

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> getAll() {
        List<Map<String, Object>> rows = jdbc.query("""
                SELECT r.room_id,
                       r.room_name,
                       COALESCE(r.capacity, 0) AS capacity,
                       COALESCE(r.status, 'active') AS status,
                       c.cinemas_id,
                       c.cinema_name,
                       sf.screening_format_id,
                       sf.type AS room_type
                FROM room r
                LEFT JOIN cinemas c ON c.cinemas_id = r.cinemas_id
                LEFT JOIN screening_format sf ON sf.screening_format_id = r.screening_format_id
                ORDER BY r.room_id DESC
                """, Collections.emptyMap(), (rs, rowNum) -> {
            Map<String, Object> response = new LinkedHashMap<>();
            response.put("roomId", rs.getLong("room_id"));
            response.put("roomName", rs.getString("room_name"));
            response.put("capacity", rs.getInt("capacity"));
            response.put("status", rs.getString("status"));
            response.put("roomType", rs.getString("room_type") == null ? "" : rs.getString("room_type"));

            Map<String, Object> screeningFormat = new LinkedHashMap<>();
            screeningFormat.put("screeningFormatId", rs.getLong("screening_format_id"));
            screeningFormat.put("type", rs.getString("room_type"));
            response.put("screeningFormat", screeningFormat);

            Map<String, Object> cinema = new LinkedHashMap<>();
            cinema.put("cinemasId", rs.getLong("cinemas_id"));
            cinema.put("cinemaName", rs.getString("cinema_name"));
            response.put("cinema", cinema);
            return response;
        });
        return ResponseEntity.ok(rows);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getById(@PathVariable Long id) {
        return roomRepository.findById(id)
                .map(room -> ResponseEntity.ok(toResponse(room)))
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> create(@RequestBody Map<String, Object> request) {
        Room room = buildRoom(new Room(), request);
        return ResponseEntity.ok(toResponse(roomRepository.save(room)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> update(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        Room room = roomRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay phong chieu voi ID: " + id));
        buildRoom(room, request);
        return ResponseEntity.ok(toResponse(roomRepository.save(room)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        roomRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    private Room buildRoom(Room room, Map<String, Object> request) {
        room.setRoomName(asString(request.get("roomName")));
        room.setStatus(asStringOrDefault(request.get("status"), "active"));
        room.setCapacity(asInteger(request.get("capacity")));

        Long cinemasId = asLong(request.get("cinemasId"));
        Cinema cinema = cinemaRepository.findById(cinemasId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay rap voi ID: " + cinemasId));
        room.setCinema(cinema);

        String roomType = asString(request.get("roomType"));
        room.setScreeningFormat(screeningFormatRepository.findByType(roomType)
                .orElseThrow(() -> new RuntimeException("Khong tim thay dinh dang chieu: " + roomType)));

        return room;
    }

    private String asString(Object value) {
        if (value == null || value.toString().isBlank()) {
            throw new RuntimeException("Du lieu phong chieu khong hop le");
        }
        return value.toString();
    }

    private String asStringOrDefault(Object value, String defaultValue) {
        return value == null || value.toString().isBlank() ? defaultValue : value.toString();
    }

    private Long asLong(Object value) {
        if (value instanceof Number number) return number.longValue();
        if (value == null || value.toString().isBlank()) {
            throw new RuntimeException("Thieu ID rap chieu");
        }
        return Long.parseLong(value.toString());
    }

    private Integer asInteger(Object value) {
        if (value instanceof Number number) return number.intValue();
        if (value == null || value.toString().isBlank()) return null;
        return Integer.parseInt(value.toString());
    }

    private Map<String, Object> toResponse(Room room) {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("roomId", room.getRoomId());
        response.put("roomName", room.getRoomName());
        response.put("capacity", room.getCapacity() == null ? 0 : room.getCapacity());
        response.put("status", room.getStatus() == null ? "active" : room.getStatus());
        response.put("roomType", room.getScreeningFormat() == null ? "" : room.getScreeningFormat().getType());

        Map<String, Object> screeningFormat = new LinkedHashMap<>();
        if (room.getScreeningFormat() != null) {
            screeningFormat.put("screeningFormatId", room.getScreeningFormat().getScreeningFormatId());
            screeningFormat.put("type", room.getScreeningFormat().getType());
        }
        response.put("screeningFormat", screeningFormat);

        Map<String, Object> cinema = new LinkedHashMap<>();
        if (room.getCinema() != null) {
            cinema.put("cinemasId", room.getCinema().getCinemasId());
            cinema.put("cinemaName", room.getCinema().getCinemaName());
        }
        response.put("cinema", cinema);

        return response;
    }
}
