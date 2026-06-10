USE BoxHealthy;
GO

BEGIN TRANSACTION;

IF EXISTS (SELECT 1 FROM category WHERE id = 1)
    UPDATE category
    SET name = N'Box Đạm Đóng Gói Sẵn',
        description = N'Sản phẩm chính, đủ đạm, tiện lợi và minh bạch nguồn nguyên liệu',
        status = N'ACTIVE'
    WHERE id = 1;
ELSE
    INSERT INTO category (name, description, status)
    VALUES (N'Box Đạm Đóng Gói Sẵn', N'Sản phẩm chính, đủ đạm, tiện lợi và minh bạch nguồn nguyên liệu', N'ACTIVE');

IF EXISTS (SELECT 1 FROM category WHERE id = 2)
    UPDATE category
    SET name = N'Set Ăn Sáng Healthy',
        description = N'Bữa sáng nhanh gọn, phù hợp giao sớm trước 8 giờ',
        status = N'ACTIVE'
    WHERE id = 2;
ELSE
    INSERT INTO category (name, description, status)
    VALUES (N'Set Ăn Sáng Healthy', N'Bữa sáng nhanh gọn, phù hợp giao sớm trước 8 giờ', N'ACTIVE');

IF EXISTS (SELECT 1 FROM category WHERE id = 3)
    UPDATE category
    SET name = N'Bánh Eat Clean',
        description = N'Sản phẩm bán kèm, nhẹ bụng và dễ mang theo',
        status = N'ACTIVE'
    WHERE id = 3;
ELSE
    INSERT INTO category (name, description, status)
    VALUES (N'Bánh Eat Clean', N'Sản phẩm bán kèm, nhẹ bụng và dễ mang theo', N'ACTIVE');

UPDATE category
SET status = N'INACTIVE'
WHERE id NOT IN (1, 2, 3)
   OR name LIKE N'%Salad%'
   OR name LIKE N'%Combo%';

IF EXISTS (SELECT 1 FROM product WHERE id = 1)
    UPDATE product
    SET name = N'Box Đạm Gà Gạo Lứt',
        description = N'Ức gà nướng, trứng luộc, rau củ và cơm gạo lứt đóng gói sẵn, tiện lợi cho bữa chính.',
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
    VALUES (N'Box Đạm Gà Gạo Lứt', N'Ức gà nướng, trứng luộc, rau củ và cơm gạo lứt đóng gói sẵn, tiện lợi cho bữa chính.', N'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80', 65000, 520, 38, 52, 13, 100, N'ACTIVE', 1);

IF EXISTS (SELECT 1 FROM product WHERE id = 2)
    UPDATE product
    SET name = N'Set Ăn Sáng Healthy',
        description = N'Yến mạch, sữa chua, trứng và trái cây theo khẩu phần gọn nhẹ cho buổi sáng.',
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
    VALUES (N'Set Ăn Sáng Healthy', N'Yến mạch, sữa chua, trứng và trái cây theo khẩu phần gọn nhẹ cho buổi sáng.', N'https://images.unsplash.com/photo-1494390248081-4e521a5940db?auto=format&fit=crop&w=900&q=80', 35000, 360, 18, 48, 9, 100, N'ACTIVE', 2);

IF EXISTS (SELECT 1 FROM product WHERE id = 3)
    UPDATE product
    SET name = N'Bánh Eat Clean Yến Mạch',
        description = N'Bánh yến mạch ít ngọt, dùng như món bán kèm khi đặt box healthy.',
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
    VALUES (N'Bánh Eat Clean Yến Mạch', N'Bánh yến mạch ít ngọt, dùng như món bán kèm khi đặt box healthy.', N'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?auto=format&fit=crop&w=900&q=80', 22000, 180, 6, 24, 7, 100, N'ACTIVE', 3);

UPDATE product
SET status = N'INACTIVE'
WHERE id NOT IN (1, 2, 3)
   OR name LIKE N'%Salad%'
   OR name LIKE N'%Rau Củ%'
   OR name LIKE N'%Combo%';

COMMIT TRANSACTION;
GO
