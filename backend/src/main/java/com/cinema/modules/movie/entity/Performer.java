package com.cinema.modules.movie.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Performer")
@Getter
@Setter
public class Performer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "performer_id")
    private Long id;

    @Column(name = "performer_name")
    private String performerName;

    @ManyToMany(mappedBy = "performers") // Phải khớp với tên biến tập hợp performers trong lớp Movie
    private Set<Movie> movies = new HashSet<>();
}