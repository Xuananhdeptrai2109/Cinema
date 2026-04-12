package com.cinema.modules.seat.response;

import lombok.*;
import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SeatResponse {
    private Long showtimeSeatId;
    private String rowName;
    private Integer seatNumber;
    private String typeName;
    private BigDecimal price;
    private String statusName;
}