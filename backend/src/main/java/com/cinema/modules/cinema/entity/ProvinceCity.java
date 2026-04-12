package com.cinema.modules.cinema.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.List;

@Entity
@Table(name = "Province_city")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProvinceCity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "province_id")
    private Long provinceId;

    @Column(name = "province_name", nullable = false, unique = true)
    private String provinceName;

    @OneToMany(mappedBy = "province")
    private List<Cinema> cinemas;
}