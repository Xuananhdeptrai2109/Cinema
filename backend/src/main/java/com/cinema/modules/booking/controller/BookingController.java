package com.cinema.modules.booking.controller;

import com.cinema.modules.auth.repository.AuthRepository;
import com.cinema.modules.booking.dto.BookingRequest;
import com.cinema.modules.booking.entity.Invoice;
import com.cinema.modules.booking.entity.BookingSeat;
import com.cinema.modules.booking.entity.BookingProduct;
import com.cinema.modules.booking.repository.InvoiceRepository;
import com.cinema.modules.booking.service.BookingService;
import com.cinema.modules.booking.service.PaymentService;
import com.cinema.modules.movie.entity.Genre;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;


@RestController
@RequestMapping("/api/booking")
public class BookingController {

    @Autowired private BookingService bookingService;
    @Autowired private PaymentService paymentService;
    @Autowired private InvoiceRepository invoiceRepository;
    @Autowired private AuthRepository authRepository;

    @PostMapping("/create")
    public ResponseEntity<Map<String, Object>> createBooking(@RequestBody BookingRequest request) {
        Invoice invoice = bookingService.createBooking(request);
        Map<String, Object> result = new HashMap<>();
        result.put("invoiceId", invoice.getInvoiceId().toString());
        result.put("totalPrice", invoice.getTotalPrice());
        result.put("status", invoice.getInvoiceStatus());
        return ResponseEntity.ok(result);
    }

    @PostMapping("/confirm-payment")
    public ResponseEntity<?> confirm(@RequestBody Map<String, Object> payload) {
        UUID invoiceId = UUID.fromString(payload.get("invoiceId").toString());
        String transId = (String) payload.get("transactionId");
        String method  = (String) payload.get("method");
        paymentService.confirmPayment(invoiceId, transId, method);
        return ResponseEntity.ok("Thanh toán thành công");
    }

    @PostMapping("/paying")
    public ResponseEntity<?> markPaying(@RequestBody Map<String, Object> payload) {
        UUID invoiceId = UUID.fromString(payload.get("invoiceId").toString());
        paymentService.markAsPaying(invoiceId);
        return ResponseEntity.ok("Đang chờ thanh toán");
    }

    @PostMapping("/fail-payment")
    public ResponseEntity<?> failPayment(@RequestBody Map<String, Object> payload) {
        UUID invoiceId = UUID.fromString(payload.get("invoiceId").toString());
        String reason = (String) payload.get("reason");
        paymentService.failPayment(invoiceId, reason);
        return ResponseEntity.ok("Đã hủy thanh toán");
    }

    @GetMapping("/invoice/{invoiceId}")
    @Transactional(readOnly = true)
    public ResponseEntity<?> getInvoiceDetail(@PathVariable String invoiceId) {
        try {
            UUID id = UUID.fromString(invoiceId);
            Invoice inv = invoiceRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn: " + invoiceId));

            Map<String, Object> m = new LinkedHashMap<>();
            m.put("invoiceId",  inv.getInvoiceId().toString());
            m.put("status",     inv.getInvoiceStatus());
            m.put("finalPrice", inv.getFinalPrice());

            List<Map<String, Object>> seats = new ArrayList<>();
            String movieTitle = null, showDate = null, startTime = null;
            String cinemaName = null, roomName = null, showtimeIdStr = null;
            String posterUrl  = null, genre    = null, ageRating    = null, roomType = null;

            if (inv.getBookingSeats() != null) {
                for (BookingSeat bs : inv.getBookingSeats()) {

                    // --- Thông tin ghế ---
                    if (bs.getShowtimeSeat() != null && bs.getShowtimeSeat().getSeat() != null) {
                        var seat = bs.getShowtimeSeat().getSeat();
                        Map<String, Object> s = new LinkedHashMap<>();
                        s.put("dbId",  bs.getShowtimeSeat().getShowtimeSeatId());
                        s.put("id",    seat.getRowName() + seat.getSeatNumber());
                        s.put("type",  seat.getSeatType() != null ? seat.getSeatType().getTypeName().toLowerCase() : "normal");
                        s.put("price", bs.getPriceAtBooking() != null ? bs.getPriceAtBooking().longValue() : 0);
                        seats.add(s);
                    }

                    // --- Thông tin suất chiếu + phim (chỉ lấy 1 lần) ---
                    if (movieTitle == null && bs.getShowtime() != null) {
                        var st = bs.getShowtime();
                        showtimeIdStr = st.getShowtimeId() != null ? st.getShowtimeId().toString() : null;

                        if (st.getMovie() != null) {
                            var movie  = st.getMovie();          // khai báo biến movie đúng chỗ
                            movieTitle = movie.getTitle();
                            posterUrl  = movie.getPosterLink();  // field đúng trong Movie entity
                            ageRating  = movie.getAgeRating();
                            genre      = (movie.getGenres() == null || movie.getGenres().isEmpty()) ? null :
                                    movie.getGenres().stream()
                                    .map(Genre::getGenreName)
                                    .collect(Collectors.joining(", "));
                        }

                        showDate  = st.getShowDate()  != null ? st.getShowDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : null;
                        startTime = st.getStartTime() != null ? st.getStartTime().format(DateTimeFormatter.ofPattern("HH:mm"))     : null;

                        if (st.getRoom() != null) {
                            roomName = st.getRoom().getRoomName();
                            roomType =  st.getRoom().getScreeningFormat() != null
                                    ? st.getRoom().getScreeningFormat().getType()
                                    : null;
                            if (st.getRoom().getCinema() != null)
                                cinemaName = st.getRoom().getCinema().getCinemaName();
                        }
                    }
                }
            }

            m.put("seats",      seats);
            m.put("showtimeId", showtimeIdStr);
            m.put("movieTitle", movieTitle);
            m.put("posterUrl",  posterUrl);
            m.put("genre",      genre);
            m.put("ageRating",  ageRating);
            m.put("showDate",   showDate);
            m.put("startTime",  startTime);
            m.put("cinemaName", cinemaName);
            m.put("roomName",   roomName);
            m.put("roomType",   roomType);
            return ResponseEntity.ok(m);

        } catch (Exception e) {
            return ResponseEntity.status(404).body("Lỗi: " + e.getMessage());
        }
    }

