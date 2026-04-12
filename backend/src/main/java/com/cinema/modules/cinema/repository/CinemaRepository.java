package com.cinema.modules.cinema.repository;

import com.cinema.modules.cinema.entity.Cinema;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CinemaRepository extends JpaRepository<Cinema, Long> {

    // Lấy danh sách rạp thuộc một tỉnh cụ thể
    List<Cinema> findByProvince_ProvinceId(Long provinceId);

    // Tìm kiếm rạp theo tên (hỗ trợ tính năng search trên Home)
    List<Cinema> findByCinemaNameContainingIgnoreCase(String name);

    // Truy vấn rạp dựa trên tên của Province liên kết
    List<Cinema> findByProvince_ProvinceName(String provinceName);
}