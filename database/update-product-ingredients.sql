USE BoxHealthy;
GO

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
GO

IF COL_LENGTH('product_ingredient', 'nutrition_item_id') IS NULL
BEGIN
    ALTER TABLE product_ingredient ADD nutrition_item_id BIGINT NULL;
END
GO

BEGIN TRANSACTION;

IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Ức gà nướng')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Ức gà nướng', 165, 31, 0, 3.6);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Trứng luộc')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Trứng luộc', 155, 13, 1.1, 10.6);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Cơm gạo lứt')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Cơm gạo lứt', 111, 2.6, 23, 0.9);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Sốt mè rang healthy')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Sốt mè rang healthy', 140, 5, 16, 7.5);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Yến mạch')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Yến mạch', 389, 16.9, 66.3, 6.9);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Sữa chua không đường')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Sữa chua không đường', 61, 3.5, 4.7, 3.3);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Chuối')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Chuối', 89, 1.1, 23, 0.3);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Hạt chia')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Hạt chia', 486, 16.5, 42.1, 30.7);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Yến mạch cán dẹt')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Yến mạch cán dẹt', 389, 16.9, 66.3, 6.9);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Chuối chín')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Chuối chín', 89, 1.1, 23, 0.3);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Bơ đậu phộng')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Bơ đậu phộng', 588, 25, 20, 50);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Hạnh nhân lát')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Hạnh nhân lát', 575, 21.2, 21.7, 49.4);
IF NOT EXISTS (SELECT 1 FROM nutrition_item WHERE food_name = N'Bột cacao')
    INSERT INTO nutrition_item (food_name, calories, protein, carbs, fat) VALUES (N'Bột cacao', 228, 19.6, 57.9, 13.7);

DELETE FROM product_ingredient
WHERE product_id IN (1, 2, 3);

INSERT INTO product_ingredient (product_id, nutrition_item_id, name, note, weight_gram, calories, protein, carbs, fat, display_order)
SELECT 1, id, food_name, N'Protein chính, ít mỡ', 150, ROUND(calories * 1.5, 0), ROUND(protein * 1.5, 1), ROUND(carbs * 1.5, 1), ROUND(fat * 1.5, 1), 1 FROM nutrition_item WHERE food_name = N'Ức gà nướng'
UNION ALL SELECT 1, id, food_name, N'Bổ sung đạm và chất béo tốt', 55, ROUND(calories * 0.55, 0), ROUND(protein * 0.55, 1), ROUND(carbs * 0.55, 1), ROUND(fat * 0.55, 1), 2 FROM nutrition_item WHERE food_name = N'Trứng luộc'
UNION ALL SELECT 1, id, food_name, N'Tinh bột chậm', 150, ROUND(calories * 1.5, 0), ROUND(protein * 1.5, 1), ROUND(carbs * 1.5, 1), ROUND(fat * 1.5, 1), 3 FROM nutrition_item WHERE food_name = N'Cơm gạo lứt'
UNION ALL SELECT 1, id, food_name, N'Rau xanh giàu chất xơ', 90, ROUND(calories * 0.9, 0), ROUND(protein * 0.9, 1), ROUND(carbs * 0.9, 1), ROUND(fat * 0.9, 1), 4 FROM nutrition_item WHERE food_name = N'Bông cải xanh'
UNION ALL SELECT 1, id, food_name, N'Tăng vị, dùng lượng nhỏ', 20, ROUND(calories * 0.2, 0), ROUND(protein * 0.2, 1), ROUND(carbs * 0.2, 1), ROUND(fat * 0.2, 1), 5 FROM nutrition_item WHERE food_name = N'Sốt mè rang healthy'
UNION ALL SELECT 2, id, food_name, N'Tinh bột tốt cho bữa sáng', 55, ROUND(calories * 0.55, 0), ROUND(protein * 0.55, 1), ROUND(carbs * 0.55, 1), ROUND(fat * 0.55, 1), 1 FROM nutrition_item WHERE food_name = N'Yến mạch'
UNION ALL SELECT 2, id, food_name, N'Hỗ trợ tiêu hóa', 100, calories, protein, carbs, fat, 2 FROM nutrition_item WHERE food_name = N'Sữa chua không đường'
UNION ALL SELECT 2, id, food_name, N'Đạm nhanh, no lâu', 55, ROUND(calories * 0.55, 0), ROUND(protein * 0.55, 1), ROUND(carbs * 0.55, 1), ROUND(fat * 0.55, 1), 3 FROM nutrition_item WHERE food_name = N'Trứng luộc'
UNION ALL SELECT 2, id, food_name, N'Bổ sung năng lượng', 80, ROUND(calories * 0.8, 0), ROUND(protein * 0.8, 1), ROUND(carbs * 0.8, 1), ROUND(fat * 0.8, 1), 4 FROM nutrition_item WHERE food_name = N'Chuối'
UNION ALL SELECT 2, id, food_name, N'Chất xơ và omega-3', 8, ROUND(calories * 0.08, 0), ROUND(protein * 0.08, 1), ROUND(carbs * 0.08, 1), ROUND(fat * 0.08, 1), 5 FROM nutrition_item WHERE food_name = N'Hạt chia'
UNION ALL SELECT 3, id, food_name, N'Nền bánh giàu chất xơ', 35, ROUND(calories * 0.35, 0), ROUND(protein * 0.35, 1), ROUND(carbs * 0.35, 1), ROUND(fat * 0.35, 1), 1 FROM nutrition_item WHERE food_name = N'Yến mạch cán dẹt'
UNION ALL SELECT 3, id, food_name, N'Tạo vị ngọt tự nhiên', 55, ROUND(calories * 0.55, 0), ROUND(protein * 0.55, 1), ROUND(carbs * 0.55, 1), ROUND(fat * 0.55, 1), 2 FROM nutrition_item WHERE food_name = N'Chuối chín'
UNION ALL SELECT 3, id, food_name, N'Tăng vị béo, dùng lượng nhỏ', 12, ROUND(calories * 0.12, 0), ROUND(protein * 0.12, 1), ROUND(carbs * 0.12, 1), ROUND(fat * 0.12, 1), 3 FROM nutrition_item WHERE food_name = N'Bơ đậu phộng'
UNION ALL SELECT 3, id, food_name, N'Chất béo tốt', 8, ROUND(calories * 0.08, 0), ROUND(protein * 0.08, 1), ROUND(carbs * 0.08, 1), ROUND(fat * 0.08, 1), 4 FROM nutrition_item WHERE food_name = N'Hạnh nhân lát'
UNION ALL SELECT 3, id, food_name, N'Tạo vị chocolate nhẹ', 4, ROUND(calories * 0.04, 0), ROUND(protein * 0.04, 1), ROUND(carbs * 0.04, 1), ROUND(fat * 0.04, 1), 5 FROM nutrition_item WHERE food_name = N'Bột cacao';

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
GO
