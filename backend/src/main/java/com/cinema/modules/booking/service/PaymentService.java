package com.cinema.modules.booking.service;

import com.cinema.modules.booking.entity.Invoice;
import com.cinema.modules.booking.repository.InvoiceRepository;
import com.cinema.modules.user.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;

@Service
public class PaymentService {

    @Autowired private InvoiceRepository invoiceRepository;
    @Autowired private com.cinema.modules.booking.repository.BookingSeatRepository bookingSeatRepository;
    @Autowired private com.cinema.modules.seat.repository.StatusRepository statusRepository;
    @Autowired private com.cinema.modules.user.repository.UserRepository userRepository;
    @Autowired private EmailService emailService;

    @Transactional
    public void markAsPaying(java.util.UUID invoiceId) {
        Invoice invoice = invoiceRepository.findById(invoiceId)
                .orElseThrow(() -> new RuntimeException("Hóa đơn không tồn tại"));
        invoice.setInvoiceStatus("paying");
        invoice.setPayingAt(LocalDateTime.now());
        invoiceRepository.save(invoice);
    }

    @Transactional
    public void confirmPayment(java.util.UUID invoiceId, String transactionId, String method) {
        Invoice invoice = invoiceRepository.findById(invoiceId)
                .orElseThrow(() -> new RuntimeException("Hóa đơn không tồn tại"));

        // Chỉ xử lý nếu đang ở trạng thái chờ thanh toán
        if (!"paying".equals(invoice.getInvoiceStatus())) return;

        invoice.setInvoiceStatus("paid"); // Cập nhật sang 'paid'
        invoice.setTransactionId(transactionId);
        invoice.setPaymentMethod(method);
        invoice.setPaidAt(LocalDateTime.now());

        // Sinh Ticket Code ngắn gọn[cite: 15]
        String randomCode = "CNM" + (System.currentTimeMillis() % 1000000);
        invoice.setTicketCode(randomCode);

        // TRỪ COIN THỰC TẾ TRONG DATABASE[cite: 15, 17]
        User user = invoice.getUser();
        if (invoice.getUsedCoin() != null && invoice.getUsedCoin() > 0) {
            int currentCoin = user.getCoin() != null ? user.getCoin() : 0;
            int newBalance = currentCoin - invoice.getUsedCoin();
            user.setCoin(Math.max(newBalance, 0)); // Đảm bảo không âm
            userRepository.save(user); // Lưu lại vào bảng User[cite: 15]
        }

        // Cập nhật trạng thái ghế thành 'booked'
        com.cinema.modules.seat.entity.Status bookedStatus = statusRepository
                .findByStatusName(com.cinema.modules.seat.entity.Status.SeatStatusName.booked)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy trạng thái booked"));

        bookingSeatRepository.findByInvoice_InvoiceId(invoiceId).forEach(bs -> {
            bs.getShowtimeSeat().setStatus(bookedStatus);
            bs.getShowtimeSeat().setUserId(user.getUserId());
        });

        invoiceRepository.save(invoice);
        emailService.sendTicketEmail(invoice);
    }

    @Transactional
    public void failPayment(java.util.UUID invoiceId, String reason) {
        Invoice invoice = invoiceRepository.findById(invoiceId)
                .orElseThrow(() -> new RuntimeException("Hóa đơn không tồn tại"));
        invoice.setInvoiceStatus("failed");
        invoiceRepository.save(invoice);
    }
}