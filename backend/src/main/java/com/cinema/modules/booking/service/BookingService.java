package com.cinema.modules.booking.service;

import com.cinema.modules.booking.dto.BookingRequest;
import com.cinema.modules.booking.entity.*;
import com.cinema.modules.booking.repository.*;
import com.cinema.modules.seat.entity.ShowtimeSeat;

import com.cinema.modules.user.entity.User;
import com.cinema.modules.auth.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

@Service
public class BookingService {

    @Autowired private InvoiceRepository invoiceRepository;
    @Autowired private BookingSeatRepository bookingSeatRepository;
    @Autowired private BookingProductRepository bookingProductRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private ShowtimeSeatRepository showtimeSeatRepository;
    @Autowired private ProductRepository productRepository;

    @Transactional
    public Invoice createBooking(BookingRequest request) {

        // 1. Kiểm tra User
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("Người dùng không tồn tại"));

        

        // 3. Tạo Invoice
        Invoice invoice = Invoice.builder()
                .invoiceId(java.util.UUID.randomUUID())
                .user(user)
                .invoiceStatus("draft")
                .totalPrice(BigDecimal.ZERO)
                .finalPrice(BigDecimal.ZERO)     // ✅ Thêm mới - DB có final_price NOT NULL
                .build();
        invoice = invoiceRepository.save(invoice);

        // 4. Lưu danh sách ghế (BookingSeat)
        if (request.getShowtimeSeatIds() != null && !request.getShowtimeSeatIds().isEmpty()) {
            for (Long seatId : request.getShowtimeSeatIds()) {
                if (seatId == null) continue;
                ShowtimeSeat showtimeSeat = showtimeSeatRepository.findById(seatId)
                        .orElseThrow(() -> new RuntimeException("Ghế không tồn tại hoặc đã bị đổi trạng thái"));

                BookingSeat bookingSeat = new BookingSeat();
                bookingSeat.setInvoice(invoice);
                bookingSeat.setShowtimeSeat(showtimeSeat);
                bookingSeat.setShowtime(showtimeSeat.getShowtime()); 
                bookingSeat.setPriceAtBooking(showtimeSeat.getSeat().getSeatType().getPrice());

                bookingSeatRepository.save(bookingSeat);
            }
        }

        // 5. Lưu danh sách combo (BookingProduct)
        if (request.getProducts() != null && !request.getProducts().isEmpty()) {
            for (BookingRequest.ProductSelection selection : request.getProducts()) {
                Product product = productRepository.findById(selection.getProductId())
                        .orElseThrow(() -> new RuntimeException("Sản phẩm không tồn tại"));

                BookingProduct bookingProduct = new BookingProduct();
                bookingProduct.setInvoice(invoice);
                bookingProduct.setProduct(product);
                bookingProduct.setProductQuantity(selection.getQuantity());
                bookingProduct.setPriceAtBooking(product.getPrice());

                bookingProductRepository.save(bookingProduct);
            }
        }

        // 6. Tính tổng tiền
        // Tính tổng ghế — dùng lại dữ liệu đã có, không query lại
        BigDecimal seatTotal = BigDecimal.ZERO;
        if (request.getShowtimeSeatIds() != null) {
            for (Long seatId : request.getShowtimeSeatIds()) {
                if (seatId == null) continue;
                ShowtimeSeat s = showtimeSeatRepository.findById(seatId)
                    .orElseThrow(() -> new RuntimeException("Ghế không tồn tại"));
                seatTotal = seatTotal.add(s.getSeat().getSeatType().getPrice());
            }
        }

        // Tính tổng combo — phần đang BỊ BỎ QUÊN
        BigDecimal productTotal = BigDecimal.ZERO;
        if (request.getProducts() != null) {
            for (BookingRequest.ProductSelection sel : request.getProducts()) {
                Product p = productRepository.findById(sel.getProductId())
                    .orElseThrow(() -> new RuntimeException("Sản phẩm không tồn tại"));
                productTotal = productTotal.add(
                    p.getPrice().multiply(BigDecimal.valueOf(sel.getQuantity()))
                );
            }
        }

        BigDecimal total = seatTotal.add(productTotal);
        invoice.setTotalPrice(total);
        invoice.setFinalPrice(total);
        return invoiceRepository.save(invoice);

    }

    private void calculateAndSetTotalPrice(Invoice invoice) {
        BigDecimal totalSeats = invoice.getBookingSeats() == null ? BigDecimal.ZERO :
                invoice.getBookingSeats().stream()
                        .map(BookingSeat::getPriceAtBooking)
                        .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalProducts = invoice.getBookingProducts() == null ? BigDecimal.ZERO :
                invoice.getBookingProducts().stream()
                        .map(p -> p.getPriceAtBooking().multiply(new BigDecimal(p.getProductQuantity())))
                        .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal total = totalSeats.add(totalProducts);
        invoice.setTotalPrice(total);
        invoice.setFinalPrice(total); // ✅ Cập nhật cả finalPrice
    }
}