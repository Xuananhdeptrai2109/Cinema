package com.cinema.modules.movie.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "genre")
@Getter
@Setter
public class Genre {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "genre_id")
    private Long id;

    @Column(name = "genre_name")
    private String genreName;

    @ManyToMany(mappedBy = "genres") // Phải khớp với tên biến 'genres' bên lớp Movie
    private Set<Movie> movies = new HashSet<>();
}