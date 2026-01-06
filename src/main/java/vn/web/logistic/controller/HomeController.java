package vn.web.logistic.controller;

import java.security.Principal;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "home";
    }

    @GetMapping("/login")
    public String login(@RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "logout", required = false) String logout,
            @RequestParam(value = "reset", required = false) String reset,
            Model model) {
        if (error != null) {
            model.addAttribute("error", "Email hoặc mật khẩu không đúng!");
        }
        if (logout != null) {
            model.addAttribute("message", "Đăng xuất thành công!");
        }
        if (reset != null) {
            model.addAttribute("message", "Đổi mật khẩu thành công! Vui lòng đăng nhập lại.");
        }
        return "login";
    }

    @GetMapping("/login-success")
    public String loginSuccess(Authentication authentication) {
        if (authentication == null) {
            return "redirect:/login";
        }

        // Redirect theo role
        if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
            return "redirect:/admin/dashboard";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_STAFF"))) {
            return "redirect:/manager/dashboard";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_SHIPPER"))) {
            return "redirect:/shipper/dashboard";
        } else if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_CUSTOMER"))) {
            return "redirect:/customer/overview";
        }

        return "redirect:/";
    }

    @GetMapping("/access-denied")
    public String accessDenied(Model model, Principal principal) {
        if (principal != null) {
            model.addAttribute("message", "Bạn không có quyền truy cập trang này!");
        }
        return "access-denied";
    }
}
