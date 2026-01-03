package vn.web.logistic.controller;

import java.util.Collection;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Controller xử lý các trang liên quan đến authentication
 */
public class LoginController {

    /**
     * Trang chủ - redirect đến login
     */
    @GetMapping("/")
    public String home() {
        return "redirect:/login";
    }

    /**
     * Trang login
     */
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    /**
     * Xử lý sau khi login thành công - redirect dựa trên role
     */
    @GetMapping("/login-success")
    public String loginSuccess(Authentication authentication) {
        if (authentication == null) {
            return "redirect:/login";
        }

        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

        for (GrantedAuthority authority : authorities) {
            String role = authority.getAuthority();

            if (role.equals("ROLE_ADMIN")) {
                return "redirect:/admin/dashboard";
            } else if (role.equals("ROLE_STAFF")) {
                return "redirect:/staff/dashboard";
            } else if (role.equals("ROLE_SHIPPER")) {
                return "redirect:/shipper/dashboard";
            } else if (role.equals("ROLE_CUSTOMER")) {
                return "redirect:/customer/dashboard";
            }
        }

        // Default redirect
        return "redirect:/";
    }

    /**
     * Trang Access Denied
     */
    @GetMapping("/access-denied")
    public String accessDenied() {
        return "access-denied";
    }
}
