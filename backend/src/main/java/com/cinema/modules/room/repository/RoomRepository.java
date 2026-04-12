package com.cinema.modules.room.repository;

import com.cinema.modules.room.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long> {
    // Thêm dòng này để IntelliJ nhận diện được hàm tìm kiếm
    List<Room> findByCinema_CinemasId(Long cinemaId);
}