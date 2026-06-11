USE BoxHealthy;
GO

IF OBJECT_ID(N'notification', N'U') IS NULL
BEGIN
    CREATE TABLE notification (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        type NVARCHAR(80) NOT NULL,
        title NVARCHAR(255) NOT NULL,
        message NVARCHAR(1000),
        target_url NVARCHAR(500),
        order_id BIGINT NULL,
        read_at DATETIME2,
        created_at DATETIME2,
        CONSTRAINT fk_notification_order FOREIGN KEY (order_id) REFERENCES orders(id)
    );
END
GO
