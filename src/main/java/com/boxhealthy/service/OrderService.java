package com.boxhealthy.service;

import com.boxhealthy.dto.CartItemDto;
import com.boxhealthy.dto.CheckoutRequest;
import com.boxhealthy.dto.RevenueChartPoint;
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
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.springframework.stereotype.Service;

@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final OrderDetailRepository orderDetailRepository;
    private final ProductRepository productRepository;
    private final NotificationService notificationService;

    public OrderService(OrderRepository orderRepository, OrderDetailRepository orderDetailRepository,
                        ProductRepository productRepository, NotificationService notificationService) {
        this.orderRepository = orderRepository;
        this.orderDetailRepository = orderDetailRepository;
        this.productRepository = productRepository;
        this.notificationService = notificationService;
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
        notificationService.notifyNewOrder(savedOrder);
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

    public List<RevenueChartPoint> revenueChart(String period) {
        String normalizedPeriod = period == null ? "month" : period.toLowerCase(Locale.ROOT);
        LocalDate today = LocalDate.now();
        Map<String, RevenueBucket> buckets = new LinkedHashMap<>();
        DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("dd/MM");

        if ("week".equals(normalizedPeriod)) {
            LocalDate start = today.minusDays(6);
            for (int i = 0; i < 7; i++) {
                LocalDate date = start.plusDays(i);
                buckets.put(date.toString(), new RevenueBucket(date.format(dayFormatter)));
            }
        } else if ("year".equals(normalizedPeriod)) {
            int year = today.getYear();
            for (int month = 1; month <= 12; month++) {
                YearMonth yearMonth = YearMonth.of(year, month);
                buckets.put(yearMonth.toString(), new RevenueBucket("T" + month));
            }
        } else {
            YearMonth month = YearMonth.from(today);
            for (int day = 1; day <= month.lengthOfMonth(); day++) {
                LocalDate date = month.atDay(day);
                buckets.put(date.toString(), new RevenueBucket(String.valueOf(day)));
            }
        }

        for (Order order : orderRepository.findAllByOrderByCreatedAtDesc()) {
            if (order.getCreatedAt() == null || order.getOrderStatus() != OrderStatus.COMPLETED) {
                continue;
            }
            LocalDate orderDate = order.getCreatedAt().toLocalDate();
            String key = "year".equals(normalizedPeriod)
                    ? YearMonth.from(orderDate).toString()
                    : orderDate.toString();
            RevenueBucket bucket = buckets.get(key);
            if (bucket != null) {
                bucket.add(order.getTotalAmount());
            }
        }

        BigDecimal maxRevenue = buckets.values().stream()
                .map(RevenueBucket::revenue)
                .max(BigDecimal::compareTo)
                .orElse(BigDecimal.ZERO);

        List<RevenueChartPoint> points = new ArrayList<>();
        int index = 0;
        int size = Math.max(buckets.size(), 1);
        for (RevenueBucket bucket : buckets.values()) {
            int percent = calculatePercent(bucket.revenue(), maxRevenue);
            int x = size == 1 ? 0 : (int) Math.round(index * 100.0 / (size - 1));
            int y = 100 - percent;
            points.add(new RevenueChartPoint(bucket.label(), bucket.revenue(), bucket.orderCount(), percent, x, y));
            index++;
        }
        return points;
    }

    public BigDecimal revenueForChart(List<RevenueChartPoint> points) {
        return points.stream()
                .map(RevenueChartPoint::getRevenue)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public long orderCountForChart(List<RevenueChartPoint> points) {
        return points.stream().mapToLong(RevenueChartPoint::getOrderCount).sum();
    }

    private int calculatePercent(BigDecimal value, BigDecimal maxRevenue) {
        if (maxRevenue == null || maxRevenue.compareTo(BigDecimal.ZERO) <= 0) {
            return 4;
        }
        int percent = value.multiply(BigDecimal.valueOf(100))
                .divide(maxRevenue, 0, RoundingMode.HALF_UP)
                .intValue();
        return Math.max(percent, value.compareTo(BigDecimal.ZERO) > 0 ? 8 : 4);
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

    private static class RevenueBucket {
        private final String label;
        private BigDecimal revenue = BigDecimal.ZERO;
        private long orderCount;

        RevenueBucket(String label) {
            this.label = label;
        }

        void add(BigDecimal amount) {
            revenue = revenue.add(amount == null ? BigDecimal.ZERO : amount);
            orderCount++;
        }

        String label() {
            return label;
        }

        BigDecimal revenue() {
            return revenue;
        }

        long orderCount() {
            return orderCount;
        }
    }
}
