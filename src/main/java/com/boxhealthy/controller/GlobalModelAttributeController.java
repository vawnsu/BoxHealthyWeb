package com.boxhealthy.controller;

import com.boxhealthy.dto.CartItemDto;
import com.boxhealthy.entity.User;
import com.boxhealthy.service.CartService;
import com.boxhealthy.service.UserService;
import jakarta.servlet.http.HttpSession;
import java.security.Principal;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAttributeController {
    private final UserService userService;
    private final CartService cartService;

    public GlobalModelAttributeController(UserService userService, CartService cartService) {
        this.userService = userService;
        this.cartService = cartService;
    }

    @ModelAttribute("currentUser")
    public User currentUser(Principal principal) {
        return resolveCurrentUser(principal);
    }

    @ModelAttribute("cartCount")
    public int cartCount(HttpSession session, Principal principal) {
        User user = resolveCurrentUser(principal);
        return cartService.getItems(session, user).stream()
                .mapToInt(CartItemDto::getQuantity)
                .sum();
    }

    private User resolveCurrentUser(Principal principal) {
        if (principal == null) {
            return null;
        }
        return userService.findByEmail(principal.getName()).orElse(null);
    }
}
