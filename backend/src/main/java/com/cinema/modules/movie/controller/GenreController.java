package com.cinema.modules.movie.controller;

import com.cinema.modules.movie.repository.GenreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/genres")
@CrossOrigin(origins = "http://localhost:63342")
public class GenreController {
    @Autowired
    private GenreRepository genreRepository;

    @GetMapping("/all")
    public List<String> getAllGenres() {
        return genreRepository.findAllGenreNames();
    }
}
