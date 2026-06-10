# Box Healthy Database

Ứng dụng dùng SQL Server qua cấu hình:

```properties
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=BoxHealthy;encrypt=true;trustServerCertificate=true
spring.datasource.username=sa
spring.datasource.password=YourStrongPassword
```

## Tạo database và bảng

Mở SQL Server Management Studio hoặc Azure Data Studio, kết nối vào SQL Server local rồi chạy:

```sql
:r database/schema.sql
```

Hoặc copy nội dung file `schema.sql` và chạy trực tiếp.

Project đang tắt tự tạo bảng bằng Hibernate:

```properties
spring.jpa.hibernate.ddl-auto=none
```

Script `schema.sql` đã tạo bảng, dữ liệu mẫu và tài khoản admin.

Các bảng chính:

```text
users
category
product
cart
cart_item
orders
order_detail
nutrition_item
```

Tài khoản admin mẫu:

```text
admin@boxhealthy.vn / admin123
```

Nếu muốn bật seed bằng code để demo nhanh, đổi:

```properties
boxhealthy.seed.enabled=true
```
