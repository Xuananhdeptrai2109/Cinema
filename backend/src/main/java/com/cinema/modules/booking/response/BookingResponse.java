package com.cinema.modules.booking.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BookingResponse {
    private boolean success;
    private String message;
    private String errorCode; // Nếu success = false (VD: "SEAT_ALREADY_TAKEN")

    // Nếu thành công, có thể trả về dữ liệu hóa đơn vừa tạo
    private Object data;

    // Static helper cho nhanh
    public static BookingResponse ok(String msg, Object data) {
        return new BookingResponse(true, msg, null, data);
    }

    public static BookingResponse error(String msg, String code) {
        return new BookingResponse(false, msg, code, null);
    }
}