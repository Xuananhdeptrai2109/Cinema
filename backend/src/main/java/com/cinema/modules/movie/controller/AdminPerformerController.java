package com.cinema.modules.movie.controller;

import com.cinema.modules.movie.entity.Performer;
import com.cinema.modules.movie.repository.PerformerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/performers")
@CrossOrigin(origins = {"http://localhost:5173", "http://localhost:3000"})
public class AdminPerformerController {

    @Autowired
    private PerformerRepository performerRepository;

    @GetMapping
    public ResponseEntity<List<Performer>> getAllPerformers() {
        return ResponseEntity.ok(performerRepository.findAll());
    }

    @PostMapping
    public ResponseEntity<Performer> createPerformer(@RequestBody Map<String, String> body) {
        Performer performer = new Performer();
        performer.setPerformerName(body.get("performerName"));
        return ResponseEntity.ok(performerRepository.save(performer));
    }
}
