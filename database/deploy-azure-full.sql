-- Full Azure SQL deployment script for BoxHealthy
-- Run this while connected to the BoxHealthy database.


-- ===================================================================
-- Source: database\schema.sql
-- ===================================================================


IF OBJECT_ID(N'order_detail', N'U') IS NOT NULL DROP TABLE order_detail;
IF OBJECT_ID(N'cart_item', N'U') IS NOT NULL DROP TABLE cart_item;
IF OBJECT_ID(N'orders', N'U') IS NOT NULL DROP TABLE orders;
IF OBJECT_ID(N'cart', N'U') IS NOT NULL DROP TABLE cart;
IF OBJECT_ID(N'product_ingredient', N'U') IS NOT NULL DROP TABLE product_ingredient;
IF OBJECT_ID(N'product', N'U') IS NOT NULL DROP TABLE product;
IF OBJECT_ID(N'category', N'U') IS NOT NULL DROP TABLE category;
IF OBJECT_ID(N'nutrition_item', N'U') IS NOT NULL DROP TABLE nutrition_item;
IF OBJECT_ID(N'users', N'U') IS NOT NULL DROP TABLE users;

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

INSERT INTO users (full_name, email, password, phone, address, role, enabled, created_at)
VALUES
(N'Box Healthy Admin', N'admin@boxhealthy.vn', N'$2a$10$Z6af9vPuWv7uJfwRnpRxYOwiuXuiW9a/v0lXCgEVrXpFgvhdXQzS6', NULL, NULL, N'ADMIN', 1, SYSDATETIME());

INSERT INTO category (name, description, status)
VALUES
(N'Box Äáº¡m ÄÃ³ng GÃ³i Sáºµn', N'Sáº£n pháº©m chÃ­nh, Ä‘á»§ Ä‘áº¡m, tiá»‡n lá»£i vÃ  minh báº¡ch nguá»“n nguyÃªn liá»‡u', N'ACTIVE'),
(N'Set Ä‚n SÃ¡ng Healthy', N'Bá»¯a sÃ¡ng nhanh gá»n, phÃ¹ há»£p giao sá»›m trÆ°á»›c 8 giá»', N'ACTIVE'),
(N'BÃ¡nh Eat Clean', N'Sáº£n pháº©m bÃ¡n kÃ¨m, nháº¹ bá»¥ng vÃ  dá»… mang theo', N'ACTIVE');

INSERT INTO product (name, description, image_url, price, calories, protein, carbs, fat, stock_quantity, status, category_id)
VALUES
(N'Box Äáº¡m GÃ  Gáº¡o Lá»©t', N'á»¨c gÃ  nÆ°á»›ng, trá»©ng luá»™c, rau cá»§ vÃ  cÆ¡m gáº¡o lá»©t Ä‘Ã³ng gÃ³i sáºµn, tiá»‡n lá»£i cho bá»¯a chÃ­nh.', N'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80', 65000, 520, 38, 52, 13, 100, N'ACTIVE', 1),
(N'Set Ä‚n SÃ¡ng Healthy', N'Yáº¿n máº¡ch, sá»¯a chua, trá»©ng vÃ  trÃ¡i cÃ¢y theo kháº©u pháº§n gá»n nháº¹ cho buá»•i sÃ¡ng.', N'https://images.unsplash.com/photo-1494390248081-4e521a5940db?auto=format&fit=crop&w=900&q=80', 35000, 360, 18, 48, 9, 100, N'ACTIVE', 2),
(N'BÃ¡nh Eat Clean Yáº¿n Máº¡ch', N'BÃ¡nh yáº¿n máº¡ch Ã­t ngá»t, dÃ¹ng nhÆ° mÃ³n bÃ¡n kÃ¨m khi Ä‘áº·t box healthy.', N'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?auto=format&fit=crop&w=900&q=80', 22000, 180, 6, 24, 7, 100, N'ACTIVE', 3);

