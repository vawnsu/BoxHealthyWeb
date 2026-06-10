package com.boxhealthy.service;

import com.boxhealthy.entity.NutritionItem;
import com.boxhealthy.repository.NutritionItemRepository;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class NutritionService {
    private final NutritionItemRepository nutritionItemRepository;

    public NutritionService(NutritionItemRepository nutritionItemRepository) {
        this.nutritionItemRepository = nutritionItemRepository;
    }

    public List<NutritionItem> search(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return nutritionItemRepository.findAll();
        }
        return nutritionItemRepository.findByFoodNameContainingIgnoreCase(keyword);
    }

    public List<NutritionItem> findAll() {
        return nutritionItemRepository.findAll();
    }
}
