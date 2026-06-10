package com.boxhealthy.repository;

import com.boxhealthy.entity.Product;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findTop6ByStatusOrderByIdDesc(String status);
    List<Product> findByStatus(String status);
    long countByStatus(String status);
    List<Product> findByNameContainingIgnoreCaseAndStatus(String name, String status);
    List<Product> findByCategoryIdAndStatus(Long categoryId, String status);
    List<Product> findByNameContainingIgnoreCaseAndCategoryIdAndStatus(String name, Long categoryId, String status);
}
