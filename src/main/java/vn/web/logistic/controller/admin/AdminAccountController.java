package vn.web.logistic.controller.admin;

import java.time.LocalDateTime;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import vn.web.logistic.repository.UserRepository;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
public class AdminAccountController {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public AdminAccountController(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/profile")
    public String profile(Authentication authentication, Model model) {
        String username = authentication == null ? null : authentication.getName();
        if (username != null) {
            userRepository.findByUsername(username).ifPresent(u -> model.addAttribute("me", u));
        }
        return "admin/profile";
    }

    @GetMapping("/settings")
    public String settings() {
        return "admin/settings";
    }

    @GetMapping("/change-password")
    public String changePasswordForm() {
        return "admin/change-password";
    }

    @PostMapping("/change-password")
    public String changePassword(
            Authentication authentication,
            @RequestParam("currentPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            RedirectAttributes redirectAttributes) {

        if (authentication == null) {
            redirectAttributes.addFlashAttribute("message", "Bạn cần đăng nhập lại");
            return "redirect:/auth/login";
        }

        if (newPassword == null || newPassword.isBlank()) {
            redirectAttributes.addFlashAttribute("message", "Mật khẩu mới không được để trống");
            return "redirect:/admin/change-password";
        }

        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("message", "Xác nhận mật khẩu không khớp");
            return "redirect:/admin/change-password";
        }

        var user = userRepository.findByUsername(authentication.getName())
                .orElseThrow(() -> new IllegalArgumentException("User không tồn tại"));

        if (!passwordEncoder.matches(currentPassword, user.getPasswordHash())) {
            redirectAttributes.addFlashAttribute("message", "Mật khẩu hiện tại không đúng");
            return "redirect:/admin/change-password";
        }

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);

        redirectAttributes.addFlashAttribute("message", "Đổi mật khẩu thành công");
        return "redirect:/admin/profile";
    }
}
