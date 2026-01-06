package vn.web.logistic.controller;

import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

/**
 * LEGACY PASSWORD RESET CONTROLLER
 * Các route chính đã được chuyển sang AuthController (/auth/*)
 * DISABLED: Conflicts with HomeController at /login
 */
// @Controller // DISABLED - conflicts with HomeController
@RequiredArgsConstructor
public class PasswordResetController {

    /**
     * Redirect từ route cũ /forgot-password sang route mới /auth/forgot-password
     */
    @GetMapping("/forgot-password")
    public String forgotPasswordRedirect() {
        return "redirect:/auth/forgot-password";
    }

    /**
     * Redirect từ route cũ /reset-password sang route mới /auth/reset-password
     * Lưu ý: Cần giữ token query param
     */
    @GetMapping("/reset-password")
    public String resetPasswordRedirect() {
        return "redirect:/auth/reset-password";
    }

    /**
     * Redirect từ route cũ /login sang route mới /auth/login
     */
    @GetMapping("/login")
    public String loginRedirect() {
        return "redirect:/auth/login";
    }
}
