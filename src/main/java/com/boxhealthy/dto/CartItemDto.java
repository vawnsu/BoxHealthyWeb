package com.boxhealthy.dto;

import com.boxhealthy.entity.Product;
import java.math.BigDecimal;

public class CartItemDto {
    private Product product;
    private int quantity;

    public CartItemDto(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BigDecimal getSubtotal() {
        return product.getPrice().multiply(BigDecimal.valueOf(quantity));
    }
}
