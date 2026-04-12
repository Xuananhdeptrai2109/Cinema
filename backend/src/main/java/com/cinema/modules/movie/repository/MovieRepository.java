package com.cinema.modules.movie.repository;

import com.cinema.modules.movie.entity.Movie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface MovieRepository extends JpaRepository<Movie, Long> {
    // Tự động tạo: SELECT * FROM Movie WHERE status = ?
    List<Movie> findByStatus(String status);
}