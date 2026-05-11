package com.cinema.modules.movie.controller;

import com.cinema.modules.movie.entity.Director;
import com.cinema.modules.movie.repository.DirectorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/directors")
@CrossOrigin(origins = {"http://localhost:5173", "http://localhost:3000"})
public class AdminDirectorController {

    @Autowired
    private DirectorRepository directorRepository;

    @GetMapping
    public ResponseEntity<List<Director>> getAllDirectors() {
        return ResponseEntity.ok(directorRepository.findAll());
    }

    @PostMapping
    public ResponseEntity<Director> createDirector(@RequestBody Map<String, String> body) {
        Director director = new Director();
        director.setDirectorName(body.get("directorName"));
        return ResponseEntity.ok(directorRepository.save(director));
    }
}
