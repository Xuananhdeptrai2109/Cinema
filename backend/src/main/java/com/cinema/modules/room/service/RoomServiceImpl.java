package com.cinema.modules.room.service;

import com.cinema.modules.room.entity.Room;
import com.cinema.modules.room.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class RoomServiceImpl implements RoomService {

    private final RoomRepository roomRepository;

    // Sử dụng Constructor thay cho @Autowired trực tiếp trên field
    public RoomServiceImpl(RoomRepository roomRepository) {
        this.roomRepository = roomRepository;
    }

    @Override
    public List<String> getScreeningTypesByCinema(Long cinemaId) {
        List<Room> rooms = roomRepository.findByCinema_CinemasId(cinemaId);
        return rooms.stream()
                .map(room -> room.getScreeningFormat().getType())
                .distinct()
                .collect(Collectors.toList());
    }
}
