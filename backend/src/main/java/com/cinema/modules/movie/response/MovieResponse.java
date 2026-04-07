package com.cinema.modules.movie.response;

import lombok.*;

import java.util.List;

@Data // Tự động tạo Getter, Setter, toString...
@AllArgsConstructor
@NoArgsConstructor
public class MovieResponse {
    private Long id;
    private String title;
    private String posterLink;
    private String language;
    private String description;
    private String releaseDate;
    private Integer duration;
    private String ageRating;
    private String trailerLink;
    private String status;
    private Double star;
    private String director;
    private List<String> genreNames;
    private List<String> performerNames;
}