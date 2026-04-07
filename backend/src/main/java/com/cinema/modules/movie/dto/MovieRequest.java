package com.cinema.modules.movie.dto;

import lombok.Data;
import java.time.LocalDate;
import java.util.List;

@Data
public class MovieRequest {
    private Long id;
    private String title;
    private String posterLink;
    private String language;
    private String description;
    private String releaseDate;
    private Integer duration; // Kiểm tra xem đã có dòng này chưa
    private String ageRating;
    private String trailerLink;
    private String status;
    private Double star;
    private String director;
    private List<String> genreNames;
    private List<String> performerNames;
}