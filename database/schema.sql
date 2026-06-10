IF DB_ID(N'BoxHealthy') IS NULL
BEGIN
    CREATE DATABASE BoxHealthy;
END
GO

USE BoxHealthy;
GO

IF OBJECT_ID(N'order_detail', N'U') IS NOT NULL DROP TABLE order_detail;
IF OBJECT_ID(N'cart_item', N'U') IS NOT NULL DROP TABLE cart_item;
IF OBJECT_ID(N'orders', N'U') IS NOT NULL DROP TABLE orders;
IF OBJECT_ID(N'cart', N'U') IS NOT NULL DROP TABLE cart;
IF OBJECT_ID(N'product_ingredient', N'U') IS NOT NULL DROP TABLE product_ingredient;
IF OBJECT_ID(N'product', N'U') IS NOT NULL DROP TABLE product;
IF OBJECT_ID(N'category', N'U') IS NOT NULL DROP TABLE category;
IF OBJECT_ID(N'nutrition_item', N'U') IS NOT NULL DROP TABLE nutrition_item;
IF OBJECT_ID(N'users', N'U') IS NOT NULL DROP TABLE users;
GO

CREATE TABLE users (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(255),
    email NVARCHAR(255) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    phone NVARCHAR(50),
    address NVARCHAR(500),
    role NVARCHAR(30) NOT NULL,
    enabled BIT NOT NULL DEFAULT 1,
    created_at DATETIME2
);

CREATE TABLE category (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),
    description NVARCHAR(1000),
    status NVARCHAR(30)
);

CREATE TABLE product (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),
    description NVARCHAR(2000),
    image_url NVARCHAR(500),
    price DECIMAL(18,2),
    calories INT,
    protein FLOAT,
    carbs FLOAT,
    fat FLOAT,
    stock_quantity INT,
    status NVARCHAR(30),
    category_id BIGINT NULL,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES category(id)
);

