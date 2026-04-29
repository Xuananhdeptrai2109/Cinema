package com.cinema.modules.auth.response;

public class AuthResponse {
    private String token;
    private String message;
    private Long userId;
    private String username;

    public AuthResponse(String token, String message, Long userId, String username) {
        this.token = token;
        this.message = message;
        this.userId = userId;
        this.username = username;
    }

    // Giữ constructor cũ cho resetPassword (không cần userId)
    public AuthResponse(String token, String message) {
        this.token = token;
        this.message = message;
    }

    public String getToken() { return token; }
    public String getMessage() { return message; }
    public Long getUserId() { return userId; }
    public String getUsername() { return username; }
    public void setToken(String token) { this.token = token; }
    public void setMessage(String message) { this.message = message; }
    public void setUserId(Long userId) { this.userId = userId; }
    public void setUsername(String username) { this.username = username; }
}