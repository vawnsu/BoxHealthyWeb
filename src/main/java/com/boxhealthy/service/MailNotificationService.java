package com.boxhealthy.service;

import com.boxhealthy.entity.Notification;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class MailNotificationService {
    private static final Logger log = LoggerFactory.getLogger(MailNotificationService.class);

    private final JavaMailSender mailSender;
    private final boolean enabled;
    private final String adminEmail;
    private final String fromEmail;

    public MailNotificationService(
            ObjectProvider<JavaMailSender> mailSenderProvider,
            @Value("${app.notification.email.enabled:false}") boolean enabled,
            @Value("${app.notification.email.to:}") String adminEmail,
            @Value("${spring.mail.username:}") String fromEmail) {
        this.mailSender = mailSenderProvider.getIfAvailable();
        this.enabled = enabled;
        this.adminEmail = adminEmail;
        this.fromEmail = fromEmail;
    }

    public void send(Notification notification) {
        if (!enabled || mailSender == null || adminEmail == null || adminEmail.isBlank()) {
            return;
        }

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            if (fromEmail != null && !fromEmail.isBlank()) {
                message.setFrom(fromEmail);
            }
            message.setTo(adminEmail);
            message.setSubject("[Box Healthy] " + notification.getTitle());
            message.setText(notification.getMessage() + "\n\nXem chi tiết: https://boxhealthy.site"
                    + notification.getTargetUrl());
            mailSender.send(message);
        } catch (Exception ex) {
            log.warn("Failed to send admin notification email", ex);
        }
    }
}
