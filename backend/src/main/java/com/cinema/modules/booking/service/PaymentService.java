package com.cinema.modules.booking.service;

import com.cinema.modules.booking.entity.Invoice;
import com.cinema.modules.booking.repository.InvoiceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;

@Service
public class PaymentService {

    @Autowired private InvoiceRepository invoiceRepository;
    @Autowired private com.cinema.modules.booking.repository.BookingSeatRepository bookingSeatRepository;
    @Autowired private com.cinema.modules.seat.repository.StatusRepository statusRepository;

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
        invoice.setInvoiceStatus("paid");
        invoice.setTransactionId(transactionId);
        invoice.setPaymentMethod(method);
        invoice.setPaidAt(LocalDateTime.now());
        invoiceRepository.save(invoice);
        com.cinema.modules.seat.entity.Status bookedStatus = statusRepository
            .findByStatusName(com.cinema.modules.seat.entity.Status.SeatStatusName.booked)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy trạng thái booked"));

        bookingSeatRepository.findByInvoice_InvoiceId(invoiceId).forEach(bs -> {
            bs.getShowtimeSeat().setStatus(bookedStatus);
            bs.getShowtimeSeat().setUserId(invoice.getUser().getUserId());
        });
    }

    @Transactional
    public void failPayment(java.util.UUID invoiceId, String reason) {
        Invoice invoice = invoiceRepository.findById(invoiceId)
                .orElseThrow(() -> new RuntimeException("Hóa đơn không tồn tại"));
        invoice.setInvoiceStatus("failed");
        invoiceRepository.save(invoice);
    }
}