CREATE TABLE product_ingredient (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    product_id BIGINT NOT NULL,
    nutrition_item_id BIGINT NULL,
    name NVARCHAR(255) NOT NULL,
    note NVARCHAR(500),
    weight_gram INT,
    calories INT,
    protein FLOAT,
    carbs FLOAT,
    fat FLOAT,
    display_order INT,
    CONSTRAINT fk_product_ingredient_product FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE cart (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    created_at DATETIME2,
    updated_at DATETIME2,
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE cart_item (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    cart_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT fk_cart_item_cart FOREIGN KEY (cart_id) REFERENCES cart(id),
    CONSTRAINT fk_cart_item_product FOREIGN KEY (product_id) REFERENCES product(id),
    CONSTRAINT uk_cart_item_product UNIQUE (cart_id, product_id)
);

CREATE TABLE orders (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NULL,
    customer_name NVARCHAR(255),
    phone NVARCHAR(50),
    email NVARCHAR(255),
    address NVARCHAR(500),
    note NVARCHAR(1000),
    payment_method NVARCHAR(50),
    delivery_time NVARCHAR(255),
    total_amount DECIMAL(18,2),
    order_status NVARCHAR(30),
    created_at DATETIME2,
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_detail (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT,
    price DECIMAL(18,2),
    subtotal DECIMAL(18,2),
    CONSTRAINT fk_order_detail_order FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_order_detail_product FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE nutrition_item (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    food_name NVARCHAR(255),
    calories INT,
    protein FLOAT,
    carbs FLOAT,
    fat FLOAT
);
GO

INSERT INTO users (full_name, email, password, phone, address, role, enabled, created_at)
VALUES
(N'Box Healthy Admin', N'admin@boxhealthy.vn', N'$2a$10$Z6af9vPuWv7uJfwRnpRxYOwiuXuiW9a/v0lXCgEVrXpFgvhdXQzS6', NULL, NULL, N'ADMIN', 1, SYSDATETIME());

INSERT INTO category (name, description, status)
VALUES
(N'Box Đạm Đóng Gói Sẵn', N'Sản phẩm chính, đủ đạm, tiện lợi và minh bạch nguồn nguyên liệu', N'ACTIVE'),
(N'Set Ăn Sáng Healthy', N'Bữa sáng nhanh gọn, phù hợp giao sớm trước 8 giờ', N'ACTIVE'),
(N'Bánh Eat Clean', N'Sản phẩm bán kèm, nhẹ bụng và dễ mang theo', N'ACTIVE');

INSERT INTO product (name, description, image_url, price, calories, protein, carbs, fat, stock_quantity, status, category_id)
VALUES
(N'Box Đạm Gà Gạo Lứt', N'Ức gà nướng, trứng luộc, rau củ và cơm gạo lứt đóng gói sẵn, tiện lợi cho bữa chính.', N'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80', 65000, 520, 38, 52, 13, 100, N'ACTIVE', 1),
(N'Set Ăn Sáng Healthy', N'Yến mạch, sữa chua, trứng và trái cây theo khẩu phần gọn nhẹ cho buổi sáng.', N'https://images.unsplash.com/photo-1494390248081-4e521a5940db?auto=format&fit=crop&w=900&q=80', 35000, 360, 18, 48, 9, 100, N'ACTIVE', 2),
(N'Bánh Eat Clean Yến Mạch', N'Bánh yến mạch ít ngọt, dùng như món bán kèm khi đặt box healthy.', N'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?auto=format&fit=crop&w=900&q=80', 22000, 180, 6, 24, 7, 100, N'ACTIVE', 3);

INSERT INTO product_ingredient (product_id, name, note, weight_gram, calories, protein, carbs, fat, display_order)
VALUES
(1, N'Ức gà nướng', N'Protein chính, ít mỡ', 150, 248, 46.5, 0, 5.4, 1),
(1, N'Trứng luộc', N'Bổ sung đạm và chất béo tốt', 55, 85, 7, 0.6, 5.8, 2),
(1, N'Cơm gạo lứt', N'Tinh bột chậm', 150, 166, 3.9, 34.5, 1.3, 3),
(1, N'Bông cải xanh', N'Rau xanh giàu chất xơ', 90, 31, 2.5, 6, 0.3, 4),
(1, N'Sốt mè rang healthy', N'Tăng vị, dùng lượng nhỏ', 20, 28, 1, 3.2, 1.5, 5),
(2, N'Yến mạch', N'Tinh bột tốt cho bữa sáng', 55, 214, 9.3, 36.4, 3.8, 1),
(2, N'Sữa chua không đường', N'Hỗ trợ tiêu hóa', 100, 61, 3.5, 4.7, 3.3, 2),
(2, N'Trứng luộc', N'Đạm nhanh, no lâu', 55, 85, 7, 0.6, 5.8, 3),
(2, N'Chuối', N'Bổ sung năng lượng', 80, 71, 0.9, 18.4, 0.2, 4),
(2, N'Hạt chia', N'Chất xơ và omega-3', 8, 39, 1.3, 3.4, 2.5, 5),
(3, N'Yến mạch cán dẹt', N'Nền bánh giàu chất xơ', 35, 136, 5.9, 23.2, 2.4, 1),
(3, N'Chuối chín', N'Tạo vị ngọt tự nhiên', 55, 49, 0.6, 12.6, 0.2, 2),
(3, N'Bơ đậu phộng', N'Tăng vị béo, dùng lượng nhỏ', 12, 71, 3, 2.4, 6, 3),
(3, N'Hạnh nhân lát', N'Chất béo tốt', 8, 46, 1.7, 1.7, 4, 4),
(3, N'Bột cacao', N'Tạo vị chocolate nhẹ', 4, 9, 0.8, 2.3, 0.5, 5);

INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat)
VALUES
(N'Ức gà luộc', 165, 31, 0, 3.6),
(N'Cơm trắng', 130, 2.7, 28, 0.3),
(N'Khoai lang luộc', 86, 1.6, 20.1, 0.1),
(N'Trứng gà luộc', 155, 13, 1.1, 11),
(N'Bông cải xanh', 34, 2.8, 6.6, 0.4),
(N'Thịt bò thăn', 207, 26, 0, 11),
(N'Ức gà nướng', 165, 31, 0, 3.6),
(N'Trứng luộc', 155, 13, 1.1, 10.6),
(N'Cơm gạo lứt', 111, 2.6, 23, 0.9),
(N'Sốt mè rang healthy', 140, 5, 16, 7.5),
(N'Yến mạch', 389, 16.9, 66.3, 6.9),
(N'Sữa chua không đường', 61, 3.5, 4.7, 3.3),
(N'Chuối', 89, 1.1, 23, 0.3),
(N'Hạt chia', 486, 16.5, 42.1, 30.7),
(N'Yến mạch cán dẹt', 389, 16.9, 66.3, 6.9),
(N'Chuối chín', 89, 1.1, 23, 0.3),
(N'Bơ đậu phộng', 588, 25, 20, 50),
(N'Hạnh nhân lát', 575, 21.2, 21.7, 49.4),
(N'Bột cacao', 228, 19.6, 57.9, 13.7);
GO
