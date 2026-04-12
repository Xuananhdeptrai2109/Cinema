package com.cinema.modules.booking.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InvoiceResponse {
    private UUID invoiceId;          // Mã hóa đơn (Dùng để Client gửi lại khi xác nhận QR)
    private String fullName;         // Tên khách hàng
    private String email;            // Email nhận vé
    private BigDecimal totalPrice;   // Tổng tiền cuối cùng (Sau khi SP đã tính toán)
    private String status;           // pending, paid, cancelled
    private LocalDateTime createdAt; // Thời gian tạo đơn

    // Danh sách tóm tắt để hiển thị ở cột bên phải giao diện
    private List<String> seatLabels;    // VD: ["A1", "A2"]
    private List<String> productLabels; // VD: ["2x Bắp rang bơ", "1x Coca"]
}