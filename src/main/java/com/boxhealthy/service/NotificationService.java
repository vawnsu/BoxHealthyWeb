package com.boxhealthy.service;

import com.boxhealthy.entity.Notification;
import com.boxhealthy.entity.Order;
import com.boxhealthy.exception.ResourceNotFoundException;
import com.boxhealthy.repository.NotificationRepository;
import jakarta.transaction.Transactional;
import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {
    private static final Locale VIETNAM = Locale.forLanguageTag("vi-VN");

    private final NotificationRepository notificationRepository;

    public NotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    public void notifyNewOrder(Order order) {
        String paymentMethod = order.getPaymentMethod() == null ? "" : order.getPaymentMethod();
        boolean bankTransfer = "BANK_TRANSFER".equals(paymentMethod);

        Notification notification = new Notification();
        notification.setType(bankTransfer ? "PAYMENT_CONFIRMED" : "ORDER_CREATED");
        notification.setTitle(bankTransfer ? "Khách đã xác nhận chuyển khoản" : "Đơn hàng mới");
        notification.setMessage(buildOrderMessage(order, bankTransfer));
        notification.setTargetUrl("/admin/orders/" + order.getId());
        notification.setOrder(order);
        notificationRepository.save(notification);
    }

    public List<Notification> findLatest() {
        return notificationRepository.findTop30ByOrderByCreatedAtDesc();
    }

    public long countUnread() {
        return notificationRepository.countByReadAtIsNull();
    }

    @Transactional
    public void markRead(Long id) {
        Notification notification = notificationRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy thông báo"));
        if (notification.getReadAt() == null) {
            notification.setReadAt(LocalDateTime.now());
            notificationRepository.save(notification);
        }
    }

    @Transactional
    public void markAllRead() {
        LocalDateTime now = LocalDateTime.now();
        for (Notification notification : notificationRepository.findTop30ByOrderByCreatedAtDesc()) {
            if (notification.getReadAt() == null) {
                notification.setReadAt(now);
            }
        }
    }

    private String buildOrderMessage(Order order, boolean bankTransfer) {
        String amount = NumberFormat.getNumberInstance(VIETNAM).format(order.getTotalAmount()) + "đ";
        String action = bankTransfer ? "đã xác nhận chuyển khoản" : "vừa đặt đơn";
        return order.getCustomerName() + " (" + order.getPhone() + ") " + action + " #" + order.getId()
                + " trị giá " + amount + ".";
    }
}