INSERT INTO product_ingredient (product_id, name, note, weight_gram, calories, protein, carbs, fat, display_order)
VALUES
(1, N'á»¨c gÃ  nÆ°á»›ng', N'Protein chÃ­nh, Ã­t má»¡', 150, 248, 46.5, 0, 5.4, 1),
(1, N'Trá»©ng luá»™c', N'Bá»• sung Ä‘áº¡m vÃ  cháº¥t bÃ©o tá»‘t', 55, 85, 7, 0.6, 5.8, 2),
(1, N'CÆ¡m gáº¡o lá»©t', N'Tinh bá»™t cháº­m', 150, 166, 3.9, 34.5, 1.3, 3),
(1, N'BÃ´ng cáº£i xanh', N'Rau xanh giÃ u cháº¥t xÆ¡', 90, 31, 2.5, 6, 0.3, 4),
(1, N'Sá»‘t mÃ¨ rang healthy', N'TÄƒng vá»‹, dÃ¹ng lÆ°á»£ng nhá»', 20, 28, 1, 3.2, 1.5, 5),
(2, N'Yáº¿n máº¡ch', N'Tinh bá»™t tá»‘t cho bá»¯a sÃ¡ng', 55, 214, 9.3, 36.4, 3.8, 1),
(2, N'Sá»¯a chua khÃ´ng Ä‘Æ°á»ng', N'Há»— trá»£ tiÃªu hÃ³a', 100, 61, 3.5, 4.7, 3.3, 2),
(2, N'Trá»©ng luá»™c', N'Äáº¡m nhanh, no lÃ¢u', 55, 85, 7, 0.6, 5.8, 3),
(2, N'Chuá»‘i', N'Bá»• sung nÄƒng lÆ°á»£ng', 80, 71, 0.9, 18.4, 0.2, 4),
(2, N'Háº¡t chia', N'Cháº¥t xÆ¡ vÃ  omega-3', 8, 39, 1.3, 3.4, 2.5, 5),
(3, N'Yáº¿n máº¡ch cÃ¡n dáº¹t', N'Ná»n bÃ¡nh giÃ u cháº¥t xÆ¡', 35, 136, 5.9, 23.2, 2.4, 1),
(3, N'Chuá»‘i chÃ­n', N'Táº¡o vá»‹ ngá»t tá»± nhiÃªn', 55, 49, 0.6, 12.6, 0.2, 2),
(3, N'BÆ¡ Ä‘áº­u phá»™ng', N'TÄƒng vá»‹ bÃ©o, dÃ¹ng lÆ°á»£ng nhá»', 12, 71, 3, 2.4, 6, 3),
(3, N'Háº¡nh nhÃ¢n lÃ¡t', N'Cháº¥t bÃ©o tá»‘t', 8, 46, 1.7, 1.7, 4, 4),
(3, N'Bá»™t cacao', N'Táº¡o vá»‹ chocolate nháº¹', 4, 9, 0.8, 2.3, 0.5, 5);

INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat)
VALUES
(N'á»¨c gÃ  luá»™c', 165, 31, 0, 3.6),
(N'CÆ¡m tráº¯ng', 130, 2.7, 28, 0.3),
(N'Khoai lang luá»™c', 86, 1.6, 20.1, 0.1),
(N'Trá»©ng gÃ  luá»™c', 155, 13, 1.1, 11),
(N'BÃ´ng cáº£i xanh', 34, 2.8, 6.6, 0.4),
(N'Thá»‹t bÃ² thÄƒn', 207, 26, 0, 11),
(N'á»¨c gÃ  nÆ°á»›ng', 165, 31, 0, 3.6),
(N'Trá»©ng luá»™c', 155, 13, 1.1, 10.6),
(N'CÆ¡m gáº¡o lá»©t', 111, 2.6, 23, 0.9),
(N'Sá»‘t mÃ¨ rang healthy', 140, 5, 16, 7.5),
(N'Yáº¿n máº¡ch', 389, 16.9, 66.3, 6.9),
(N'Sá»¯a chua khÃ´ng Ä‘Æ°á»ng', 61, 3.5, 4.7, 3.3),
(N'Chuá»‘i', 89, 1.1, 23, 0.3),
(N'Háº¡t chia', 486, 16.5, 42.1, 30.7),
(N'Yáº¿n máº¡ch cÃ¡n dáº¹t', 389, 16.9, 66.3, 6.9),
(N'Chuá»‘i chÃ­n', 89, 1.1, 23, 0.3),
(N'BÆ¡ Ä‘áº­u phá»™ng', 588, 25, 20, 50),
(N'Háº¡nh nhÃ¢n lÃ¡t', 575, 21.2, 21.7, 49.4),
(N'Bá»™t cacao', 228, 19.6, 57.9, 13.7);

