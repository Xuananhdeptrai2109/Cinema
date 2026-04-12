package com.cinema.modules.booking.service;

import com.cinema.modules.booking.entity.Invoice;
import com.cinema.modules.booking.repository.InvoiceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.UUID;

@Service
public class PaymentService {

    @Autowired private InvoiceRepository invoiceRepository;

    @Transactional
    public void confirmPayment(UUID invoiceId, String transactionId, String method) {
        Invoice invoice = invoiceRepository.findById(invoiceId)
                .orElseThrow(() -> new RuntimeException("Hóa đơn không tồn tại"));

        // Cập nhật trạng thái
        invoice.setInvoiceStatus("paid");
        invoice.setTransactionId(transactionId);
        invoice.setPaymentMethod(Invoice.PaymentMethod.valueOf(method.toLowerCase()));

        invoiceRepository.save(invoice);

        // TODO: Tại đây gọi Stored Procedure sp_payment_success để chốt ghế (status = 'booked')
    }
}