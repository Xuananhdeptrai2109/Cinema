package com.cinema.modules.booking.controller;

import com.cinema.modules.booking.entity.Invoice;
import com.cinema.modules.booking.repository.BookingSeatRepository;
import com.cinema.modules.booking.repository.InvoiceRepository;
import com.cinema.modules.booking.service.PaymentService;
import com.cinema.modules.booking.service.VNPayService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/payment")
public class PaymentController {

    @Autowired private VNPayService vnPayService;
    @Autowired private PaymentService paymentService;
    @Autowired private InvoiceRepository invoiceRepository;
    @Autowired private BookingSeatRepository bookingSeatRepository;

    // Bước 4: Frontend gọi để lấy URL → redirect sang VNPay
    @PostMapping("/vnpay-create")
    public ResponseEntity<?> createPayment(@RequestBody Map<String, Object> payload) {
        try {
            UUID invoiceId = UUID.fromString(payload.get("invoiceId").toString());

            // Lấy invoice từ DB
            Invoice invoice = invoiceRepository.findById(invoiceId)
                    .orElseThrow(() -> new RuntimeException("Hóa đơn không tồn tại: " + invoiceId));

            // Validate: invoice phải có ghế thì mới cho thanh toán
            boolean hasSeats = bookingSeatRepository.findByInvoice_InvoiceId(invoiceId).size() > 0;
            if (!hasSeats) {
                return ResponseEntity.badRequest().body("Hóa đơn không có thông tin ghế, không thể thanh toán");
            }

            // Lấy giá từ DB, không tin tưởng frontend
            if (invoice.getFinalPrice() == null || invoice.getFinalPrice().compareTo(java.math.BigDecimal.ZERO) <= 0) {
                return ResponseEntity.badRequest().body("Giá hóa đơn không hợp lệ");
            }

            String orderInfo = "Thanh toan ve xem phim " + invoiceId;

            paymentService.markAsPaying(invoiceId);

            String paymentUrl = vnPayService.createPaymentUrl(invoiceId, invoice.getFinalPrice(), orderInfo);

            Map<String, String> response = new HashMap<>();
            response.put("paymentUrl", paymentUrl);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Lỗi tạo URL thanh toán: " + e.getMessage());
        }
    }

    // Bước 5: VNPay gọi về sau khi thanh toán xong
    @GetMapping("/vnpay-callback")
    public ResponseEntity<?> vnpayCallback(@RequestParam Map<String, String> params) {
        try {
            boolean isValid = vnPayService.verifyCallback(params);
            if (!isValid) {
                return ResponseEntity.badRequest().body("Chữ ký không hợp lệ");
            }

            String txnRef = params.get("vnp_TxnRef");
            String responseCode = params.get("vnp_ResponseCode");
            String transactionId = params.get("vnp_TransactionNo");

            UUID invoiceId = parseInvoiceId(txnRef);

            String qs = params.entrySet().stream()
                    .map(e -> e.getKey() + "=" + e.getValue())
                    .collect(java.util.stream.Collectors.joining("&"));

            if ("00".equals(responseCode)) {
                paymentService.confirmPayment(invoiceId, transactionId, "vnpay");
            } else {
                paymentService.failPayment(invoiceId, "VNPay response code: " + responseCode);
            }

            return ResponseEntity.status(302)
                    .header("Location", "http://127.0.0.1:5500/frontend/%20pages/vnpay-return.html?" + qs)
                    .build();

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Lỗi xử lý callback: " + e.getMessage());
        }
    }

    @GetMapping("/vnpay-verify")
    public ResponseEntity<?> vnpayVerify(@RequestParam Map<String, String> params) {
        try {
            boolean isValid = vnPayService.verifyCallback(params);
            String responseCode = params.get("vnp_ResponseCode");
            String txnRef = params.get("vnp_TxnRef");
            String transactionId = params.get("vnp_TransactionNo");

            Map<String, Object> result = new HashMap<>();
            result.put("valid", isValid);
            result.put("responseCode", responseCode);
            result.put("success", isValid && "00".equals(responseCode));

            if (isValid && "00".equals(responseCode) && txnRef != null) {
                UUID invoiceId = parseInvoiceId(txnRef);
                paymentService.confirmPayment(invoiceId, transactionId, "vnpay");
                result.put("message", "Thanh toán thành công");
            }

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Lỗi xác minh: " + e.getMessage());
        }
    }

    @PostMapping("/vnpay-ipn")
    public ResponseEntity<?> vnpayIpn(@RequestParam Map<String, String> params) {
        try {
            boolean isValid = vnPayService.verifyCallback(params);
            if (!isValid) {
                return ResponseEntity.ok(Map.of("RspCode", "97", "Message", "Invalid signature"));
            }

            String txnRef = params.get("vnp_TxnRef");
            String responseCode = params.get("vnp_ResponseCode");
            String transactionId = params.get("vnp_TransactionNo");

            UUID invoiceId = parseInvoiceId(txnRef);

            if ("00".equals(responseCode)) {
                paymentService.confirmPayment(invoiceId, transactionId, "vnpay");
            } else {
                paymentService.failPayment(invoiceId, "VNPay response code: " + responseCode);
            }

            return ResponseEntity.ok(Map.of("RspCode", "00", "Message", "Confirm Success"));

        } catch (Exception e) {
            return ResponseEntity.ok(Map.of("RspCode", "99", "Message", e.getMessage()));
        }
    }

    // Helper: parse txnRef (UUID không có dấu gạch) → UUID
    private UUID parseInvoiceId(String txnRef) {
        String formatted = txnRef.replaceAll(
                "(\\w{8})(\\w{4})(\\w{4})(\\w{4})(\\w{12})", "$1-$2-$3-$4-$5"
        );
        return UUID.fromString(formatted);
    }
}