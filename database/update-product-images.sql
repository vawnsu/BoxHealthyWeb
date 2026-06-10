USE BoxHealthy;
GO

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
GO
