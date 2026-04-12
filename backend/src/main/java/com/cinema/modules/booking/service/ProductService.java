package com.cinema.modules.booking.service;

import com.cinema.modules.booking.entity.Product;
import com.cinema.modules.booking.repository.ProductRepository;
import com.cinema.modules.booking.response.ProductResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository productRepository;

    public List<ProductResponse> getAllCombos() {
        return productRepository.findAll().stream().map(product ->
                ProductResponse.builder()
                        .id(product.getProductId())
                        .name(product.getProductName())
                        .price(product.getPrice())
                        .imageUrl(product.getImageUrl())
                        .typeName(product.getProductType().getTypeName())
                        .build()
        ).collect(Collectors.toList());
    }
}