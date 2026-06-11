package com.boxhealthy.controller;

import com.boxhealthy.service.NotificationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class AdminNotificationController {
    private final NotificationService notificationService;

    public AdminNotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @GetMapping("/admin/notifications")
    public String list(Model model) {
        model.addAttribute("notifications", notificationService.findLatest());
        return "admin-notifications";
    }

    @PostMapping("/admin/notifications/{id}/read")
    public String markRead(@PathVariable Long id) {
        notificationService.markRead(id);
        return "redirect:/admin/notifications";
    }

    @PostMapping("/admin/notifications/read-all")
    public String markAllRead() {
        notificationService.markAllRead();
        return "redirect:/admin/notifications";
    }
}
