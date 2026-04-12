package com.cinema.modules.movie.repository;

import com.cinema.modules.movie.entity.Genre;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GenreRepository extends JpaRepository<Genre, Long> {
    // Truy vấn lấy danh sách tên thể loại duy nhất
    @Query("SELECT DISTINCT g.genreName FROM Genre g")
    List<String> findAllGenreNames();
}
