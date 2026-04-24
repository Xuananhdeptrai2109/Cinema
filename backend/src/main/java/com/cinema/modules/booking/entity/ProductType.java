package com.cinema.modules.booking.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Entity
@Table(name = "product_type")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProductType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "productTypeId")
    private Long productTypeId;

    @Column(name = "typeName", unique = true, nullable = false, length = 50)
    private String typeName;

    @OneToMany(mappedBy = "productType")
    private List<Product> products;
}
