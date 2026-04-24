package com.cinema.config;

import com.cinema.security.JwtAuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Autowired
    private UserDetailsService userDetailsService; // Sử dụng UserDetailsService (Interface)

    @Autowired
    private PasswordEncoder passwordEncoder;

//    @Bean
//    public PasswordEncoder passwordEncoder() {
//        return new BCryptPasswordEncoder(); // Dùng BCrypt để mã hóa mật khẩu
//    }

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder);
        return authProvider;
    }

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

                        .requestMatchers("/api/users/profile", "/api/users/profile/**").hasAnyAuthority("customer", "admin")
                        .requestMatchers(HttpMethod.GET, "/api/users/profile").hasAnyAuthority("customer", "admin")
                        .requestMatchers(HttpMethod.PUT, "/api/users/profile").hasAnyAuthority("customer")

                        .requestMatchers(HttpMethod.GET, "/api/comments/movie/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/comments").hasAnyAuthority("customer", "admin")

                        .anyRequest().authenticated()
                )
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}