package com.cinema.modules.seat.service;

import com.cinema.modules.seat.repository.SeatRepository;
import com.cinema.modules.seat.response.SeatResponse;
import com.cinema.modules.seat.entity.ShowtimeSeat;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class SeatService {
    private final SeatRepository seatRepository;

    public SeatService(SeatRepository seatRepository) {
        this.seatRepository = seatRepository;
    }

    public List<SeatResponse> getSeatsByShowtime(Long showtimeId) {
        List<ShowtimeSeat> seats = seatRepository.findByShowtime_ShowtimeId(showtimeId);

        return seats.stream().map(s -> new SeatResponse(
                s.getShowtimeSeatId(),
                s.getSeat().getRowName(),
                s.getSeat().getSeatNumber(),
                s.getSeat().getSeatType().getTypeName(),
                s.getSeat().getSeatType().getPrice(),
                s.getStatus().getStatusName().name()
        )).collect(Collectors.toList());
    }
}