    @GetMapping("/my-invoices")
    @Transactional(readOnly = true)
    public ResponseEntity<?> getMyInvoices() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        if (email == null) return ResponseEntity.status(401).body("Chưa xác thực");

        com.cinema.modules.user.entity.User user = authRepository.findByEmail(email)
                        .orElseThrow(() -> new RuntimeException("User not found"));

        List<Invoice> invoices =
                invoiceRepository.findByUser_UserIdOrderByCreatedDatetimeDesc(user.getUserId());

        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");

        List<Map<String, Object>> result = invoices.stream().map(inv -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("invoiceId",     inv.getInvoiceId().toString());
            m.put("status",        inv.getInvoiceStatus());
            m.put("totalPrice",    inv.getTotalPrice());
            m.put("finalPrice",    inv.getFinalPrice());
            m.put("paymentMethod", inv.getPaymentMethod());
            m.put("createdAt",     inv.getCreatedDatetime() != null ? inv.getCreatedDatetime().format(fmt) : null);
            m.put("paidAt",        inv.getPaidAt()          != null ? inv.getPaidAt().format(fmt)          : null);
            m.put("payingAt", inv.getPayingAt() != null ? inv.getPayingAt().format(fmt) : null);

            List<String> seatLabels = new ArrayList<>();
            String movieTitle = null, showtimeStr = null, cinemaName = null, roomName = null;

            if (inv.getBookingSeats() != null) {
                for (BookingSeat bs : inv.getBookingSeats()) {
                    if (bs.getShowtimeSeat() != null && bs.getShowtimeSeat().getSeat() != null)
                        seatLabels.add(bs.getShowtimeSeat().getSeat().getRowName()
                                + bs.getShowtimeSeat().getSeat().getSeatNumber());

                    if (movieTitle == null && bs.getShowtime() != null) {
                        var st = bs.getShowtime();
                        if (st.getMovie() != null)
                            movieTitle = st.getMovie().getTitle();
                        if (st.getStartTime() != null)
                            showtimeStr = st.getStartTime().format(DateTimeFormatter.ofPattern("HH:mm"))
                                    + " - "
                                    + st.getShowDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                        if (st.getRoom() != null) {
                            roomName = st.getRoom().getRoomName();
                            if (st.getRoom().getCinema() != null)
                                cinemaName = st.getRoom().getCinema().getCinemaName();
                        }
                    }
                }
            }

            List<String> productLabels = new ArrayList<>();
            if (inv.getBookingProducts() != null) {
                for (BookingProduct bp : inv.getBookingProducts()) {
                    if (bp.getProduct() != null)
                        productLabels.add(bp.getProductQuantity() + "x " + bp.getProduct().getProductName());
                }
            }

            m.put("movieTitle",    movieTitle);
            m.put("showtime",      showtimeStr);
            m.put("cinemaName",    cinemaName);
            m.put("roomName",      roomName);
            m.put("seatLabels",    seatLabels);
            m.put("productLabels", productLabels);
            return m;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(result);
    }
}