-- ===================================================================
-- Source: database\update-planned-products.sql
-- ===================================================================

BEGIN TRANSACTION;

IF EXISTS (SELECT 1 FROM category WHERE id = 1)
    UPDATE category
    SET name = N'Box Äáº¡m ÄÃ³ng GÃ³i Sáºµn',
        description = N'Sáº£n pháº©m chÃ­nh, Ä‘á»§ Ä‘áº¡m, tiá»‡n lá»£i vÃ  minh báº¡ch nguá»“n nguyÃªn liá»‡u',
        status = N'ACTIVE'
    WHERE id = 1;
ELSE
    INSERT INTO category (name, description, status)
    VALUES (N'Box Äáº¡m ÄÃ³ng GÃ³i Sáºµn', N'Sáº£n pháº©m chÃ­nh, Ä‘á»§ Ä‘áº¡m, tiá»‡n lá»£i vÃ  minh báº¡ch nguá»“n nguyÃªn liá»‡u', N'ACTIVE');

IF EXISTS (SELECT 1 FROM category WHERE id = 2)
    UPDATE category
    SET name = N'Set Ä‚n SÃ¡ng Healthy',
        description = N'Bá»¯a sÃ¡ng nhanh gá»n, phÃ¹ há»£p giao sá»›m trÆ°á»›c 8 giá»',
        status = N'ACTIVE'
    WHERE id = 2;
ELSE
    INSERT INTO category (name, description, status)
    VALUES (N'Set Ä‚n SÃ¡ng Healthy', N'Bá»¯a sÃ¡ng nhanh gá»n, phÃ¹ há»£p giao sá»›m trÆ°á»›c 8 giá»', N'ACTIVE');

IF EXISTS (SELECT 1 FROM category WHERE id = 3)
    UPDATE category
    SET name = N'BÃ¡nh Eat Clean',
        description = N'Sáº£n pháº©m bÃ¡n kÃ¨m, nháº¹ bá»¥ng vÃ  dá»… mang theo',
        status = N'ACTIVE'
    WHERE id = 3;
ELSE
    INSERT INTO category (name, description, status)
    VALUES (N'BÃ¡nh Eat Clean', N'Sáº£n pháº©m bÃ¡n kÃ¨m, nháº¹ bá»¥ng vÃ  dá»… mang theo', N'ACTIVE');

UPDATE category
SET status = N'INACTIVE'
WHERE id NOT IN (1, 2, 3)
   OR name LIKE N'%Salad%'
   OR name LIKE N'%Combo%';

IF EXISTS (SELECT 1 FROM product WHERE id = 1)
    UPDATE product
    SET name = N'Box Äáº¡m GÃ  Gáº¡o Lá»©t',
        description = N'á»¨c gÃ  nÆ°á»›ng, trá»©ng luá»™c, rau cá»§ vÃ  cÆ¡m gáº¡o lá»©t Ä‘Ã³ng gÃ³i sáºµn, tiá»‡n lá»£i cho bá»¯a chÃ­nh.',
        image_url = N'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80',
        price = 65000,
        calories = 520,
        protein = 38,
        carbs = 52,
        fat = 13,
        stock_quantity = 100,
        status = N'ACTIVE',
        category_id = 1
    WHERE id = 1;
ELSE
    INSERT INTO product (name, description, image_url, price, calories, protein, carbs, fat, stock_quantity, status, category_id)
    VALUES (N'Box Äáº¡m GÃ  Gáº¡o Lá»©t', N'á»¨c gÃ  nÆ°á»›ng, trá»©ng luá»™c, rau cá»§ vÃ  cÆ¡m gáº¡o lá»©t Ä‘Ã³ng gÃ³i sáºµn, tiá»‡n lá»£i cho bá»¯a chÃ­nh.', N'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80', 65000, 520, 38, 52, 13, 100, N'ACTIVE', 1);

