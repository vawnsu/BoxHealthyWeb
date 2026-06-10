package com.boxhealthy.controller;

import com.boxhealthy.entity.Order;
import com.boxhealthy.entity.OrderStatus;
import com.boxhealthy.service.CategoryService;
import com.boxhealthy.service.OrderService;
import com.boxhealthy.service.ProductService;
import com.boxhealthy.service.UserService;
import java.math.BigDecimal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminController {
    private final ProductService productService;
    private final CategoryService categoryService;
    private final OrderService orderService;
    private final UserService userService;

    public AdminController(ProductService productService, CategoryService categoryService,
                           OrderService orderService, UserService userService) {
        this.productService = productService;
        this.categoryService = categoryService;
        this.orderService = orderService;
        this.userService = userService;
    }

    @GetMapping("/admin")
    public String dashboard(Model model) {
        BigDecimal revenue = orderService.sumTotalByStatus(OrderStatus.COMPLETED);

        model.addAttribute("productCount", productService.countAll());
        model.addAttribute("activeProductCount", productService.countActive());
        model.addAttribute("categoryCount", categoryService.countAll());
        model.addAttribute("orderCount", orderService.countAll());
        model.addAttribute("pendingOrderCount", orderService.countByStatus(OrderStatus.PENDING));
        model.addAttribute("completedOrderCount", orderService.countByStatus(OrderStatus.COMPLETED));
        model.addAttribute("userCount", userService.countAll());
        model.addAttribute("totalRevenue", revenue);
        model.addAttribute("recentOrders", orderService.findRecent(5));
        return "admin-dashboard";
    }
}
