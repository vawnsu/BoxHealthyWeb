package com.boxhealthy.controller;

import com.boxhealthy.dto.RevenueChartPoint;
import com.boxhealthy.entity.OrderStatus;
import com.boxhealthy.service.CategoryService;
import com.boxhealthy.service.OrderService;
import com.boxhealthy.service.ProductService;
import com.boxhealthy.service.UserService;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
    public String dashboard(@RequestParam(defaultValue = "month") String period, Model model) {
        BigDecimal revenue = orderService.sumTotalByStatus(OrderStatus.COMPLETED);
        String normalizedPeriod = normalizePeriod(period);
        List<RevenueChartPoint> revenueChart = orderService.revenueChart(normalizedPeriod);
        BigDecimal periodRevenue = orderService.revenueForChart(revenueChart);
        long periodOrderCount = orderService.orderCountForChart(revenueChart);
        BigDecimal averageOrderValue = periodOrderCount == 0
                ? BigDecimal.ZERO
                : periodRevenue.divide(BigDecimal.valueOf(periodOrderCount), 0, RoundingMode.HALF_UP);

        model.addAttribute("productCount", productService.countAll());
        model.addAttribute("activeProductCount", productService.countActive());
        model.addAttribute("categoryCount", categoryService.countAll());
        model.addAttribute("orderCount", orderService.countAll());
        model.addAttribute("pendingOrderCount", orderService.countByStatus(OrderStatus.PENDING));
        model.addAttribute("completedOrderCount", orderService.countByStatus(OrderStatus.COMPLETED));
        model.addAttribute("userCount", userService.countAll());
        model.addAttribute("totalRevenue", revenue);
        model.addAttribute("period", normalizedPeriod);
        model.addAttribute("periodRevenue", periodRevenue);
        model.addAttribute("periodOrderCount", periodOrderCount);
        model.addAttribute("averageOrderValue", averageOrderValue);
        model.addAttribute("revenueChart", revenueChart);
        model.addAttribute("lineChartPoints", toLineChartPoints(revenueChart));
        model.addAttribute("recentOrders", orderService.findRecent(5));
        return "admin-dashboard";
    }

    private String normalizePeriod(String period) {
        if ("week".equalsIgnoreCase(period) || "year".equalsIgnoreCase(period)) {
            return period.toLowerCase();
        }
        return "month";
    }

    private String toLineChartPoints(List<RevenueChartPoint> points) {
        StringBuilder builder = new StringBuilder();
        for (RevenueChartPoint point : points) {
            if (!builder.isEmpty()) {
                builder.append(' ');
            }
            builder.append(point.getX()).append(',').append(point.getY());
        }
        return builder.toString();
    }
}
