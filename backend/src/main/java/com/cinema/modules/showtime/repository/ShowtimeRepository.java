package com.cinema.modules.showtime.repository;

import com.cinema.modules.showtime.entity.Showtime;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ShowtimeRepository extends JpaRepository<Showtime, Long> {
    @Query("SELECT s FROM Showtime s WHERE s.room.cinema.cinemasId = :cinemaId AND s.showDate = :showDate")
    List<Showtime> findByCinemaAndDate(@Param("cinemaId") Long cinemaId, @Param("showDate") LocalDate showDate);
}