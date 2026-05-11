package com.cinema.modules.discount.controller;

import com.cinema.modules.discount.entity.Discount;
import com.cinema.modules.discount.repository.DiscountRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/discounts")
public class AdminDiscountController {
    private final DiscountRepository discountRepository;

    public AdminDiscountController(DiscountRepository discountRepository) {
        this.discountRepository = discountRepository;
    }

    @GetMapping
    public ResponseEntity<List<Discount>> getAll() {
        return ResponseEntity.ok(discountRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Discount> getById(@PathVariable Long id) {
        return discountRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Discount> create(@RequestBody Map<String, Object> body) {
        Discount discount = new Discount();
        applyPayload(discount, body);
        return ResponseEntity.ok(discountRepository.save(discount));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Discount> update(@PathVariable Long id, @RequestBody Map<String, Object> body) {
        Discount discount = discountRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy mã giảm giá"));

        applyPayload(discount, body);
        return ResponseEntity.ok(discountRepository.save(discount));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        discountRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    private void applyPayload(Discount discount, Map<String, Object> body) {
        discount.setDiscountTitle((String) body.get("discountTitle"));
        discount.setDiscountDescription((String) body.get("discountDescription"));
        discount.setDiscountCode((String) body.get("discountCode"));

        if (body.get("discountType") != null) {
            discount.setDiscountType(Discount.DiscountType.valueOf(body.get("discountType").toString()));
        }

        if (body.get("discountValue") != null) {
            discount.setDiscountValue(new BigDecimal(body.get("discountValue").toString()));
        }

        if (body.get("maxUsage") != null) {
            discount.setMaxUsage(Integer.valueOf(body.get("maxUsage").toString()));
        }

        if (body.get("startDate") != null) {
            discount.setStartDate(LocalDate.parse(body.get("startDate").toString()));
        }

        if (body.get("endDate") != null) {
            discount.setEndDate(LocalDate.parse(body.get("endDate").toString()));
        }

        if (discount.getCurrentUsage() == null) {
            discount.setCurrentUsage(0);
        }

        if (discount.getIsUsed() == null) {
            discount.setIsUsed(false);
        }
    }
}
