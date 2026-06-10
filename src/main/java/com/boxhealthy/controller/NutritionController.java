package com.boxhealthy.controller;

import com.boxhealthy.service.NutritionService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class NutritionController {
    private final NutritionService nutritionService;

    public NutritionController(NutritionService nutritionService) {
        this.nutritionService = nutritionService;
    }

    @GetMapping("/nutrition")
    public String lookup(@RequestParam(required = false) String keyword, Model model) {
        model.addAttribute("items", nutritionService.search(keyword));
        model.addAttribute("keyword", keyword);
        return "nutrition-lookup";
    }
}
