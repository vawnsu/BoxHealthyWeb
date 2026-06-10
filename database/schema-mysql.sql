SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS order_detail;
DROP TABLE IF EXISTS cart_item;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS product_ingredient;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS nutrition_item;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    address VARCHAR(500),
    role VARCHAR(30) NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE category (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    description VARCHAR(1000),
    status VARCHAR(30)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE product (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    description VARCHAR(2000),
    image_url VARCHAR(500),
    price DECIMAL(18,2),
    calories INT,
    protein DOUBLE,
    carbs DOUBLE,
    fat DOUBLE,
    stock_quantity INT,
    status VARCHAR(30),
    category_id BIGINT NULL,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES category(id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE nutrition_item (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    food_name VARCHAR(255),
    calories INT,
    protein DOUBLE,
    carbs DOUBLE,
    fat DOUBLE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE product_ingredient (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    nutrition_item_id BIGINT NULL,
    name VARCHAR(255) NOT NULL,
    note VARCHAR(500),
    weight_gram INT,
    calories INT,
    protein DOUBLE,
    carbs DOUBLE,
    fat DOUBLE,
    display_order INT,
    CONSTRAINT fk_product_ingredient_product FOREIGN KEY (product_id) REFERENCES product(id),
    CONSTRAINT fk_product_ingredient_nutrition FOREIGN KEY (nutrition_item_id) REFERENCES nutrition_item(id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE cart (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    created_at DATETIME,
    updated_at DATETIME,
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users(id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE cart_item (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cart_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT fk_cart_item_cart FOREIGN KEY (cart_id) REFERENCES cart(id),
    CONSTRAINT fk_cart_item_product FOREIGN KEY (product_id) REFERENCES product(id),
    CONSTRAINT uk_cart_item_product UNIQUE (cart_id, product_id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NULL,
    customer_name VARCHAR(255),
    phone VARCHAR(50),
    email VARCHAR(255),
    address VARCHAR(500),
    note VARCHAR(1000),
    payment_method VARCHAR(50),
    delivery_time VARCHAR(255),
    total_amount DECIMAL(18,2),
    order_status VARCHAR(30),
    created_at DATETIME,
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE order_detail (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT,
    price DECIMAL(18,2),
    subtotal DECIMAL(18,2),
    CONSTRAINT fk_order_detail_order FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_order_detail_product FOREIGN KEY (product_id) REFERENCES product(id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO users (full_name, email, password, phone, address, role, enabled, created_at)
VALUES
('Box Healthy Admin', 'admin@boxhealthy.vn', '$2a$10$Z6af9vPuWv7uJfwRnpRxYOwiuXuiW9a/v0lXCgEVrXpFgvhdXQzS6', NULL, NULL, 'ADMIN', TRUE, NOW());

INSERT INTO category (name, description, status)
VALUES
('Box Dam Dong Goi San', 'San pham chinh, du dam, tien loi va minh bach nguon nguyen lieu', 'ACTIVE'),
('Set An Sang Healthy', 'Bua sang nhanh gon, phu hop giao som truoc 8 gio', 'ACTIVE'),
('Banh Eat Clean', 'San pham ban kem, nhe bung va de mang theo', 'ACTIVE');

INSERT INTO product (name, description, image_url, price, calories, protein, carbs, fat, stock_quantity, status, category_id)
VALUES
('Box Dam Ga Gao Lut', 'Uc ga nuong, trung luoc, rau cu va com gao lut dong goi san, tien loi cho bua chinh.', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80', 65000, 520, 38, 52, 13, 100, 'ACTIVE', 1),
('Set An Sang Healthy', 'Yen mach, sua chua, trung va trai cay theo khau phan gon nhe cho buoi sang.', 'https://images.unsplash.com/photo-1494390248081-4e521a5940db?auto=format&fit=crop&w=900&q=80', 35000, 360, 18, 48, 9, 100, 'ACTIVE', 2),
('Banh Eat Clean Yen Mach', 'Banh yen mach it ngot, dung nhu mon ban kem khi dat box healthy.', 'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?auto=format&fit=crop&w=900&q=80', 22000, 180, 6, 24, 7, 100, 'ACTIVE', 3);

INSERT INTO product_ingredient (product_id, name, note, weight_gram, calories, protein, carbs, fat, display_order)
VALUES
(1, 'Uc ga nuong', 'Protein chinh, it mo', 150, 248, 46.5, 0, 5.4, 1),
(1, 'Trung luoc', 'Bo sung dam va chat beo tot', 55, 85, 7, 0.6, 5.8, 2),
(1, 'Com gao lut', 'Tinh bot cham', 150, 166, 3.9, 34.5, 1.3, 3),
(1, 'Bong cai xanh', 'Rau xanh giau chat xo', 90, 31, 2.5, 6, 0.3, 4),
(1, 'Sot me rang healthy', 'Tang vi, dung luong nho', 20, 28, 1, 3.2, 1.5, 5),
(2, 'Yen mach', 'Tinh bot tot cho bua sang', 55, 214, 9.3, 36.4, 3.8, 1),
(2, 'Sua chua khong duong', 'Ho tro tieu hoa', 100, 61, 3.5, 4.7, 3.3, 2),
(2, 'Trung luoc', 'Dam nhanh, no lau', 55, 85, 7, 0.6, 5.8, 3),
(2, 'Chuoi', 'Bo sung nang luong', 80, 71, 0.9, 18.4, 0.2, 4),
(2, 'Hat chia', 'Chat xo va omega-3', 8, 39, 1.3, 3.4, 2.5, 5),
(3, 'Yen mach can det', 'Nen banh giau chat xo', 35, 136, 5.9, 23.2, 2.4, 1),
(3, 'Chuoi chin', 'Tao vi ngot tu nhien', 55, 49, 0.6, 12.6, 0.2, 2),
(3, 'Bo dau phong', 'Tang vi beo, dung luong nho', 12, 71, 3, 2.4, 6, 3),
(3, 'Hanh nhan lat', 'Chat beo tot', 8, 46, 1.7, 1.7, 4, 4),
(3, 'Bot cacao', 'Tao vi chocolate nhe', 4, 9, 0.8, 2.3, 0.5, 5);

INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat)
VALUES
('Uc ga luoc', 165, 31, 0, 3.6),
('Com trang', 130, 2.7, 28, 0.3),
('Khoai lang luoc', 86, 1.6, 20.1, 0.1),
('Trung ga luoc', 155, 13, 1.1, 11),
('Bong cai xanh', 34, 2.8, 6.6, 0.4),
('Thit bo than', 207, 26, 0, 11),
('Uc ga nuong', 165, 31, 0, 3.6),
('Trung luoc', 155, 13, 1.1, 10.6),
('Com gao lut', 111, 2.6, 23, 0.9),
('Sot me rang healthy', 140, 5, 16, 7.5),
('Yen mach', 389, 16.9, 66.3, 6.9),
('Sua chua khong duong', 61, 3.5, 4.7, 3.3),
('Chuoi', 89, 1.1, 23, 0.3),
('Hat chia', 486, 16.5, 42.1, 30.7),
('Yen mach can det', 389, 16.9, 66.3, 6.9),
('Chuoi chin', 89, 1.1, 23, 0.3),
('Bo dau phong', 588, 25, 20, 50),
('Hanh nhan lat', 575, 21.2, 21.7, 49.4),
('Bot cacao', 228, 19.6, 57.9, 13.7);
