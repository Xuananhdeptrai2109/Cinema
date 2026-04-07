package com.cinema.modules.discount.entity;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "Discount")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Discount {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "discount_id")
    private Long discountId;

    @Column(name = "discount_code", nullable = false, unique = true, length = 50)
    private String discountCode;

    @Enumerated(EnumType.STRING)
    @Column(name = "discount_type", nullable = false)
    private DiscountType discountType;

    @Column(name = "discount_value", nullable = false, precision = 10, scale = 2)
    private BigDecimal discountValue;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    @Column(name = "max_usage")
    private Integer maxUsage;

    @Column(name = "is_used", columnDefinition = "BOOLEAN DEFAULT FALSE")
    private Boolean isUsed = false;

    // Định nghĩa Enum cho discount_type
    public enum DiscountType {
        percent, fixed
    }
}