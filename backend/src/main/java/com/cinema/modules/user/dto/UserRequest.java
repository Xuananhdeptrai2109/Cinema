package com.cinema.modules.user.dto;

import lombok.Data;
import java.time.LocalDate;

@Data
public class UserRequest {
    private String fullName;
    private LocalDate dateOfBirth;
    private String phoneNumber;
    private String address;
    private String imgUrl;
}