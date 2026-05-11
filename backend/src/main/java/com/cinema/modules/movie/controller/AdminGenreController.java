package com.cinema.modules.movie.controller;

import com.cinema.modules.movie.entity.Genre;
import com.cinema.modules.movie.repository.GenreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/genres")
@CrossOrigin(origins = {"http://localhost:5173", "http://localhost:3000"})
public class AdminGenreController {

    @Autowired
    private GenreRepository genreRepository;

    @PostMapping
    public ResponseEntity<Genre> createGenre(@RequestBody Map<String, String> body) {
        Genre genre = new Genre();
        genre.setGenreName(body.get("genreName"));
        return ResponseEntity.ok(genreRepository.save(genre));
    }

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> getAllGenres() {
        List<Map<String, Object>> genres = genreRepository.findAll().stream()
                .map(genre -> Map.<String, Object>of(
                        "genreId", genre.getId(),
                        "genreName", genre.getGenreName()
                ))
                .toList();
        return ResponseEntity.ok(genres);
    }
}
