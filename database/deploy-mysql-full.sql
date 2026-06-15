-- Full MySQL deployment script for BoxHealthy.
-- Run this while connected to the BoxHealthy MySQL database.
-- This script recreates all tables and inserts clean Vietnamese sample data.

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS order_detail;
DROP TABLE IF EXISTS notification;
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
    id BIGINT NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(255),
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    address VARCHAR(500),
    role VARCHAR(30) NOT NULL,
    enabled TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE category (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255),
    description VARCHAR(1000),
    status VARCHAR(30),
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE nutrition_item (
    id BIGINT NOT NULL AUTO_INCREMENT,
    food_name VARCHAR(255),
    calories INT,
    protein DOUBLE,
    carbs DOUBLE,
    fat DOUBLE,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE product (
    id BIGINT NOT NULL AUTO_INCREMENT,
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
    PRIMARY KEY (id),
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES category(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE product_ingredient (
    id BIGINT NOT NULL AUTO_INCREMENT,
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
    PRIMARY KEY (id),
    CONSTRAINT fk_product_ingredient_product FOREIGN KEY (product_id) REFERENCES product(id),
    CONSTRAINT fk_product_ingredient_nutrition FOREIGN KEY (nutrition_item_id) REFERENCES nutrition_item(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cart (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    created_at DATETIME(6),
    updated_at DATETIME(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_cart_user (user_id),
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cart_item (
    id BIGINT NOT NULL AUTO_INCREMENT,
    cart_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_cart_item_cart FOREIGN KEY (cart_id) REFERENCES cart(id),
    CONSTRAINT fk_cart_item_product FOREIGN KEY (product_id) REFERENCES product(id),
    CONSTRAINT uk_cart_item_product UNIQUE (cart_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE orders (
    id BIGINT NOT NULL AUTO_INCREMENT,
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
    created_at DATETIME(6),
    PRIMARY KEY (id),
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE order_detail (
    id BIGINT NOT NULL AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT,
    price DECIMAL(18,2),
    subtotal DECIMAL(18,2),
    PRIMARY KEY (id),
    CONSTRAINT fk_order_detail_order FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_order_detail_product FOREIGN KEY (product_id) REFERENCES product(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notification (
    id BIGINT NOT NULL AUTO_INCREMENT,
    type VARCHAR(80) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message VARCHAR(1000),
    target_url VARCHAR(500),
    order_id BIGINT NULL,
    read_at DATETIME(6),
    created_at DATETIME(6),
    PRIMARY KEY (id),
    CONSTRAINT fk_notification_order FOREIGN KEY (order_id) REFERENCES orders(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO users (full_name, email, password, phone, address, role, enabled, created_at)
VALUES
('Box Healthy Admin', 'admin@boxhealthy.vn', '$2a$10$Z6af9vPuWv7uJfwRnpRxYOwiuXuiW9a/v0lXCgEVrXpFgvhdXQzS6', NULL, NULL, 'ADMIN', 1, NOW(6));

INSERT INTO category (name, description, status)
VALUES
('Box Đạm Đóng Gói Sẵn', 'Sản phẩm chính, đủ đạm, tiện lợi và minh bạch nguồn nguyên liệu', 'ACTIVE'),
('Set Ăn Sáng Healthy', 'Bữa sáng nhanh gọn, phù hợp giao sớm trước 8 giờ', 'ACTIVE'),
('Bánh Eat Clean', 'Sản phẩm bán kèm, nhẹ bụng và dễ mang theo', 'ACTIVE');

INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat)
VALUES
('Ức gà luộc', 165, 31, 0, 3.6),
('Cơm trắng', 130, 2.7, 28, 0.3),
('Khoai lang luộc', 86, 1.6, 20.1, 0.1),
('Trứng gà luộc', 155, 13, 1.1, 11),
('Bông cải xanh', 34, 2.8, 6.6, 0.4),
('Thịt bò thăn', 207, 26, 0, 11),
('Ức gà nướng', 165, 31, 0, 3.6),
('Trứng luộc', 155, 13, 1.1, 10.6),
('Cơm gạo lứt', 111, 2.6, 23, 0.9),
('Sốt mè rang healthy', 140, 5, 16, 7.5),
('Yến mạch', 389, 16.9, 66.3, 6.9),
('Sữa chua không đường', 61, 3.5, 4.7, 3.3),
('Chuối', 89, 1.1, 23, 0.3),
('Hạt chia', 486, 16.5, 42.1, 30.7),
('Yến mạch cán dẹt', 389, 16.9, 66.3, 6.9),
('Chuối chín', 89, 1.1, 23, 0.3),
('Bơ đậu phộng', 588, 25, 20, 50),
('Hạnh nhân lát', 575, 21.2, 21.7, 49.4),
('Bột cacao', 228, 19.6, 57.9, 13.7);

INSERT INTO product (name, description, image_url, price, calories, protein, carbs, fat, stock_quantity, status, category_id)
VALUES
('Box Đạm Gà Gạo Lứt', 'Ức gà nướng, trứng luộc, rau củ và cơm gạo lứt đóng gói sẵn, tiện lợi cho bữa chính.', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80', 65000, 558, 60.9, 44.3, 14.3, 100, 'ACTIVE', 1),
('Set Ăn Sáng Healthy', 'Yến mạch, sữa chua, trứng và trái cây theo khẩu phần gọn nhẹ cho buổi sáng.', 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=900&q=80', 35000, 470, 21.7, 63.5, 15.6, 100, 'ACTIVE', 2),
('Bánh Eat Clean Yến Mạch', 'Bánh yến mạch ít ngọt, dùng như món bán kèm khi đặt box healthy.', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=80', 22000, 311, 12.0, 42.2, 13.1, 100, 'ACTIVE', 3);

INSERT INTO product_ingredient (product_id, nutrition_item_id, name, note, weight_gram, calories, protein, carbs, fat, display_order)
VALUES
(1, 7, 'Ức gà nướng', 'Protein chính, ít mỡ', 150, 248, 46.5, 0, 5.4, 1),
(1, 8, 'Trứng luộc', 'Bổ sung đạm và chất béo tốt', 55, 85, 7, 0.6, 5.8, 2),
(1, 9, 'Cơm gạo lứt', 'Tinh bột chậm', 150, 166, 3.9, 34.5, 1.3, 3),
(1, 5, 'Bông cải xanh', 'Rau xanh giàu chất xơ', 90, 31, 2.5, 6, 0.3, 4),
(1, 10, 'Sốt mè rang healthy', 'Tăng vị, dùng lượng nhỏ', 20, 28, 1, 3.2, 1.5, 5),
(2, 11, 'Yến mạch', 'Tinh bột tốt cho bữa sáng', 55, 214, 9.3, 36.4, 3.8, 1),
(2, 12, 'Sữa chua không đường', 'Hỗ trợ tiêu hóa', 100, 61, 3.5, 4.7, 3.3, 2),
(2, 8, 'Trứng luộc', 'Đạm nhanh, no lâu', 55, 85, 7, 0.6, 5.8, 3),
(2, 13, 'Chuối', 'Bổ sung năng lượng', 80, 71, 0.9, 18.4, 0.2, 4),
(2, 14, 'Hạt chia', 'Chất xơ và omega-3', 8, 39, 1.3, 3.4, 2.5, 5),
(3, 15, 'Yến mạch cán dẹt', 'Nền bánh giàu chất xơ', 35, 136, 5.9, 23.2, 2.4, 1),
(3, 16, 'Chuối chín', 'Tạo vị ngọt tự nhiên', 55, 49, 0.6, 12.6, 0.2, 2),
(3, 17, 'Bơ đậu phộng', 'Tăng vị béo, dùng lượng nhỏ', 12, 71, 3, 2.4, 6, 3),
(3, 18, 'Hạnh nhân lát', 'Chất béo tốt', 8, 46, 1.7, 1.7, 4, 4),
(3, 19, 'Bột cacao', 'Tạo vị chocolate nhẹ', 4, 9, 0.8, 2.3, 0.5, 5);
