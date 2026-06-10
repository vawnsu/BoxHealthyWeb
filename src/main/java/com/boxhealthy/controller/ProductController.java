package com.boxhealthy.controller;

import com.boxhealthy.service.CategoryService;
import com.boxhealthy.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ProductController {
    private final ProductService productService;
    private final CategoryService categoryService;

    public ProductController(ProductService productService, CategoryService categoryService) {
        this.productService = productService;
        this.categoryService = categoryService;
    }

    @GetMapping("/products")
    public String list(@RequestParam(required = false) String keyword,
                       @RequestParam(required = false) Long categoryId,
                       Model model) {
        model.addAttribute("products", productService.search(keyword, categoryId));
        model.addAttribute("categories", categoryService.findActive());
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryId", categoryId);
        return "product-list";
    }

    @GetMapping("/products/{id}")
    public String detail(@PathVariable Long id, Model model) {
        var product = productService.getById(id);
        model.addAttribute("product", product);
        model.addAttribute("ingredientBreakdown", productService.getIngredientBreakdown(product));
        model.addAttribute("relatedProducts", productService.findFeatured());
        return "product-detail";
    }
}
