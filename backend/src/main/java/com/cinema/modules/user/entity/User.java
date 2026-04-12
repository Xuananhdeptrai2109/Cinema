package com.cinema.modules.user.entity;

import com.cinema.modules.booking.entity.Invoice;
import com.cinema.modules.seat.entity.ShowtimeSeat;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.util.List;

// Định nghĩa Role ở ngoài class User để tránh lỗi xung đột "Role"
enum UserRole {
    admin, customer
}

@Entity
@Table(name = "User")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class User {
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

    @Column(name = "username")
    private String userName;

    @Column(name = "password")
    private String password;

    @Column(name = "coin", nullable = false)
    private Integer coin = 0;

    @Enumerated(EnumType.STRING)
    @Column(name = "role")
    private UserRole role; // Đổi thành UserRole để không bao giờ bị trùng tên lớp hệ thống

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Invoice> invoices;
}