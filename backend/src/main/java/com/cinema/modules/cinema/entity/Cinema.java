package com.cinema.modules.cinema.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

@Data
@Entity
@Table(name = "cinemas")
public class Cinema {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cinemas_id") // Khớp với SQL: cinemas_id
    private Long cinemasId;

    @Column(name = "cinema_name", nullable = false) // Khớp với SQL: cinema_name
    private String cinemaName;

    @Column(name = "address", nullable = false) // Khớp với SQL: address
    private String address;

    @Column(name = "fax") // Khớp với SQL: fax
    private String fax;

    @Column(name = "hotline") // Khớp với SQL: hotline
    private String hotline;

    @Column(name = "imageUrl") // Khớp với SQL: imageUrl (viết liền)
    private String imageUrl;

    @Column(name = "mapUrl") // Khớp với SQL: mapUrl (viết liền)
    private String mapUrl;

    @ManyToOne
    @JoinColumn(name = "province_id") // Khớp với FOREIGN KEY province_id
    @JsonIgnore
    private ProvinceCity province;
}