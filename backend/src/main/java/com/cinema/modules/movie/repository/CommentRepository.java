package com.cinema.modules.movie.repository;

import com.cinema.modules.movie.entity.MovieComment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<MovieComment, Long> {
    // Lấy tất cả bình luận của một phim, sắp xếp mới nhất lên đầu
    List<MovieComment> findByMovie_IdOrderByCreatedAtDesc(Long movieId);
}