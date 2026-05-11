package com.cinema.modules.movie.controller;

import com.cinema.modules.movie.dto.MovieRequest;
import com.cinema.modules.movie.response.MovieResponse;
import com.cinema.modules.movie.service.MovieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/movies")
@CrossOrigin(origins = {"http://localhost:5173", "http://localhost:3000"})
public class AdminMovieController {

    @Autowired
    private MovieService movieService;

    // GET all movies (admin view - includes all statuses)
    @GetMapping
    public ResponseEntity<List<MovieResponse>> getAllMovies() {
        return ResponseEntity.ok(movieService.getAllMovies());
    }

    // POST create new movie
    @PostMapping
    public ResponseEntity<MovieResponse> createMovie(@RequestBody MovieRequest request) {
        return ResponseEntity.ok(movieService.createMovie(request));
    }

    // PUT update movie
    @PutMapping("/{id}")
    public ResponseEntity<MovieResponse> updateMovie(
            @PathVariable Long id,
            @RequestBody MovieRequest request) {
        return ResponseEntity.ok(movieService.updateMovie(id, request));
    }

    // DELETE movie
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMovie(@PathVariable Long id) {
        movieService.deleteMovie(id);
        return ResponseEntity.noContent().build();
    }
}
