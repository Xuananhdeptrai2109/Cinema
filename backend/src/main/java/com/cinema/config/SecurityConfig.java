package com.cinema.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // 1. KÍCH HOẠT CORS VÀ TẮT CSRF
                .cors(cors -> cors.configurationSource(request -> {
                    var corsConfiguration = new org.springframework.web.cors.CorsConfiguration();
                    corsConfiguration.setAllowedOrigins(java.util.List.of("http://localhost:63342", "http://127.0.0.1:5500", "http://localhost:5500"));
                    corsConfiguration.setAllowedMethods(java.util.List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
                    corsConfiguration.setAllowedHeaders(java.util.List.of("*"));
                    corsConfiguration.setAllowCredentials(true);
                    return corsConfiguration;
                }))
                .csrf(csrf -> csrf.disable())

                // 2. CẤU HÌNH PHÂN QUYỀN
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/api/auth/**").permitAll()
                        .requestMatchers("/api/auth/forgot-password").permitAll()
                        .requestMatchers("/api/auth/reset-password").permitAll()

                        .requestMatchers("/api/movies/**").permitAll()
                        .requestMatchers("/api/genres/**").permitAll()
                        .requestMatchers("/api/home/**").permitAll()

                        .requestMatchers("/api/cinemas/**").permitAll()
                        .requestMatchers("/api/cities/**").permitAll()
                        .requestMatchers("/api/showtimes/**").permitAll()
                        .requestMatchers("/api/showtime-seats/**").permitAll()

                        .requestMatchers("/api/products/**").permitAll()
                        .anyRequest().authenticated()
                );

        return http.build();
    }
}