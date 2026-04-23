package com.cinema.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;
import java.util.function.Function;

// XÓA dòng import này vì nó gây ra lỗi 'int cannot be converted to Key'
// import static javax.crypto.Cipher.SECRET_KEY;

@Component
public class JwtUtil {

    // Chuỗi bí mật cố định để tránh lỗi 403 khi restart server
    private static final String SECRET_STRING = "Chuoi_Bi_Mat_CineMax_2026_Khong_Thay_Doi_Dau_Nhe";

    // Biến key chuẩn để truyền vào setSigningKey và signWith
    private final Key key = Keys.hmacShaKeyFor(SECRET_STRING.getBytes(StandardCharsets.UTF_8));

    // 1. Tạo Token
    public String generateToken(String email) {
        return Jwts.builder()
                .setSubject(email)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 86400000)) // 24 giờ
                .signWith(key) // SỬA: Dùng 'key' thay vì SECRET_KEY
                .compact();
    }

    // 2. Lấy Email (Subject) từ Token
    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    // 3. Kiểm tra Token hợp lệ
    public Boolean validateToken(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        // Kiểm tra khớp email và chưa hết hạn
        return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }

    // --- CÁC HÀM HỖ TRỢ TRÍCH XUẤT ---

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(key) // SỬA: Dùng 'key' (kiểu Key) thay vì hằng số int
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    private Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    private Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }
}