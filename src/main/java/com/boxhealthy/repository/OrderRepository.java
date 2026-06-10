package com.boxhealthy.repository;

import com.boxhealthy.entity.Order;
import com.boxhealthy.entity.OrderStatus;
import com.boxhealthy.entity.User;
import java.math.BigDecimal;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByUserOrderByCreatedAtDesc(User user);
    List<Order> findAllByOrderByCreatedAtDesc();
    List<Order> findTop5ByOrderByCreatedAtDesc();
    long countByOrderStatus(OrderStatus orderStatus);

    @Query(value = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE order_status = :orderStatus", nativeQuery = true)
    BigDecimal sumTotalAmountByOrderStatus(@Param("orderStatus") String orderStatus);
}
