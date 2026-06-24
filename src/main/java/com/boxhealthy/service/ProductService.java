package com.boxhealthy.service;

import com.boxhealthy.dto.ProductFormDto;
import com.boxhealthy.dto.ProductIngredientDto;
import com.boxhealthy.dto.ProductIngredientFormDto;
import com.boxhealthy.entity.Category;
import com.boxhealthy.entity.NutritionItem;
import com.boxhealthy.entity.Product;
import com.boxhealthy.entity.ProductIngredient;
import com.boxhealthy.exception.ResourceNotFoundException;
import com.boxhealthy.repository.CategoryRepository;
import com.boxhealthy.repository.NutritionItemRepository;
import com.boxhealthy.repository.ProductIngredientRepository;
import com.boxhealthy.repository.ProductRepository;
import jakarta.transaction.Transactional;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Locale;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ProductService {
    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final ProductIngredientRepository productIngredientRepository;
    private final NutritionItemRepository nutritionItemRepository;
    private final String productUploadDir;
    private final String productUrlPrefix;

    public ProductService(ProductRepository productRepository,
                          CategoryRepository categoryRepository,
                          ProductIngredientRepository productIngredientRepository,
                          NutritionItemRepository nutritionItemRepository,
                          @Value("${app.upload.product-dir}") String productUploadDir,
                          @Value("${app.upload.product-url-prefix}") String productUrlPrefix) {
        this.productRepository = productRepository;
        this.categoryRepository = categoryRepository;
        this.productIngredientRepository = productIngredientRepository;
        this.nutritionItemRepository = nutritionItemRepository;
        this.productUploadDir = productUploadDir;
        this.productUrlPrefix = normalizePrefix(productUrlPrefix);
    }

    public List<Product> findFeatured() {
        return productRepository.findTop6ByStatusOrderByIdDesc("ACTIVE");
    }

    public List<Product> search(String keyword, Long categoryId) {
        boolean hasKeyword = keyword != null && !keyword.isBlank();
        if (hasKeyword && categoryId != null) {
            return productRepository.findByNameContainingIgnoreCaseAndCategoryIdAndStatus(keyword, categoryId, "ACTIVE");
        }
        if (hasKeyword) {
            return productRepository.findByNameContainingIgnoreCaseAndStatus(keyword, "ACTIVE");
        }
        if (categoryId != null) {
            return productRepository.findByCategoryIdAndStatus(categoryId, "ACTIVE");
        }
        return productRepository.findByStatus("ACTIVE");
    }

    public List<Product> findAll() {
        return productRepository.findAll();
    }

    public List<Product> searchAdmin(String keyword, Long categoryId) {
        String normalizedKeyword = keyword == null ? "" : keyword.trim().toLowerCase(Locale.ROOT);
        return productRepository.findAll()
                .stream()
                .filter(product -> normalizedKeyword.isEmpty()
                        || containsIgnoreCase(product.getName(), normalizedKeyword)
                        || containsIgnoreCase(product.getDescription(), normalizedKeyword))
                .filter(product -> categoryId == null
                        || (product.getCategory() != null && categoryId.equals(product.getCategory().getId())))
                .toList();
    }

    public long countAll() {
        return productRepository.count();
    }

    public long countActive() {
        return productRepository.countByStatus("ACTIVE");
    }

    public Product getById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy sản phẩm"));
    }

    public List<ProductIngredientDto> getIngredientBreakdown(Product product) {
        return productIngredientRepository.findByProductIdOrderByDisplayOrderAscIdAsc(product.getId())
                .stream()
                .map(this::toIngredientDto)
                .toList();
    }

    public Product save(ProductFormDto form) {
        return save(form, null);
    }

    @Transactional
    public Product save(ProductFormDto form, MultipartFile imageFile) {
        Product product = form.getId() == null ? new Product() : getById(form.getId());
        product.setName(form.getName());
        product.setDescription(form.getDescription());

        String uploadedImageUrl = storeProductImage(imageFile);
        if (uploadedImageUrl != null) {
            product.setImageUrl(uploadedImageUrl);
        } else {
            product.setImageUrl(form.getImageUrl());
        }

        product.setPrice(form.getPrice());
        product.setCalories(form.getCalories());
        product.setProtein(form.getProtein());
        product.setCarbs(form.getCarbs());
        product.setFat(form.getFat());
        product.setStockQuantity(form.getStockQuantity());
        product.setStatus(form.getStatus());

        if (form.getCategoryId() != null) {
            Category category = categoryRepository.findById(form.getCategoryId())
                    .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy danh mục"));
            product.setCategory(category);
        } else {
            product.setCategory(null);
        }

        Product savedProduct = productRepository.save(product);
        syncIngredients(savedProduct, form.getIngredients());
        return savedProduct;
    }

    public ProductFormDto toForm(Product product) {
        ProductFormDto form = new ProductFormDto();
        form.setId(product.getId());
        form.setName(product.getName());
        form.setDescription(product.getDescription());
        form.setImageUrl(product.getImageUrl());
        form.setPrice(product.getPrice());
        form.setCalories(product.getCalories());
        form.setProtein(product.getProtein());
        form.setCarbs(product.getCarbs());
        form.setFat(product.getFat());
        form.setStockQuantity(product.getStockQuantity());
        form.setStatus(product.getStatus());
        if (product.getCategory() != null) {
            form.setCategoryId(product.getCategory().getId());
        }

        form.setIngredients(productIngredientRepository.findByProductIdOrderByDisplayOrderAscIdAsc(product.getId())
                .stream()
                .map(this::toIngredientFormDto)
                .toList());
        return form;
    }

    @Transactional
    public void delete(Long id) {
        Product product = getById(id);
        product.setStatus("INACTIVE");
        productRepository.save(product);
    }

    private void syncIngredients(Product product, List<ProductIngredientFormDto> ingredientForms) {
        productIngredientRepository.deleteByProductId(product.getId());
        if (ingredientForms == null || ingredientForms.isEmpty()) {
            return;
        }

        int displayOrder = 1;
        int totalCalories = 0;
        double totalProtein = 0;
        double totalCarbs = 0;
        double totalFat = 0;
        boolean hasValidIngredient = false;

        for (ProductIngredientFormDto form : ingredientForms) {
            if (form == null || form.getNutritionItemId() == null || form.getWeightGram() == null || form.getWeightGram() <= 0) {
                continue;
            }

            NutritionItem nutritionItem = nutritionItemRepository.findById(form.getNutritionItemId())
                    .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy thực phẩm dinh dưỡng"));
            double ratio = form.getWeightGram() / 100.0;
            int calories = (int) Math.round(nullToZero(nutritionItem.getCalories()) * ratio);
            double protein = round1(nullToZero(nutritionItem.getProtein()) * ratio);
            double carbs = round1(nullToZero(nutritionItem.getCarbs()) * ratio);
            double fat = round1(nullToZero(nutritionItem.getFat()) * ratio);

            ProductIngredient ingredient = new ProductIngredient();
            ingredient.setProduct(product);
            ingredient.setNutritionItem(nutritionItem);
            ingredient.setName(nutritionItem.getFoodName());
            ingredient.setNote(form.getNote());
            ingredient.setWeightGram(form.getWeightGram());
            ingredient.setCalories(calories);
            ingredient.setProtein(protein);
            ingredient.setCarbs(carbs);
            ingredient.setFat(fat);
            ingredient.setDisplayOrder(displayOrder++);
            productIngredientRepository.save(ingredient);

            totalCalories += calories;
            totalProtein += protein;
            totalCarbs += carbs;
            totalFat += fat;
            hasValidIngredient = true;
        }

        if (hasValidIngredient) {
            product.setCalories(totalCalories);
            product.setProtein(round1(totalProtein));
            product.setCarbs(round1(totalCarbs));
            product.setFat(round1(totalFat));
            productRepository.save(product);
        }
    }

    private ProductIngredientDto toIngredientDto(ProductIngredient ingredient) {
        return new ProductIngredientDto(
                ingredient.getName(),
                ingredient.getNote(),
                ingredient.getWeightGram(),
                ingredient.getCalories(),
                ingredient.getProtein(),
                ingredient.getCarbs(),
                ingredient.getFat()
        );
    }

    private ProductIngredientFormDto toIngredientFormDto(ProductIngredient ingredient) {
        ProductIngredientFormDto form = new ProductIngredientFormDto();
        if (ingredient.getNutritionItem() != null) {
            form.setNutritionItemId(ingredient.getNutritionItem().getId());
        } else {
            nutritionItemRepository.findByFoodNameContainingIgnoreCase(ingredient.getName())
                    .stream()
                    .filter(item -> item.getFoodName().equalsIgnoreCase(ingredient.getName()))
                    .findFirst()
                    .ifPresent(item -> form.setNutritionItemId(item.getId()));
        }
        form.setNote(ingredient.getNote());
        form.setWeightGram(ingredient.getWeightGram());
        return form;
    }

    private double nullToZero(Double value) {
        return value == null ? 0.0 : value;
    }

    private int nullToZero(Integer value) {
        return value == null ? 0 : value;
    }

    private double round1(double value) {
        return Math.round(value * 10.0) / 10.0;
    }

    private boolean containsIgnoreCase(String value, String normalizedKeyword) {
        return value != null && value.toLowerCase(Locale.ROOT).contains(normalizedKeyword);
    }

    private String storeProductImage(MultipartFile imageFile) {
        if (imageFile == null || imageFile.isEmpty()) {
            return null;
        }

        String contentType = imageFile.getContentType();
        if (contentType == null || !contentType.toLowerCase(Locale.ROOT).startsWith("image/")) {
            throw new IllegalArgumentException("File upload phải là ảnh");
        }

        String originalFilename = imageFile.getOriginalFilename();
        String extension = getExtension(originalFilename);
        String filename = UUID.randomUUID() + extension;
        Path uploadDir = Paths.get(productUploadDir).toAbsolutePath().normalize();
        Path target = uploadDir.resolve(filename).normalize();

        try {
            Files.createDirectories(uploadDir);
            Files.copy(imageFile.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
            return productUrlPrefix + "/" + filename;
        } catch (IOException ex) {
            throw new IllegalStateException("Không thể lưu ảnh sản phẩm", ex);
        }
    }

    private String getExtension(String filename) {
        if (filename == null) {
            return ".jpg";
        }
        String cleanName = Paths.get(filename).getFileName().toString();
        int dotIndex = cleanName.lastIndexOf('.');
        if (dotIndex < 0 || dotIndex == cleanName.length() - 1) {
            return ".jpg";
        }
        return cleanName.substring(dotIndex).toLowerCase(Locale.ROOT);
    }

    private String normalizePrefix(String prefix) {
        if (prefix == null || prefix.isBlank()) {
            return "/uploads/products";
        }
        String normalized = prefix.startsWith("/") ? prefix : "/" + prefix;
        return normalized.endsWith("/") ? normalized.substring(0, normalized.length() - 1) : normalized;
    }
}
