package com.cinema.modules.movie.response;

import com.cinema.modules.movie.entity.MovieComment;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CommentResponse {
    private String fullName;
    private String userName; // Biệt danh định danh theo yêu cầu
    private String content;
    private String imageUrl;
    private Integer starRating;
    private LocalDateTime createdAt;

    // Constructor nhanh để convert từ Entity
    public CommentResponse(MovieComment comment) {
        this.fullName = comment.getUser().getFullName();
        this.userName = comment.getUser().getUserName(); // Lấy từ cột username
        this.content = comment.getContent();
        this.imageUrl = comment.getImageUrl();
        this.starRating = comment.getStarRating();
        this.createdAt = comment.getCreatedAt();
    }
}