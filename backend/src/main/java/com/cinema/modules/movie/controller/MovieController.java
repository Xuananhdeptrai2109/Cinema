package com.cinema.modules.movie.controller;

import com.cinema.modules.movie.response.MovieResponse;
import com.cinema.modules.movie.service.MovieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/movies")
@CrossOrigin(origins = "http://localhost:63342")
public class MovieController {

    @Autowired
    private MovieService movieService;

    @GetMapping("/home")
    public ResponseEntity<Map<String, List<MovieResponse>>> getHomeMovies() {
        Map<String, List<MovieResponse>> response = new HashMap<>();
        // Gọi thông qua Service Interface
        response.put("nowShowing", movieService.getNowShowing());
        response.put("comingSoon", movieService.getComingSoon());

        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<MovieResponse> getMovieDetail(@PathVariable Long id) {
        // Gọi service để lấy chi tiết 1 phim
        MovieResponse movie = movieService.getMovieById(id);
        return ResponseEntity.ok(movie);
    }
}
