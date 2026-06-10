package com.boxhealthy.controller;

import com.boxhealthy.dto.CheckoutRequest;
import com.boxhealthy.entity.User;
import com.boxhealthy.service.CartService;
import com.boxhealthy.service.OrderService;
import com.boxhealthy.service.UserService;
import jakarta.servlet.http.HttpSession;
import java.security.Principal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class CheckoutController {
    private final CartService cartService;
    private final OrderService orderService;
    private final UserService userService;

    public CheckoutController(CartService cartService, OrderService orderService, UserService userService) {
        this.cartService = cartService;
        this.orderService = orderService;
        this.userService = userService;
    }

    @GetMapping("/checkout")
    public String checkout(HttpSession session, Model model, Principal principal) {
        CheckoutRequest request = new CheckoutRequest();
        User user = getCurrentUser(principal);
        if (user != null) {
            cartService.mergeSessionCartToUser(session, user);
            request.setCustomerName(user.getFullName());
            request.setEmail(user.getEmail());
            request.setPhone(user.getPhone());
            request.setAddress(user.getAddress());
        }
        model.addAttribute("checkoutRequest", request);
        model.addAttribute("items", cartService.getItems(session, user));
        model.addAttribute("total", cartService.getTotal(session, user));
        return "checkout";
    }

    @PostMapping("/checkout")
    public String submit(@ModelAttribute CheckoutRequest request, HttpSession session,
                         Principal principal, Model model) {
        User user = getCurrentUser(principal);
        try {
            orderService.createOrder(user, request, cartService.getItems(session, user));
            cartService.clear(session, user);
            model.addAttribute("message", "Đặt hàng thành công! Box Healthy sẽ liên hệ xác nhận sớm.");
            return "checkout-success";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("checkoutRequest", request);
            model.addAttribute("items", cartService.getItems(session, user));
            model.addAttribute("total", cartService.getTotal(session, user));
            return "checkout";
        }
    }

    private User getCurrentUser(Principal principal) {
        if (principal == null) {
            return null;
        }
        return userService.getByEmail(principal.getName());
    }
}
