package com.cinema.modules.booking.entity;

import com.cinema.modules.discount.entity.Discount;
import com.cinema.modules.user.entity.User;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "Invoice")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "invoice_id", columnDefinition = "BINARY(16)")
    @org.hibernate.annotations.JdbcTypeCode(org.hibernate.type.SqlTypes.BINARY)
    private UUID invoiceId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "total_price")
    private BigDecimal totalPrice;

    @Column(name = "invoice_status")
    private String invoiceStatus ;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_method")
    private PaymentMethod paymentMethod;
    public enum PaymentMethod {
        momo, vnpay, cash, zalopay
    }

    @Column(name = "transaction_id")
    private String transactionId ;

    @Column(name = "email_address")
    private String emailAddress;

    @Column(updatable = false)
    private LocalDateTime createdDatetime = LocalDateTime.now();

    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL)
    private List<BookingSeat> bookingSeats;

    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL)
    private List<BookingProduct> bookingProducts;
}