package com.cinema.config;

import com.cinema.security.JwtFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtFilter jwtFilter;

    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder);
        return authProvider;
    }

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring().requestMatchers(
                "/favicon.ico",
                "/static/**",
                "/resources/**",
                "/css/**",
                "/js/**",
                "/images/**",
                "/frontend/"
        );
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // 1. CẤU HÌNH CORS VÀ VÔ HIỆU HÓA CSRF
                .cors(cors -> cors.configurationSource(request -> {
                    var config = new org.springframework.web.cors.CorsConfiguration();
                    config.setAllowedOrigins(java.util.List.of("http://localhost:63342", "http://127.0.0.1:5500", "http://localhost:5500"));
                    config.setAllowedMethods(java.util.List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
                    config.setAllowedHeaders(java.util.List.of("*"));
                    config.setAllowCredentials(true);
                    return config;
                }))
                .csrf(csrf -> csrf.disable())

                // 2. CẤU HÌNH PHÂN QUYỀN (CHỈ DÙNG MỘT KHỐI DUY NHẤT)
                .authorizeHttpRequests(auth -> auth

                        .requestMatchers("/frontend/**", "/css/**", "/js/**", "/images/**", "/favicon.ico").permitAll()
                        .requestMatchers("/vnpay-return.html").permitAll()

                        .requestMatchers("/api/payment/vnpay-callback", "/api/payment/vnpay-verify", "/api/payment/vnpay-ipn").permitAll()
                        .requestMatchers("/api/payment/vnpay-create").hasAnyAuthority("customer", "ROLE_customer")

                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()

                        .requestMatchers("/api/auth/**", "/api/home/**").permitAll()
                        .requestMatchers("/api/movies/**", "/api/genres/**", "/api/cinemas/**", "/api/cities/**").permitAll()
                        .requestMatchers("/api/showtimes/**", "/api/showtime-seats/**", "/api/products/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/comments/movie/**").permitAll()

                        .requestMatchers("/api/users/profile/**").hasAnyAuthority("customer", "admin", "ROLE_customer", "ROLE_admin")
                        .requestMatchers("/api/comments").hasAnyAuthority("customer", "admin", "ROLE_customer", "ROLE_admin")
                        .requestMatchers("/api/invoices/**", "/api/payment/**", "/api/booking/**").hasAnyAuthority("customer", "ROLE_customer")
                        .requestMatchers("/api/discounts/check").permitAll()

                        // CHỐT CHẶN CUỐI CÙNG: Các yêu cầu khác phải đăng nhập
                        .anyRequest().authenticated()
                )

                // 3. QUẢN LÝ SESSION STATELESS CHO JWT[cite: 8]
                .sessionManagement(session -> session
                        .sessionCreationPolicy(org.springframework.security.config.http.SessionCreationPolicy.STATELESS)
                )

                // 4. TẮT CƠ CHẾ LOGIN MẶC ĐỊNH VÀ THÊM JWT FILTER[cite: 8]
                .httpBasic(h -> h.disable())
                .formLogin(f -> f.disable())
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}