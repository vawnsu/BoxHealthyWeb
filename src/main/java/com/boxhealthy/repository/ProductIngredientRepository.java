package com.boxhealthy.repository;

import com.boxhealthy.entity.ProductIngredient;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductIngredientRepository extends JpaRepository<ProductIngredient, Long> {
    List<ProductIngredient> findByProductIdOrderByDisplayOrderAscIdAsc(Long productId);
    void deleteByProductId(Long productId);
}
