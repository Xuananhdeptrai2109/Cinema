package com.cinema.modules.user.entity;

import com.cinema.modules.booking.entity.Invoice;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.security.core.userdetails.UserDetails;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import java.util.Collection;
import java.util.Collections;

enum UserRole {
    admin, customer
}

@Entity
@Table(name = "User")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class User implements UserDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long userId;

    @Column(name = "fullname")
    private String fullName;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Column(name = "phone_number")
    private String phoneNumber;

    @Column(name = "email_address")
    private String email;

    @Column(name = "address", length = 255)
    private String address;

    @Column(name = "img_url", columnDefinition = "LONGTEXT") // Ép kiểu LONGTEXT để chứa đủ chuỗi ảnh
    private String imgUrl;;

    @Column(name = "username")
    private String userName;

    public String getUserName() {
        return this.userName;
    }

    @Column(name = "password")
    private String password;

    @Column(name = "coin", nullable = false)
    private Integer coin = 0;

    @Column(name = "otp")
    private String otp;

    @Column(name = "otp_expiry")
    private LocalDateTime otpExpiry;

    @Column(name = "created_at")
    private LocalDateTime createdAt;


    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false)
    private UserRole role = UserRole.customer;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Invoice> invoices;

    // 2. Ghi đè hàm getAuthorities để Spring Security đọc được Role
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        // Chuyển Enum UserRole (admin/customer) thành Authority của Spring Security
        if (this.role == null) {
            return Collections.singletonList(new SimpleGrantedAuthority("customer"));
        }
        return Collections.singletonList(new SimpleGrantedAuthority(this.role.name()));
    }

    // 3. Cung cấp Username cho hệ thống (Trong trường hợp của bạn là email)
    @Override
    public String getUsername() {
        return this.email;
    }

    // 4. Các hàm bắt buộc khác của UserDetails (Để mặc định true)
    @Override public boolean isAccountNonExpired() { return true; }
    @Override public boolean isAccountNonLocked() { return true; }
    @Override public boolean isCredentialsNonExpired() { return true; }
    @Override public boolean isEnabled() { return true; }
}