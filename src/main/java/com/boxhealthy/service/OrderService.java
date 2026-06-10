package com.boxhealthy.service;

import com.boxhealthy.dto.CartItemDto;
import com.boxhealthy.dto.CheckoutRequest;
import com.boxhealthy.entity.Order;
import com.boxhealthy.entity.OrderDetail;
import com.boxhealthy.entity.OrderStatus;
import com.boxhealthy.entity.Product;
import com.boxhealthy.entity.User;
import com.boxhealthy.exception.ResourceNotFoundException;
import com.boxhealthy.repository.OrderDetailRepository;
import com.boxhealthy.repository.OrderRepository;
import com.boxhealthy.repository.ProductRepository;
import jakarta.transaction.Transactional;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final OrderDetailRepository orderDetailRepository;
    private final ProductRepository productRepository;

    public OrderService(OrderRepository orderRepository, OrderDetailRepository orderDetailRepository,
                        ProductRepository productRepository) {
        this.orderRepository = orderRepository;
        this.orderDetailRepository = orderDetailRepository;
        this.productRepository = productRepository;
    }

    @Transactional
    public Order createOrder(User user, CheckoutRequest request, Collection<CartItemDto> items) {
        if (items.isEmpty()) {
            throw new IllegalArgumentException("Giỏ hàng đang trống");
        }
        Order order = new Order();
        order.setUser(user);
        order.setCustomerName(request.getCustomerName());
        order.setPhone(request.getPhone());
        order.setEmail(request.getEmail());
        order.setAddress(request.getAddress());
        order.setNote(request.getNote());
        order.setPaymentMethod(request.getPaymentMethod());
        order.setDeliveryTime(request.getDeliveryTime());
        order.setOrderStatus(OrderStatus.PENDING);
        order.setTotalAmount(items.stream().map(CartItemDto::getSubtotal).reduce(BigDecimal.ZERO, BigDecimal::add));
        Order savedOrder = orderRepository.save(order);

        for (CartItemDto item : items) {
            Product product = productRepository.findById(item.getProduct().getId())
                    .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy sản phẩm"));
            int stock = product.getStockQuantity() == null ? 0 : product.getStockQuantity();
            if (stock < item.getQuantity()) {
                throw new IllegalArgumentException("Sản phẩm " + product.getName() + " không đủ tồn kho");
            }
            product.setStockQuantity(stock - item.getQuantity());
            productRepository.save(product);

            OrderDetail detail = new OrderDetail();
            detail.setOrder(savedOrder);
            detail.setProduct(product);
            detail.setQuantity(item.getQuantity());
            detail.setPrice(product.getPrice());
            detail.setSubtotal(product.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
            orderDetailRepository.save(detail);
        }
        return savedOrder;
    }

    public List<Order> findAll() {
        return orderRepository.findAllByOrderByCreatedAtDesc();
    }

    public List<Order> findRecent(int limit) {
        if (limit <= 5) {
            return orderRepository.findTop5ByOrderByCreatedAtDesc();
        }
        return orderRepository.findAllByOrderByCreatedAtDesc().stream().limit(limit).toList();
    }

    public long countAll() {
        return orderRepository.count();
    }

    public long countByStatus(OrderStatus status) {
        return orderRepository.countByOrderStatus(status);
    }

    public BigDecimal sumTotalByStatus(OrderStatus status) {
        return orderRepository.sumTotalAmountByOrderStatus(status.name());
    }

    public List<Order> findByUser(User user) {
        return orderRepository.findByUserOrderByCreatedAtDesc(user);
    }

    public Order getById(Long id) {
        return orderRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy đơn hàng"));
    }

    public List<OrderDetail> findDetails(Long orderId) {
        return orderDetailRepository.findByOrderId(orderId);
    }

    public void updateStatus(Long orderId, OrderStatus status) {
        Order order = getById(orderId);
        order.setOrderStatus(status);
        orderRepository.save(order);
    }
}
