package vn.web.logistic.controller.auth;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.request.LoginRequest;
import vn.web.logistic.dto.request.RegisterRequest;
import vn.web.logistic.service.AuthService;
import vn.web.logistic.service.OtpService;
import vn.web.logistic.service.PasswordResetService;

/**
 * AUTHENTICATION CONTROLLER
 * Quản lý toàn bộ luồng xác thực: Login, Register, Logout, Forgot Password
 */
@Controller
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final OtpService otpService;
    private final PasswordResetService passwordResetService;

    // ==================== ĐĂNG KÝ (REGISTER) ====================

    @GetMapping("/register")
    public String showRegisterPage(HttpServletRequest request) {
        request.setAttribute("hideFooter", true);
        return "auth/register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute RegisterRequest request, Model model,
            HttpServletRequest requestHttp, RedirectAttributes ra) {
        // Kiểm tra mật khẩu nhập lại
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            model.addAttribute("error", "Mật khẩu nhập lại không khớp!");
            requestHttp.setAttribute("hideFooter", true);
            return "auth/register";
        }

        try {
            authService.register(request);
            ra.addFlashAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            return "redirect:/auth/login";
        } catch (Exception e) {
            model.addAttribute("error", "Đăng ký thất bại: " + e.getMessage());
            requestHttp.setAttribute("hideFooter", true);
            return "auth/register";
        }
    }

    // ==================== OTP VERIFICATION (FOR REGISTER) ====================

    @PostMapping("/request-otp")
    @ResponseBody
    public ResponseEntity<String> requestOtp(@RequestBody RegisterRequest dto) {
        // 1. Kiểm tra SĐT đã tồn tại trong hệ thống chưa - gọi từ Service layer
        if (authService.isPhoneRegistered(dto.getPhone())) {
            return ResponseEntity.badRequest().body("Số điện thoại này đã được đăng ký!");
        }

        // 2. Tạo và gửi mã OTP (lưu tạm vào OtpService)
        otpService.generateAndSaveOtp(dto);
        return ResponseEntity.ok("OTP_SENT");
    }

    @PostMapping("/verify-otp")
    @ResponseBody
    public ResponseEntity<String> verifyOtp(@RequestParam String phone, @RequestParam String otp) {
        // 1. Kiểm tra mã OTP người dùng nhập
        if (otpService.validateOtp(phone, otp)) {
            // 2. Nếu đúng, lấy dữ liệu tạm và lưu vào Database
            RegisterRequest pendingRequest = otpService.getPendingRegistration(phone);
            authService.register(pendingRequest);

            otpService.clearOtp(phone); // Dọn dẹp bộ nhớ tạm
            return ResponseEntity.ok("SUCCESS");
        }
        return ResponseEntity.badRequest().body("Mã OTP không chính xác!");
    }

    // ==================== ĐĂNG NHẬP (LOGIN) ====================

    @GetMapping("/login")
    public String showLoginPage(HttpServletRequest request, Model model) {
        request.setAttribute("hideFooter", true);
        return "auth/login";
    }

    @PostMapping("/login")
    public String login(@ModelAttribute LoginRequest request, HttpServletResponse response,
            Model model, HttpServletRequest httpRequest) {
        try {
            String token = authService.login(request);

            // Lưu JWT vào Cookie để trình duyệt tự gửi lên trong các request sau
            Cookie cookie = new Cookie("JWT_TOKEN", token);
            cookie.setPath("/");
            cookie.setHttpOnly(true); // Chống XSS
            cookie.setMaxAge(86400); // Hết hạn sau 1 ngày
            response.addCookie(cookie);

            // Redirect theo Role của User - gọi từ Service layer
            return "redirect:" + authService.getRedirectUrlByRole(request.getIdentifier());

        } catch (Exception e) {
            model.addAttribute("error", "Đăng nhập thất bại: " + e.getMessage());
            httpRequest.setAttribute("hideFooter", true);
            return "auth/login";
        }
    }

    // ==================== ĐĂNG XUẤT (LOGOUT) ====================

    @GetMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, RedirectAttributes ra) {
        // 1. Xóa Session nếu có sử dụng
        if (session != null) {
            session.invalidate();
        }

        // 2. Xóa JWT Token bằng cách tạo một Cookie cùng tên nhưng hết hạn ngay lập tức
        Cookie cookie = new Cookie("JWT_TOKEN", null);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0); // Đặt thời gian tồn tại bằng 0 để trình duyệt xóa ngay
        response.addCookie(cookie);

        // 3. Quay về trang login với thông báo
        ra.addFlashAttribute("success", "Đăng xuất thành công!");
        return "redirect:/auth/login";
    }

    // ==================== QUÊN MẬT KHẨU (FORGOT PASSWORD) ====================

    @GetMapping("/forgot-password")
    public String forgotPasswordPage(HttpServletRequest request) {
        request.setAttribute("hideFooter", true);
        return "auth/forgot-password";
    }

    @PostMapping("/forgot-password")
    public String forgotPasswordSubmit(@RequestParam("email") String email, Model model,
            HttpServletRequest request) {
        request.setAttribute("hideFooter", true);

        // Tránh user enumeration: luôn trả thông báo chung.
        String rawToken = passwordResetService.createResetToken(email);

        model.addAttribute("message", "Nếu email tồn tại, hệ thống đã tạo link đặt lại mật khẩu.");

        // Dev/demo: hiển thị link trực tiếp để test nhanh (không cần cấu hình email)
        if (rawToken != null) {
            String ctx = request.getContextPath();
            String link = ctx + "/auth/reset-password?token=" + rawToken;
            model.addAttribute("resetLink", link);
        }

        return "auth/forgot-password";
    }

    // ==================== ĐẶT LẠI MẬT KHẨU (RESET PASSWORD) ====================

    @GetMapping("/reset-password")
    public String resetPasswordPage(@RequestParam("token") String token, Model model,
            HttpServletRequest request) {
        request.setAttribute("hideFooter", true);

        if (!passwordResetService.isTokenValid(token)) {
            model.addAttribute("error", "Link đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
            return "auth/forgot-password";
        }

        model.addAttribute("token", token);
        return "auth/reset-password";
    }

    @PostMapping("/reset-password")
    public String resetPasswordSubmit(
            @RequestParam("token") String token,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            Model model, HttpServletRequest request, RedirectAttributes ra) {

        request.setAttribute("hideFooter", true);

        try {
            passwordResetService.resetPassword(token, newPassword, confirmPassword);
            ra.addFlashAttribute("success", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
            return "redirect:/auth/login";
        } catch (Exception e) {
            model.addAttribute("token", token);
            model.addAttribute("error", e.getMessage());
            return "auth/reset-password";
        }
    }
}