package com.cinema.modules.movie.service;
 
import com.cinema.modules.movie.dto.MovieRequest;
import com.cinema.modules.movie.response.MovieResponse;
 
import java.util.List;
 
public interface MovieService {
    List<MovieResponse> getMoviesByStatus(String status);
    List<MovieResponse> getNowShowing();
    List<MovieResponse> getComingSoon();
    MovieResponse getMovieById(Long id);
 
    // ── Admin methods ──────────────────────────
    List<MovieResponse> getAllMovies();
    MovieResponse createMovie(MovieRequest request);
    MovieResponse updateMovie(Long id, MovieRequest request);
    void deleteMovie(Long id);
}
 