IF EXISTS (SELECT 1 FROM product WHERE id = 2)
    UPDATE product
    SET name = N'Set Ä‚n SÃ¡ng Healthy',
        description = N'Yáº¿n máº¡ch, sá»¯a chua, trá»©ng vÃ  trÃ¡i cÃ¢y theo kháº©u pháº§n gá»n nháº¹ cho buá»•i sÃ¡ng.',
        image_url = N'https://images.unsplash.com/photo-1494390248081-4e521a5940db?auto=format&fit=crop&w=900&q=80',
        price = 35000,
        calories = 360,
        protein = 18,
        carbs = 48,
        fat = 9,
        stock_quantity = 100,
        status = N'ACTIVE',
        category_id = 2
    WHERE id = 2;
ELSE
    INSERT INTO product (name, description, image_url, price, calories, protein, carbs, fat, stock_quantity, status, category_id)
    VALUES (N'Set Ä‚n SÃ¡ng Healthy', N'Yáº¿n máº¡ch, sá»¯a chua, trá»©ng vÃ  trÃ¡i cÃ¢y theo kháº©u pháº§n gá»n nháº¹ cho buá»•i sÃ¡ng.', N'https://images.unsplash.com/photo-1494390248081-4e521a5940db?auto=format&fit=crop&w=900&q=80', 35000, 360, 18, 48, 9, 100, N'ACTIVE', 2);

IF EXISTS (SELECT 1 FROM product WHERE id = 3)
    UPDATE product
    SET name = N'BÃ¡nh Eat Clean Yáº¿n Máº¡ch',
        description = N'BÃ¡nh yáº¿n máº¡ch Ã­t ngá»t, dÃ¹ng nhÆ° mÃ³n bÃ¡n kÃ¨m khi Ä‘áº·t box healthy.',
        image_url = N'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?auto=format&fit=crop&w=900&q=80',
        price = 22000,
        calories = 180,
        protein = 6,
        carbs = 24,
        fat = 7,
        stock_quantity = 100,
        status = N'ACTIVE',
        category_id = 3
    WHERE id = 3;
ELSE
    INSERT INTO product (name, description, image_url, price, calories, protein, carbs, fat, stock_quantity, status, category_id)
    VALUES (N'BÃ¡nh Eat Clean Yáº¿n Máº¡ch', N'BÃ¡nh yáº¿n máº¡ch Ã­t ngá»t, dÃ¹ng nhÆ° mÃ³n bÃ¡n kÃ¨m khi Ä‘áº·t box healthy.', N'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?auto=format&fit=crop&w=900&q=80', 22000, 180, 6, 24, 7, 100, N'ACTIVE', 3);

UPDATE product
SET status = N'INACTIVE'
WHERE id NOT IN (1, 2, 3)
   OR name LIKE N'%Salad%'
   OR name LIKE N'%Rau Cá»§%'
   OR name LIKE N'%Combo%';

COMMIT TRANSACTION;

-- ===================================================================
-- Source: database\update-product-ingredients.sql
-- ===================================================================

IF OBJECT_ID(N'product_ingredient', N'U') IS NULL
BEGIN
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
END

IF COL_LENGTH('product_ingredient', 'nutrition_item_id') IS NULL
BEGIN
    ALTER TABLE product_ingredient ADD nutrition_item_id BIGINT NULL;
END

BEGIN TRANSACTION;

IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'á»¨c gÃ  nÆ°á»›ng')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'á»¨c gÃ  nÆ°á»›ng', 165, 31, 0, 3.6);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Trá»©ng luá»™c')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Trá»©ng luá»™c', 155, 13, 1.1, 10.6);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'CÆ¡m gáº¡o lá»©t')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'CÆ¡m gáº¡o lá»©t', 111, 2.6, 23, 0.9);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Sá»‘t mÃ¨ rang healthy')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Sá»‘t mÃ¨ rang healthy', 140, 5, 16, 7.5);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Yáº¿n máº¡ch')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Yáº¿n máº¡ch', 389, 16.9, 66.3, 6.9);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Sá»¯a chua khÃ´ng Ä‘Æ°á»ng')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Sá»¯a chua khÃ´ng Ä‘Æ°á»ng', 61, 3.5, 4.7, 3.3);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Chuá»‘i')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Chuá»‘i', 89, 1.1, 23, 0.3);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Háº¡t chia')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Háº¡t chia', 486, 16.5, 42.1, 30.7);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Yáº¿n máº¡ch cÃ¡n dáº¹t')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Yáº¿n máº¡ch cÃ¡n dáº¹t', 389, 16.9, 66.3, 6.9);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Chuá»‘i chÃ­n')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Chuá»‘i chÃ­n', 89, 1.1, 23, 0.3);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'BÆ¡ Ä‘áº­u phá»™ng')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'BÆ¡ Ä‘áº­u phá»™ng', 588, 25, 20, 50);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Háº¡nh nhÃ¢n lÃ¡t')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Háº¡nh nhÃ¢n lÃ¡t', 575, 21.2, 21.7, 49.4);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Bá»™t cacao')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Bá»™t cacao', 228, 19.6, 57.9, 13.7);

DELETE FROM product_ingredient
WHERE product_id IN (1, 2, 3);

