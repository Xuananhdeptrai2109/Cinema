package com.cinema.modules.seat.repository;

import com.cinema.modules.seat.entity.Status;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface StatusRepository extends JpaRepository<Status, Long> {
    Optional<Status> findByStatusName(Status.SeatStatusName statusName);
}