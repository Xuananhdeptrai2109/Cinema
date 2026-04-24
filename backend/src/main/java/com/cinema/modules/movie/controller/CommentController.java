package com.cinema.modules.movie.controller;

import com.cinema.modules.movie.dto.CommentRequest;
import com.cinema.modules.movie.response.CommentResponse;
import com.cinema.modules.movie.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/comments")
public class CommentController {

    @Autowired
    private CommentService commentService;

    // Gửi bình luận (Yêu cầu đăng nhập)
    @PostMapping
    public ResponseEntity<CommentResponse> createComment(@RequestBody CommentRequest request, Principal principal) {
        // principal.getName() trả về email từ JWT Token
        return ResponseEntity.ok(commentService.saveComment(principal.getName(), request));
    }

    // Lấy danh sách bình luận theo ID phim
    @GetMapping("/movie/{movieId}")
    public ResponseEntity<List<CommentResponse>> getComments(@PathVariable Long movieId) {
        return ResponseEntity.ok(commentService.getCommentsByMovie(movieId));
    }
}