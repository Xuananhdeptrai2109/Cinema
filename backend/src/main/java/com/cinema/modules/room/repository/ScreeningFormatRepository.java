package com.cinema.modules.room.repository;

import com.cinema.modules.room.entity.ScreeningFormat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ScreeningFormatRepository extends JpaRepository<ScreeningFormat, Long> {
    Optional<ScreeningFormat> findByType(String type);
}
