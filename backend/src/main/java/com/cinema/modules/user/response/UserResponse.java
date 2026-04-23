package com.cinema.modules.user.response;

import com.cinema.modules.user.entity.User;
import lombok.*;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {
    private String fullName;     // Khớp với id="viewName"
    private String userName;     // Khớp với @username
    private String email;
    private LocalDate dateOfBirth;
    private String phoneNumber;
    private String address;
    private String imgUrl;       // Khớp với src của ảnh
    private Integer coin;        // Khớp với ví coin

    // UserResponse.java
    public UserResponse(User user) {
        this.fullName = user.getFullName();
        this.email = user.getEmail();
        this.userName = user.getUserName();
        this.dateOfBirth = user.getDateOfBirth();
        this.phoneNumber = user.getPhoneNumber();
        this.address = user.getAddress();
        this.imgUrl = user.getImgUrl();
        this.coin = user.getCoin();
    }
}