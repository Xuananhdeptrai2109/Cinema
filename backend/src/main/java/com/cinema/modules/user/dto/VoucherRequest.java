package com.cinema.modules.user.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class VoucherRequest {
    private String code;
    private String usedDate;
    private String discount;
}
