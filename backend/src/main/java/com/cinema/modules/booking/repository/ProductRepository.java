package com.cinema.modules.booking.repository;

import com.cinema.modules.booking.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    // Tìm danh sách sản phẩm theo loại (VD: lấy tất cả 'Combo' hoặc 'Nước uống')
    List<Product> findByProductType_ProductTypeId(Long productTypeId);

    // Tìm sản phẩm theo tên (phục vụ tìm kiếm nhanh)
    List<Product> findByProductNameContainingIgnoreCase(String productName);
}