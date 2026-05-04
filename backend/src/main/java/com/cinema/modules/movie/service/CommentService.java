package com.cinema.modules.movie.service;

import com.cinema.modules.movie.dto.CommentRequest;
import com.cinema.modules.movie.entity.Movie;
import com.cinema.modules.movie.entity.MovieComment;
import com.cinema.modules.movie.repository.CommentRepository;
import com.cinema.modules.movie.repository.MovieRepository;
import com.cinema.modules.movie.response.CommentResponse;
import com.cinema.modules.user.entity.User;
import com.cinema.modules.user.repository.UserRepository;
import lombok.extern.slf4j.Slf4j; // Thêm để logging
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j // Tự động tạo logger
public class CommentService {

    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private MovieRepository movieRepository;

    @Transactional
    public CommentResponse saveComment(String email, CommentRequest request) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User không tồn tại"));

        Movie movie = movieRepository.findById(request.getMovieId())
                .orElseThrow(() -> new RuntimeException("Phim không tồn tại"));

        // CHẶN: Chỉ cho phép đánh giá nếu trạng thái phim là "showing"
        if (!"showing".equalsIgnoreCase(movie.getStatus())) {
            throw new RuntimeException("Chương trình đánh giá chỉ áp dụng cho phim đang chiếu.");
        }

        // 1. Khởi tạo và gán giá trị thủ công để đảm bảo không mất dữ liệu
        MovieComment comment = new MovieComment();
        comment.setUser(user);
        comment.setMovie(movie);
        comment.setContent(request.getContent()); // Nếu cái này null, DB sẽ lưu null
        comment.setStarRating(request.getStarRating());
        comment.setImageUrl(request.getImageUrl());
        comment.setCreatedAt(LocalDateTime.now());

        commentRepository.save(comment);
        updateMovieAverageStar(movie);
        return new CommentResponse(comment);
    }

    private void updateMovieAverageStar(Movie movie) {
        List<MovieComment> allComments = commentRepository.findByMovie_IdOrderByCreatedAtDesc(movie.getId());

        if (allComments.isEmpty()) {
            movie.setStar(0.0);
        } else {
            double averageStar = allComments.stream()
                    .mapToInt(MovieComment::getStarRating)
                    .average()
                    .orElse(0.0);

            // Làm tròn 1 chữ số thập phân
            movie.setStar((double) Math.round(averageStar * 10) / 10);
        }
        movieRepository.save(movie);
    }

    public List<CommentResponse> getCommentsByMovie(Long movieId) {
        return commentRepository.findByMovie_IdOrderByCreatedAtDesc(movieId)
                .stream()
                .map(CommentResponse::new)
                .collect(Collectors.toList());
    }
}