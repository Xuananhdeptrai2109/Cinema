package com.cinema.modules.movie.repository;

import com.cinema.modules.movie.entity.Performer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PerformerRepository extends JpaRepository<Performer, Long> {
    Optional<Performer> findByPerformerName(String performerName);
}
