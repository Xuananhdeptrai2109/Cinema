package com.cinema.modules.booking.service;

import com.cinema.modules.booking.dto.BookingRequest;
import com.cinema.modules.booking.entity.*;
import com.cinema.modules.booking.repository.*;
import com.cinema.modules.seat.entity.ShowtimeSeat;
import com.cinema.modules.booking.repository.ShowtimeSeatRepository; // Giả định bạn đã có
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
    @Autowired private ProductRepository productRepository; // Giả định bạn đã có

    @Transactional
    public Invoice createBooking(BookingRequest request) {
        // 1. Kiểm tra User
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("Người dùng không tồn tại"));

        // 2. Khởi tạo Hóa đơn nháp (Draft Invoice)
        Invoice invoice = Invoice.builder()
                .user(user)
                .invoiceStatus("pending")
                .totalPrice(BigDecimal.ZERO)
                .build();
        invoice = invoiceRepository.save(invoice);

        // 3. Xử lý lưu danh sách ghế đã chọn (BookingSeat)
        if (request.getShowtimeSeatIds() != null && !request.getShowtimeSeatIds().isEmpty()) {
            for (Long seatId : request.getShowtimeSeatIds()) {
                ShowtimeSeat showtimeSeat = showtimeSeatRepository.findById(seatId)
                        .orElseThrow(() -> new RuntimeException("Ghế không tồn tại hoặc đã bị đổi trạng thái"));

                BookingSeat bookingSeat = new BookingSeat();
                bookingSeat.setInvoice(invoice);
                bookingSeat.setShowtimeSeat(showtimeSeat);
                bookingSeat.setShowtime(showtimeSeat.getShowtime());
                // Lưu giá vé tại thời điểm đặt (tránh trường hợp sau này rạp đổi giá gốc)
                bookingSeat.setPriceAtBooking(showtimeSeat.getSeat().getSeatType().getPrice());

                bookingSeatRepository.save(bookingSeat);
            }
        }

        // 4. Xử lý lưu danh sách bắp nước (BookingProduct)
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

        // 5. Tính toán lại tổng tiền
        // GỢI Ý: Ở đây bạn nên gọi Stored Procedure: CALL sp_invoice_calculate_total(invoiceId)
        // Hoặc tính toán tạm thời bằng code Java:
        calculateAndSetTotalPrice(invoice);

        return invoiceRepository.save(invoice);
    }

    private void calculateAndSetTotalPrice(Invoice invoice) {
        BigDecimal totalSeats = invoice.getBookingSeats().stream()
                .map(BookingSeat::getPriceAtBooking)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalProducts = invoice.getBookingProducts().stream()
                .map(p -> p.getPriceAtBooking().multiply(new BigDecimal(p.getProductQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        invoice.setTotalPrice(totalSeats.add(totalProducts));
    }
}