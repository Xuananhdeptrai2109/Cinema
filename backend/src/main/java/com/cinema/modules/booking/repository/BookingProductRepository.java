package com.cinema.modules.booking.repository;

import com.cinema.modules.booking.entity.BookingProduct;
import com.cinema.modules.booking.entity.BookingProductId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BookingProductRepository extends JpaRepository<BookingProduct, BookingProductId> {
}