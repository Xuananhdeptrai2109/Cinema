package com.cinema.modules.booking.controller;

import com.cinema.modules.booking.dto.BookingRequest;
import com.cinema.modules.booking.entity.Invoice;
import com.cinema.modules.booking.service.BookingService;
import com.cinema.modules.booking.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/booking")
public class BookingController {

    @Autowired private BookingService bookingService;
    @Autowired private PaymentService paymentService;

    @PostMapping("/create")
    public ResponseEntity<Invoice> createBooking(@RequestBody BookingRequest request) {
        return ResponseEntity.ok(bookingService.createBooking(request));
    }

    @PostMapping("/confirm-payment")
    public ResponseEntity<?> confirm(@RequestBody Map<String, Object> payload) {
        UUID invoiceId = UUID.fromString((String) payload.get("invoiceId"));
        String transId = (String) payload.get("transactionId");
        String method = (String) payload.get("method");

        paymentService.confirmPayment(invoiceId, transId, method);
        return ResponseEntity.ok("Thanh toán thành công");
    }
}