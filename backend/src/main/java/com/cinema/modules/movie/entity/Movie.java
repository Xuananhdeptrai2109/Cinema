package com.cinema.modules.movie.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Movie")
@Getter
@Setter
public class Movie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "movie_id")
    private Long id;

    private String title;

    @Column(name = "poster_link") // Ánh xạ đúng cột poster_link trong DB
    private String posterLink;

    private String language;

    private String description;

    @Column(name = "release_date")
    private String releaseDate;

    private Integer duration;

    @Column(name = "age_rating")
    private String ageRating;

    @Column(name = "trailer_link")
    private String trailerLink;

    private String status;

    @Column(name = "star")
    private Double star;

    @ManyToOne
    @JoinColumn(name = "director_id")
    private Director director;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "Movie_genre", // Tên bảng trung gian trong DB
            joinColumns = @JoinColumn(name = "movie_id"), // Khóa ngoại trỏ về Movie
            inverseJoinColumns = @JoinColumn(name = "genre_id") // Khóa ngoại trỏ về Genre
    )
    private Set<Genre> genres = new HashSet<>();

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "Movie_cast", // Tên bảng trung gian trong DB
            joinColumns = @JoinColumn(name = "movie_id"),
            inverseJoinColumns = @JoinColumn(name = "performer_id")
    )
    private Set<Performer> performers = new HashSet<>();
}