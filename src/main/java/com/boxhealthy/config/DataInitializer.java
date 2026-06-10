package com.boxhealthy.config;

import com.boxhealthy.entity.Category;
import com.boxhealthy.entity.NutritionItem;
import com.boxhealthy.entity.Product;
import com.boxhealthy.entity.Role;
import com.boxhealthy.entity.User;
import com.boxhealthy.repository.CategoryRepository;
import com.boxhealthy.repository.NutritionItemRepository;
import com.boxhealthy.repository.ProductRepository;
import com.boxhealthy.repository.UserRepository;
import java.math.BigDecimal;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {
    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;
    private final NutritionItemRepository nutritionItemRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final boolean seedEnabled;

    public DataInitializer(CategoryRepository categoryRepository, ProductRepository productRepository,
                           NutritionItemRepository nutritionItemRepository, UserRepository userRepository,
                           PasswordEncoder passwordEncoder,
                           @Value("${boxhealthy.seed.enabled:false}") boolean seedEnabled) {
        this.categoryRepository = categoryRepository;
        this.productRepository = productRepository;
        this.nutritionItemRepository = nutritionItemRepository;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.seedEnabled = seedEnabled;
    }

    @Override
    public void run(String... args) {
        if (!seedEnabled) {
            return;
        }
        seedAdmin();
        if (categoryRepository.count() == 0) {
            Category proteinBox = category("Box Đạm Đóng Gói Sẵn", "Sản phẩm chính, đủ đạm, tiện lợi và minh bạch nguồn nguyên liệu");
            Category breakfastSet = category("Set Ăn Sáng Healthy", "Bữa sáng nhanh gọn, phù hợp giao sớm trước 8 giờ");
            Category cleanCake = category("Bánh Eat Clean", "Sản phẩm bán kèm, nhẹ bụng và dễ mang theo");
            categoryRepository.saveAll(List.of(proteinBox, breakfastSet, cleanCake));
        }
        if (productRepository.count() == 0) {
            List<Category> categories = categoryRepository.findAll();
            Category proteinBox = categories.get(0);
            Category breakfastSet = categories.size() > 1 ? categories.get(1) : proteinBox;
            Category cleanCake = categories.size() > 2 ? categories.get(2) : proteinBox;
            productRepository.save(product("Box Đạm Gà Gạo Lứt", "Ức gà nướng, trứng luộc, rau củ và cơm gạo lứt đóng gói sẵn, tiện lợi cho bữa chính.", "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80", "65000", 520, 38.0, 52.0, 13.0, proteinBox));
            productRepository.save(product("Set Ăn Sáng Healthy", "Yến mạch, sữa chua, trứng và trái cây theo khẩu phần gọn nhẹ cho buổi sáng.", "https://images.unsplash.com/photo-1494390248081-4e521a5940db?auto=format&fit=crop&w=900&q=80", "35000", 360, 18.0, 48.0, 9.0, breakfastSet));
            productRepository.save(product("Bánh Eat Clean Yến Mạch", "Bánh yến mạch ít ngọt, dùng như món bán kèm khi đặt box healthy.", "https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?auto=format&fit=crop&w=900&q=80", "22000", 180, 6.0, 24.0, 7.0, cleanCake));
        }
        if (nutritionItemRepository.count() == 0) {
            nutritionItemRepository.save(nutrition("Ức gà luộc", 165, 31.0, 0.0, 3.6));
            nutritionItemRepository.save(nutrition("Cơm trắng", 130, 2.7, 28.0, 0.3));
            nutritionItemRepository.save(nutrition("Khoai lang luộc", 86, 1.6, 20.1, 0.1));
            nutritionItemRepository.save(nutrition("Trứng gà luộc", 155, 13.0, 1.1, 11.0));
            nutritionItemRepository.save(nutrition("Bông cải xanh", 34, 2.8, 6.6, 0.4));
            nutritionItemRepository.save(nutrition("Thịt bò thăn", 207, 26.0, 0.0, 11.0));
        }
    }

    private void seedAdmin() {
        if (!userRepository.existsByEmail("admin@boxhealthy.vn")) {
            User admin = new User();
            admin.setFullName("Box Healthy Admin");
            admin.setEmail("admin@boxhealthy.vn");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setRole(Role.ADMIN);
            admin.setEnabled(true);
            userRepository.save(admin);
        }
    }

    private Category category(String name, String description) {
        Category category = new Category();
        category.setName(name);
        category.setDescription(description);
        category.setStatus("ACTIVE");
        return category;
    }

    private Product product(String name, String description, String imageUrl, String price, int calories,
                            double protein, double carbs, double fat, Category category) {
        Product product = new Product();
        product.setName(name);
        product.setDescription(description);
        product.setImageUrl(imageUrl);
        product.setPrice(new BigDecimal(price));
        product.setCalories(calories);
        product.setProtein(protein);
        product.setCarbs(carbs);
        product.setFat(fat);
        product.setStockQuantity(100);
        product.setStatus("ACTIVE");
        product.setCategory(category);
        return product;
    }

    private NutritionItem nutrition(String name, int calories, double protein, double carbs, double fat) {
        NutritionItem item = new NutritionItem();
        item.setFoodName(name);
        item.setCalories(calories);
        item.setProtein(protein);
        item.setCarbs(carbs);
        item.setFat(fat);
        return item;
    }
}
