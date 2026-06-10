package com.boxhealthy.controller;

import com.boxhealthy.entity.User;
import com.boxhealthy.service.CartService;
import com.boxhealthy.service.UserService;
import jakarta.servlet.http.HttpSession;
import java.security.Principal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class CartController {
    private final CartService cartService;
    private final UserService userService;

    public CartController(CartService cartService, UserService userService) {
        this.cartService = cartService;
        this.userService = userService;
    }

    @GetMapping("/cart")
    public String cart(HttpSession session, Model model, Principal principal) {
        User user = getCurrentUser(principal);
        if (user != null) {
            cartService.mergeSessionCartToUser(session, user);
        }
        model.addAttribute("items", cartService.getItems(session, user));
        model.addAttribute("total", cartService.getTotal(session, user));
        return "cart";
    }

    @PostMapping("/cart/add/{productId}")
    public String add(@PathVariable Long productId, HttpSession session, Principal principal) {
        cartService.add(session, getCurrentUser(principal), productId);
        return "redirect:/cart";
    }

    @PostMapping("/cart/update/{productId}")
    public String update(@PathVariable Long productId, @RequestParam int quantity,
                         HttpSession session, Principal principal) {
        cartService.update(session, getCurrentUser(principal), productId, quantity);
        return "redirect:/cart";
    }

    @PostMapping("/cart/remove/{productId}")
    public String remove(@PathVariable Long productId, HttpSession session, Principal principal) {
        cartService.remove(session, getCurrentUser(principal), productId);
        return "redirect:/cart";
    }

    private User getCurrentUser(Principal principal) {
        if (principal == null) {
            return null;
        }
        return userService.getByEmail(principal.getName());
    }
}
