package com.cinema.modules.movie.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Director")
@Getter
@Setter
public class Director {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "director_id")
    private Long id;

    @Column(name = "director_name")
    private String directorName;
}