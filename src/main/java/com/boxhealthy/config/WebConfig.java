package com.boxhealthy.config;

import java.nio.file.Path;
import java.nio.file.Paths;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    private final String productUploadDir;
    private final String productUrlPrefix;

    public WebConfig(@Value("${app.upload.product-dir}") String productUploadDir,
                     @Value("${app.upload.product-url-prefix}") String productUrlPrefix) {
        this.productUploadDir = productUploadDir;
        this.productUrlPrefix = productUrlPrefix;
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String pattern = normalizePrefix(productUrlPrefix) + "/**";
        Path uploadPath = Paths.get(productUploadDir).toAbsolutePath().normalize();
        String location = uploadPath.toUri().toString();
        registry.addResourceHandler(pattern).addResourceLocations(location);
    }

    private String normalizePrefix(String prefix) {
        if (prefix == null || prefix.isBlank()) {
            return "/uploads/products";
        }
        String normalized = prefix.startsWith("/") ? prefix : "/" + prefix;
        return normalized.endsWith("/") ? normalized.substring(0, normalized.length() - 1) : normalized;
    }
}
