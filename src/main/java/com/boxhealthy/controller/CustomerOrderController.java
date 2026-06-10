package com.boxhealthy.controller;

import com.boxhealthy.entity.Order;
import com.boxhealthy.entity.User;
import com.boxhealthy.service.OrderService;
import com.boxhealthy.service.UserService;
import java.security.Principal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class CustomerOrderController {
    private final OrderService orderService;
    private final UserService userService;

    public CustomerOrderController(OrderService orderService, UserService userService) {
        this.orderService = orderService;
        this.userService = userService;
    }

    @GetMapping("/orders")
    public String history(Principal principal, Model model) {
        User user = userService.getByEmail(principal.getName());
        model.addAttribute("orders", orderService.findByUser(user));
        return "order-history";
    }

    @GetMapping("/orders/{id}")
    public String detail(@PathVariable Long id, Principal principal, Model model) {
        User user = userService.getByEmail(principal.getName());
        Order order = orderService.getById(id);
        if (order.getUser() == null || !order.getUser().getId().equals(user.getId())) {
            return "redirect:/orders";
        }
        model.addAttribute("order", order);
        model.addAttribute("details", orderService.findDetails(id));
        return "order-detail";
    }
}
