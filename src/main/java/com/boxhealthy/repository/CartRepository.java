package com.boxhealthy.repository;

import com.boxhealthy.entity.Cart;
import com.boxhealthy.entity.User;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CartRepository extends JpaRepository<Cart, Long> {
    Optional<Cart> findByUser(User user);
}
