package com.cinema.modules.booking.service;

import com.cinema.modules.booking.dto.BookingRequest;
import com.cinema.modules.booking.entity.*;
import com.cinema.modules.booking.repository.*;
import com.cinema.modules.seat.entity.ShowtimeSeat;
import com.cinema.modules.discount.repository.DiscountRepository;

import com.cinema.modules.user.entity.User;
import com.cinema.modules.user.repository.UserRepository;
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
    @Autowired private DiscountRepository discountRepository;

    @Transactional
    public Invoice createBooking(BookingRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("Người dùng không tồn tại"));

        // 1. Khởi tạo Invoice với các trường mới
        Invoice invoice = Invoice.builder()
                .invoiceId(java.util.UUID.randomUUID())
                .user(user)
                .emailAddress(user.getEmail())
                .invoiceStatus("draft")
                .discountCode(request.getDiscountCode()) // Lưu mã định dùng
                .usedCoin(request.getUsedCoin() != null ? request.getUsedCoin() : 0) // Lưu coin định dùng[cite: 17]
                .build();
        invoice = invoiceRepository.save(invoice);

        // 2. Lưu thông tin Ghế và Sản phẩm (giữ nguyên logic của bạn)
        BigDecimal seatTotal = calculateSeats(request, invoice);
        BigDecimal productTotal = calculateProducts(request, invoice);

        // 3. TÍNH TOÁN GIÁ[cite: 16, 17]
        BigDecimal total = seatTotal.add(productTotal);
        invoice.setTotalPrice(total);

        // Tính tiền giảm từ Voucher (Fixed amount theo ảnh bạn cung cấp)[cite: 17]
        BigDecimal discountVoucher = BigDecimal.ZERO;
        if (request.getDiscountCode() != null) {
            var discountOpt = discountRepository.findByDiscountCode(request.getDiscountCode());
            if (discountOpt.isPresent()) {
                discountVoucher = discountOpt.get().getDiscountValue();
            }
        }

        // Tính tiền giảm từ Coin (Ví dụ: 1 Coin = 1.000 VNĐ)[cite: 17]
        BigDecimal discountCoin = BigDecimal.valueOf(invoice.getUsedCoin() * 1000L);

        // Cập nhật Final Price (Không được âm)
        BigDecimal finalPrice = total.subtract(discountVoucher).subtract(discountCoin);
        invoice.setFinalPrice(finalPrice.max(BigDecimal.ZERO));

        return invoiceRepository.save(invoice);
    }

    // Tách hàm nhỏ để code sạch hơn
    private BigDecimal calculateSeats(BookingRequest req, Invoice inv) {
        BigDecimal total = BigDecimal.ZERO;
        if (req.getShowtimeSeatIds() == null) return total;
        for (Long id : req.getShowtimeSeatIds()) {
            ShowtimeSeat ss = showtimeSeatRepository.findById(id).orElseThrow();
            BookingSeat bs = new BookingSeat();
            bs.setInvoice(inv);
            bs.setShowtimeSeat(ss);
            bs.setShowtime(ss.getShowtime());
            BigDecimal price = ss.getSeat().getSeatType().getPrice();
            bs.setPriceAtBooking(price);
            bookingSeatRepository.save(bs);
            total = total.add(price);
        }
        return total;
    }

    private BigDecimal calculateProducts(BookingRequest req, Invoice inv) {
        BigDecimal total = BigDecimal.ZERO;
        if (req.getProducts() == null) return total;
        for (var sel : req.getProducts()) {
            Product p = productRepository.findById(sel.getProductId()).orElseThrow();
            BookingProduct bp = new BookingProduct();
            bp.setInvoice(inv);
            bp.setProduct(p);
            bp.setProductQuantity(sel.getQuantity());
            bp.setPriceAtBooking(p.getPrice());
            bookingProductRepository.save(bp);
            total = total.add(p.getPrice().multiply(BigDecimal.valueOf(sel.getQuantity())));
        }
        return total;
    }
}