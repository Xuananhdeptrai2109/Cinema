package com.cinema.modules.movie.repository;

import com.cinema.modules.movie.entity.Director;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DirectorRepository extends JpaRepository<Director, Long> {
    Optional<Director> findByDirectorName(String directorName);
}
