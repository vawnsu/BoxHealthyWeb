package com.boxhealthy.repository;

import com.boxhealthy.entity.NutritionItem;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NutritionItemRepository extends JpaRepository<NutritionItem, Long> {
    List<NutritionItem> findByFoodNameContainingIgnoreCase(String foodName);
}
