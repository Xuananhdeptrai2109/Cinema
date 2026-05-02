package com.cinema.modules.booking.entity;


import com.cinema.modules.user.entity.User;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "invoice")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Invoice {

    @Id
    @Column(name = "invoice_id", columnDefinition = "BINARY(16)")
    private java.util.UUID invoiceId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "total_price")
    private BigDecimal totalPrice;

    @Column(name = "final_price")
    private BigDecimal finalPrice;

    @Column(name = "invoice_status")
    private String invoiceStatus;

    @Column(name = "payment_method")
    private String paymentMethod;

    @Column(name = "transaction_id")
    private String transactionId;

    @Column(name = "email_address")
    private String emailAddress;

    @Column(name = "paying_at")
    private LocalDateTime payingAt;

    @Column(name = "created_datetime", updatable = false)
    private LocalDateTime createdDatetime;

    @PrePersist
    protected void onCreate() {
        this.createdDatetime = LocalDateTime.now();
    }

    @Column(name = "paid_at")
    private LocalDateTime paidAt;

    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL)
    private List<BookingSeat> bookingSeats;

    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL)
    private List<BookingProduct> bookingProducts;
}