INSERT INTO product_ingredient (product_id, nutrition_item_id, name, note, weight_gram, calories, protein, carbs, fat, display_order)
SELECT 1, id, food_name, N'Protein chÃ­nh, Ã­t má»¡', 150, ROUND(calories * 1.5, 0), ROUND(protein * 1.5, 1), ROUND(carbs * 1.5, 1), ROUND(fat * 1.5, 1), 1 FROM nutrition_item WHERE food_name = N'á»¨c gÃ  nÆ°á»›ng'
UNION ALL SELECT 1, id, food_name, N'Bá»• sung Ä‘áº¡m vÃ  cháº¥t bÃ©o tá»‘t', 55, ROUND(calories * 0.55, 0), ROUND(protein * 0.55, 1), ROUND(carbs * 0.55, 1), ROUND(fat * 0.55, 1), 2 FROM nutrition_item WHERE food_name = N'Trá»©ng luá»™c'
UNION ALL SELECT 1, id, food_name, N'Tinh bá»™t cháº­m', 150, ROUND(calories * 1.5, 0), ROUND(protein * 1.5, 1), ROUND(carbs * 1.5, 1), ROUND(fat * 1.5, 1), 3 FROM nutrition_item WHERE food_name = N'CÆ¡m gáº¡o lá»©t'
UNION ALL SELECT 1, id, food_name, N'Rau xanh giÃ u cháº¥t xÆ¡', 90, ROUND(calories * 0.9, 0), ROUND(protein * 0.9, 1), ROUND(carbs * 0.9, 1), ROUND(fat * 0.9, 1), 4 FROM nutrition_item WHERE food_name = N'BÃ´ng cáº£i xanh'
UNION ALL SELECT 1, id, food_name, N'TÄƒng vá»‹, dÃ¹ng lÆ°á»£ng nhá»', 20, ROUND(calories * 0.2, 0), ROUND(protein * 0.2, 1), ROUND(carbs * 0.2, 1), ROUND(fat * 0.2, 1), 5 FROM nutrition_item WHERE food_name = N'Sá»‘t mÃ¨ rang healthy'
UNION ALL SELECT 2, id, food_name, N'Tinh bá»™t tá»‘t cho bá»¯a sÃ¡ng', 55, ROUND(calories * 0.55, 0), ROUND(protein * 0.55, 1), ROUND(carbs * 0.55, 1), ROUND(fat * 0.55, 1), 1 FROM nutrition_item WHERE food_name = N'Yáº¿n máº¡ch'
UNION ALL SELECT 2, id, food_name, N'Há»— trá»£ tiÃªu hÃ³a', 100, calories, protein, carbs, fat, 2 FROM nutrition_item WHERE food_name = N'Sá»¯a chua khÃ´ng Ä‘Æ°á»ng'
UNION ALL SELECT 2, id, food_name, N'Äáº¡m nhanh, no lÃ¢u', 55, ROUND(calories * 0.55, 0), ROUND(protein * 0.55, 1), ROUND(carbs * 0.55, 1), ROUND(fat * 0.55, 1), 3 FROM nutrition_item WHERE food_name = N'Trá»©ng luá»™c'
UNION ALL SELECT 2, id, food_name, N'Bá»• sung nÄƒng lÆ°á»£ng', 80, ROUND(calories * 0.8, 0), ROUND(protein * 0.8, 1), ROUND(carbs * 0.8, 1), ROUND(fat * 0.8, 1), 4 FROM nutrition_item WHERE food_name = N'Chuá»‘i'
UNION ALL SELECT 2, id, food_name, N'Cháº¥t xÆ¡ vÃ  omega-3', 8, ROUND(calories * 0.08, 0), ROUND(protein * 0.08, 1), ROUND(carbs * 0.08, 1), ROUND(fat * 0.08, 1), 5 FROM nutrition_item WHERE food_name = N'Háº¡t chia'
UNION ALL SELECT 3, id, food_name, N'Ná»n bÃ¡nh giÃ u cháº¥t xÆ¡', 35, ROUND(calories * 0.35, 0), ROUND(protein * 0.35, 1), ROUND(carbs * 0.35, 1), ROUND(fat * 0.35, 1), 1 FROM nutrition_item WHERE food_name = N'Yáº¿n máº¡ch cÃ¡n dáº¹t'
UNION ALL SELECT 3, id, food_name, N'Táº¡o vá»‹ ngá»t tá»± nhiÃªn', 55, ROUND(calories * 0.55, 0), ROUND(protein * 0.55, 1), ROUND(carbs * 0.55, 1), ROUND(fat * 0.55, 1), 2 FROM nutrition_item WHERE food_name = N'Chuá»‘i chÃ­n'
UNION ALL SELECT 3, id, food_name, N'TÄƒng vá»‹ bÃ©o, dÃ¹ng lÆ°á»£ng nhá»', 12, ROUND(calories * 0.12, 0), ROUND(protein * 0.12, 1), ROUND(carbs * 0.12, 1), ROUND(fat * 0.12, 1), 3 FROM nutrition_item WHERE food_name = N'BÆ¡ Ä‘áº­u phá»™ng'
UNION ALL SELECT 3, id, food_name, N'Cháº¥t bÃ©o tá»‘t', 8, ROUND(calories * 0.08, 0), ROUND(protein * 0.08, 1), ROUND(carbs * 0.08, 1), ROUND(fat * 0.08, 1), 4 FROM nutrition_item WHERE food_name = N'Háº¡nh nhÃ¢n lÃ¡t'
UNION ALL SELECT 3, id, food_name, N'Táº¡o vá»‹ chocolate nháº¹', 4, ROUND(calories * 0.04, 0), ROUND(protein * 0.04, 1), ROUND(carbs * 0.04, 1), ROUND(fat * 0.04, 1), 5 FROM nutrition_item WHERE food_name = N'Bá»™t cacao';

UPDATE product
SET calories = ingredient_totals.calories,
    protein = ingredient_totals.protein,
    carbs = ingredient_totals.carbs,
    fat = ingredient_totals.fat
FROM product
JOIN (
    SELECT product_id,
           SUM(calories) AS calories,
           ROUND(SUM(protein), 1) AS protein,
           ROUND(SUM(carbs), 1) AS carbs,
           ROUND(SUM(fat), 1) AS fat
    FROM product_ingredient
    WHERE product_id IN (1, 2, 3)
    GROUP BY product_id
) ingredient_totals ON product.id = ingredient_totals.product_id;

COMMIT TRANSACTION;

-- ===================================================================
-- Source: database\update-product-images.sql
-- ===================================================================

UPDATE product
SET image_url = N'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80'
WHERE id = 1;

UPDATE product
SET image_url = N'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=900&q=80'
WHERE id = 2;

UPDATE product
SET image_url = N'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=80'
WHERE id = 3;

UPDATE product
SET image_url = N'https://images.unsplash.com/photo-1505576399279-565b52d4ac71?auto=format&fit=crop&w=900&q=80'
WHERE id = 4;
