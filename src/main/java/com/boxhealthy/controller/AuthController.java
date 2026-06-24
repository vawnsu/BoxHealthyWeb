package com.boxhealthy.controller;

import com.boxhealthy.dto.RegisterRequest;
import com.boxhealthy.service.UserService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class AuthController {
    private final UserService userService;
    private final boolean googleLoginEnabled;

    public AuthController(UserService userService,
                          @Value("${GOOGLE_CLIENT_ID:}") String googleClientId,
                          @Value("${GOOGLE_CLIENT_SECRET:}") String googleClientSecret) {
        this.userService = userService;
        this.googleLoginEnabled = !googleClientId.isBlank() && !googleClientSecret.isBlank();
    }

    @GetMapping("/login")
    public String login(Model model) {
        model.addAttribute("googleLoginEnabled", googleLoginEnabled);
        return "login";
    }

    @GetMapping("/register")
    public String register(Model model) {
        model.addAttribute("registerRequest", new RegisterRequest());
        model.addAttribute("googleLoginEnabled", googleLoginEnabled);
        return "register";
    }

    @PostMapping("/register")
    public String submitRegister(@ModelAttribute RegisterRequest request, Model model) {
        try {
            userService.registerCustomer(request);
            return "redirect:/login?registered=true";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("registerRequest", request);
            model.addAttribute("googleLoginEnabled", googleLoginEnabled);
            return "register";
        }
    }
}
