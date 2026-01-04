package vn.web.logistic.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;
import jakarta.servlet.http.HttpServletRequest;
import vn.web.logistic.service.PasswordResetService;

@Controller
@RequiredArgsConstructor
public class PasswordResetController {

    private final PasswordResetService passwordResetService;

    @GetMapping("/forgot-password")
    public String forgotPasswordPage() {
        return "forgot-password";
    }

    @PostMapping("/forgot-password")
    public String forgotPasswordSubmit(@RequestParam("email") String email, Model model, HttpServletRequest request) {
        // Tránh user enumeration: luôn trả thông báo chung.
        String rawToken = passwordResetService.createResetToken(email);

        model.addAttribute("message", "Nếu email tồn tại, hệ thống đã tạo link đặt lại mật khẩu.");

        // Dev/demo: hiển thị link trực tiếp để test nhanh (không cần cấu hình email)
        if (rawToken != null) {
            String ctx = request != null ? request.getContextPath() : "";
            String link = ctx + "/reset-password?token=" + rawToken;
            model.addAttribute("resetLink", link);
        }

        return "forgot-password";
    }

    @GetMapping("/reset-password")
    public String resetPasswordPage(@RequestParam("token") String token, Model model) {
        if (!passwordResetService.isTokenValid(token)) {
            model.addAttribute("error", "Link đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
            return "forgot-password";
        }

        model.addAttribute("token", token);
        return "reset-password";
    }

    @PostMapping("/reset-password")
    public String resetPasswordSubmit(
            @RequestParam("token") String token,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            Model model) {

        try {
            passwordResetService.resetPassword(token, newPassword, confirmPassword);
            return "redirect:/login?reset=true";
        } catch (Exception e) {
            model.addAttribute("token", token);
            model.addAttribute("error", e.getMessage());
            return "reset-password";
        }
    }
}
