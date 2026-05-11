package com.cinema.modules.booking.controller;

import com.cinema.modules.booking.entity.Product;
import com.cinema.modules.booking.entity.ProductType;
import com.cinema.modules.booking.repository.ProductRepository;
import com.cinema.modules.booking.repository.ProductTypeRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/products")
public class AdminProductController {
    private final ProductRepository productRepository;
    private final ProductTypeRepository productTypeRepository;

    public AdminProductController(ProductRepository productRepository, ProductTypeRepository productTypeRepository) {
        this.productRepository = productRepository;
        this.productTypeRepository = productTypeRepository;
    }

    @GetMapping
    public ResponseEntity<List<Product>> getAll() {
        return ResponseEntity.ok(productRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getById(@PathVariable Long id) {
        return productRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Product> create(@RequestBody Map<String, Object> body) {
        Product product = new Product();
        applyPayload(product, body);
        return ResponseEntity.ok(productRepository.save(product));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Product> update(@PathVariable Long id, @RequestBody Map<String, Object> body) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm"));

        applyPayload(product, body);
        return ResponseEntity.ok(productRepository.save(product));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        productRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    private void applyPayload(Product product, Map<String, Object> body) {
        product.setProductName((String) body.get("productName"));
        product.setDescription((String) body.get("description"));
        product.setImageUrl((String) body.get("imageUrl"));

        if (body.get("price") != null) {
            product.setPrice(new BigDecimal(body.get("price").toString()));
        }

        if (body.get("quantity") != null) {
            product.setQuantity(Integer.valueOf(body.get("quantity").toString()));
        }

        if (body.get("isAvailable") != null) {
            product.setAvailable(Boolean.parseBoolean(body.get("isAvailable").toString()));
        }

        if (body.get("productTypeId") != null) {
            Long productTypeId = Long.valueOf(body.get("productTypeId").toString());
            ProductType productType = productTypeRepository.findById(productTypeId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy loại sản phẩm"));
            product.setProductType(productType);
        }
    }
}
