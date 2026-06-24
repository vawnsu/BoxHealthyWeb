package com.boxhealthy.controller;

import com.boxhealthy.entity.Role;
import com.boxhealthy.entity.User;
import com.boxhealthy.service.UserService;
import java.security.Principal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AdminUserController {
    private final UserService userService;

    public AdminUserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/admin/users")
    public String list(Model model) {
        model.addAttribute("users", userService.findAllNewestFirst());
        model.addAttribute("totalUsers", userService.countAll());
        model.addAttribute("customerCount", userService.countByRole(Role.CUSTOMER));
        model.addAttribute("adminCount", userService.countByRole(Role.ADMIN));
        model.addAttribute("enabledUserCount", userService.countByEnabled(true));
        model.addAttribute("disabledUserCount", userService.countByEnabled(false));
        return "admin-users";
    }

    @PostMapping("/admin/users/{id}/status")
    public String updateStatus(@PathVariable Long id,
                               @RequestParam boolean enabled,
                               Principal principal,
                               RedirectAttributes redirectAttributes) {
        User user = userService.getById(id);
        if (principal != null && user.getEmail().equalsIgnoreCase(principal.getName()) && !enabled) {
            redirectAttributes.addFlashAttribute("adminUserError",
                    "Không thể khóa tài khoản đang đăng nhập.");
            return "redirect:/admin/users";
        }

        userService.updateEnabled(id, enabled);
        redirectAttributes.addFlashAttribute("adminUserMessage",
                enabled ? "Đã mở khóa tài khoản." : "Đã khóa tài khoản.");
        return "redirect:/admin/users";
    }
}
