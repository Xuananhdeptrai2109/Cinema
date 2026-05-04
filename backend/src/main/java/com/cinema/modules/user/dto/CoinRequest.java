package com.cinema.modules.user.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CoinRequest {
    private String date;
    private String description;
    private Integer amount;
}
