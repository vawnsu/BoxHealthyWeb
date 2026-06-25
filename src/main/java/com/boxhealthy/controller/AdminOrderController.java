package com.boxhealthy.controller;

import com.boxhealthy.entity.OrderStatus;
import com.boxhealthy.service.OrderService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AdminOrderController {
    private final OrderService orderService;

    public AdminOrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @GetMapping("/admin/orders")
    public String list(@RequestParam(required = false) String keyword, Model model) {
        model.addAttribute("orders", orderService.findByKeyword(keyword));
        model.addAttribute("keyword", keyword);
        return "admin-orders";
    }

    @GetMapping("/admin/orders/{id}")
    public String detail(@PathVariable Long id, Model model) {
        model.addAttribute("order", orderService.getById(id));
        model.addAttribute("details", orderService.findDetails(id));
        model.addAttribute("statuses", OrderStatus.values());
        return "admin-order-detail";
    }

    @PostMapping("/admin/orders/{id}/status")
    public String updateStatus(@PathVariable Long id, @RequestParam OrderStatus status) {
        orderService.updateStatus(id, status);
        return "redirect:/admin/orders/" + id;
    }
}
