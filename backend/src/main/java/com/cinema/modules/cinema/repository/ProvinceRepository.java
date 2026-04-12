package com.cinema.modules.cinema.repository;

import com.cinema.modules.cinema.entity.ProvinceCity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProvinceRepository extends JpaRepository<ProvinceCity, Long> {

    // Lấy tất cả tỉnh và nạp sẵn (Eager load) danh sách rạp để tối ưu hiệu năng
    @Query("SELECT DISTINCT p FROM ProvinceCity p LEFT JOIN FETCH p.cinemas")
    List<ProvinceCity> findAllWithCinemas();

    // Tìm kiếm tỉnh theo tên (nếu cần)
    ProvinceCity findByProvinceName(String provinceName);
}