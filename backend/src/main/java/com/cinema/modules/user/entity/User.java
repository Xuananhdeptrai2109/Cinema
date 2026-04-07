package com.cinema.modules.user.entity;

import jakarta.persistence.*;
import lombok.*;

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
    private Long id;

    private String fullname;

    private String date_of_birth;

    private String phone_number;

    @Column(name = "email_address")
    private String email;

    private String username;

    private String password;
}