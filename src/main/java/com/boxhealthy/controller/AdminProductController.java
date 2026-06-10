package com.boxhealthy.controller;

import com.boxhealthy.dto.ProductIngredientFormDto;
import com.boxhealthy.dto.ProductFormDto;
import com.boxhealthy.service.CategoryService;
import com.boxhealthy.service.NutritionService;
import com.boxhealthy.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class AdminProductController {
    private final ProductService productService;
    private final CategoryService categoryService;
    private final NutritionService nutritionService;

    public AdminProductController(ProductService productService,
                                  CategoryService categoryService,
                                  NutritionService nutritionService) {
        this.productService = productService;
        this.categoryService = categoryService;
        this.nutritionService = nutritionService;
    }

    @GetMapping("/admin/products")
    public String list(Model model) {
        model.addAttribute("products", productService.findAll());
        return "admin-products";
    }

    @GetMapping("/admin/products/new")
    public String create(Model model) {
        ProductFormDto form = new ProductFormDto();
        form.getIngredients().add(new ProductIngredientFormDto());
        prepareFormModel(model, form);
        return "admin-product-form";
    }

    @GetMapping("/admin/products/{id}/edit")
    public String edit(@PathVariable Long id, Model model) {
        ProductFormDto form = productService.toForm(productService.getById(id));
        if (form.getIngredients().isEmpty()) {
            form.getIngredients().add(new ProductIngredientFormDto());
        }
        prepareFormModel(model, form);
        return "admin-product-form";
    }

    @PostMapping("/admin/products/save")
    public String save(@ModelAttribute ProductFormDto form,
                       @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) {
        productService.save(form, imageFile);
        return "redirect:/admin/products";
    }

    @PostMapping("/admin/products/{id}/delete")
    public String delete(@PathVariable Long id) {
        productService.delete(id);
        return "redirect:/admin/products";
    }

    private void prepareFormModel(Model model, ProductFormDto form) {
        model.addAttribute("productForm", form);
        model.addAttribute("categories", categoryService.findAll());
        model.addAttribute("nutritionItems", nutritionService.findAll());
    }
}
