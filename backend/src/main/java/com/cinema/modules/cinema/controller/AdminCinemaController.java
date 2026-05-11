package com.cinema.modules.cinema.controller;

import com.cinema.modules.cinema.entity.Cinema;
import com.cinema.modules.cinema.entity.ProvinceCity;
import com.cinema.modules.cinema.repository.CinemaRepository;
import com.cinema.modules.cinema.repository.ProvinceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/cinemas")
public class AdminCinemaController {

    @Autowired private CinemaRepository cinemaRepository;
    @Autowired private ProvinceRepository provinceRepository;

    // GET all — trả về Cinema kèm province
    @GetMapping
    public ResponseEntity<List<Cinema>> getAll() {
        // Bật eager load province trong entity hoặc dùng @EntityGraph
        List<Cinema> cinemas = cinemaRepository.findAll();
        // Trigger lazy load province để tránh lỗi serialize
        cinemas.forEach(c -> {
            if (c.getProvince() != null) c.getProvince().getProvinceId();
        });
        return ResponseEntity.ok(cinemas);
    }

    // GET by ID
    @GetMapping("/{id}")
    public ResponseEntity<Cinema> getById(@PathVariable Long id) {
        return cinemaRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // POST create
    @PostMapping
    public ResponseEntity<Cinema> create(@RequestBody Map<String, Object> body) {
        Cinema cinema = new Cinema();
        cinema.setCinemaName((String) body.get("cinemaName"));
        cinema.setAddress((String) body.get("address"));
        cinema.setHotline((String) body.get("hotline"));
        cinema.setFax((String) body.get("fax"));
        cinema.setImageUrl((String) body.get("imageUrl"));
        cinema.setMapUrl((String) body.get("mapUrl"));

        Object provinceIdObj = body.get("provinceId");
        if (provinceIdObj != null) {
            Long provinceId = Long.valueOf(provinceIdObj.toString());
            ProvinceCity province = provinceRepository.findById(provinceId).orElse(null);
            cinema.setProvince(province);
        }
        return ResponseEntity.ok(cinemaRepository.save(cinema));
    }

    // PUT update
    @PutMapping("/{id}")
    public ResponseEntity<Cinema> update(@PathVariable Long id, @RequestBody Map<String, Object> body) {
        Cinema cinema = cinemaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy rạp ID: " + id));

        if (body.containsKey("cinemaName")) cinema.setCinemaName((String) body.get("cinemaName"));
        if (body.containsKey("address"))    cinema.setAddress((String) body.get("address"));
        if (body.containsKey("hotline"))    cinema.setHotline((String) body.get("hotline"));
        if (body.containsKey("fax"))        cinema.setFax((String) body.get("fax"));
        if (body.containsKey("imageUrl"))   cinema.setImageUrl((String) body.get("imageUrl"));
        if (body.containsKey("mapUrl"))     cinema.setMapUrl((String) body.get("mapUrl"));

        Object provinceIdObj = body.get("provinceId");
        if (provinceIdObj != null) {
            Long provinceId = Long.valueOf(provinceIdObj.toString());
            ProvinceCity province = provinceRepository.findById(provinceId).orElse(null);
            cinema.setProvince(province);
        }
        return ResponseEntity.ok(cinemaRepository.save(cinema));
    }

    // DELETE
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        cinemaRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}