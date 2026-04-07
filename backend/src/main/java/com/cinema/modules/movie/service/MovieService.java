package com.cinema.modules.movie.service;

import com.cinema.modules.movie.response.MovieResponse;

import javax.print.DocFlavor;
import java.util.List;

public interface MovieService {
    List<MovieResponse> getMoviesByStatus(String status);
    List<MovieResponse> getNowShowing();
    List<MovieResponse> getComingSoon();

    MovieResponse getMovieById(Long id);
}