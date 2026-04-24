package com.cinema.modules.movie.dto;

import lombok.Data;

@Data
public class CommentRequest {
    private Long movieId;
    private String content;
    private String imageUrl; // Nhận chuỗi ảnh Base64
    private Integer starRating;
}