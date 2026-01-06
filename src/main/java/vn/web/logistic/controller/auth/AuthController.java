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
            HttpServletRequest request, HttpSession session, RedirectAttributes ra) {
        request.setAttribute("hideFooter", true);

        // Gửi OTP qua email
        String otp = otpService.generateEmailOtp(email);

        if (otp != null) {
            // Lưu email vào session để sử dụng ở bước tiếp theo
            session.setAttribute("resetEmail", email);

            // Dev mode: hiển thị OTP trong flash message
            ra.addFlashAttribute("email", email);
            ra.addFlashAttribute("devOtp", otp); // Chỉ dev mode

            return "redirect:/auth/verify-reset-otp";
        } else {
            // Không tìm thấy email - vẫn hiển thị thông báo chung để tránh user enumeration
            model.addAttribute("message", "Nếu email tồn tại trong hệ thống, chúng tôi đã gửi mã OTP.");
            return "auth/forgot-password";
        }
    }

    // ==================== XÁC MINH OTP RESET PASSWORD ====================

    @GetMapping("/verify-reset-otp")
    public String verifyResetOtpPage(HttpServletRequest request, HttpSession session, Model model) {
        request.setAttribute("hideFooter", true);

        String email = (String) session.getAttribute("resetEmail");
        if (email == null) {
            return "redirect:/auth/forgot-password";
        }

        model.addAttribute("email", email);
        return "auth/verify-reset-otp";
    }

    @PostMapping("/verify-reset-otp")
    public String verifyResetOtpSubmit(@RequestParam("otp") String otp,
            HttpServletRequest request, HttpSession session, Model model, RedirectAttributes ra) {
        request.setAttribute("hideFooter", true);

        String email = (String) session.getAttribute("resetEmail");
        if (email == null) {
            return "redirect:/auth/forgot-password";
        }

        if (otpService.validateEmailOtp(email, otp)) {
            // OTP đúng - đánh dấu đã xác minh
            session.setAttribute("otpVerified", true);
            otpService.clearEmailOtp(email);
            return "redirect:/auth/reset-password";
        } else {
            model.addAttribute("email", email);
            model.addAttribute("error", "Mã OTP không chính xác hoặc đã hết hạn!");
            return "auth/verify-reset-otp";
        }
    }

    @PostMapping("/resend-reset-otp")
    @ResponseBody
    public ResponseEntity<String> resendResetOtp(HttpSession session) {
        String email = (String) session.getAttribute("resetEmail");
        if (email == null) {
            return ResponseEntity.badRequest().body("Session hết hạn, vui lòng thử lại!");
        }

        String otp = otpService.generateEmailOtp(email);
        if (otp != null) {
            return ResponseEntity.ok("OTP đã được gửi lại!");
        }
        return ResponseEntity.badRequest().body("Không thể gửi OTP, vui lòng thử lại!");
    }

    // ==================== ĐẶT LẠI MẬT KHẨU (RESET PASSWORD) ====================

    @GetMapping("/reset-password")
    public String resetPasswordPage(HttpServletRequest request, HttpSession session, Model model) {
        request.setAttribute("hideFooter", true);

        // Kiểm tra đã verify OTP chưa
        String email = (String) session.getAttribute("resetEmail");
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");

        if (email == null || otpVerified == null || !otpVerified) {
            model.addAttribute("error", "Vui lòng xác minh OTP trước khi đặt lại mật khẩu.");
            return "redirect:/auth/forgot-password";
        }

        model.addAttribute("email", email);
        return "auth/reset-password";
    }

    @PostMapping("/reset-password")
    public String resetPasswordSubmit(
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            Model model, HttpServletRequest request, HttpSession session, RedirectAttributes ra) {

        request.setAttribute("hideFooter", true);

        // Kiểm tra session
        String email = (String) session.getAttribute("resetEmail");
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");

        if (email == null || otpVerified == null || !otpVerified) {
            return "redirect:/auth/forgot-password";
        }

        // Validate passwords
        if (newPassword == null || newPassword.isBlank()) {
            model.addAttribute("email", email);
            model.addAttribute("error", "Mật khẩu mới không được để trống.");
            return "auth/reset-password";
        }
        if (newPassword.length() < 6) {
            model.addAttribute("email", email);
            model.addAttribute("error", "Mật khẩu tối thiểu 6 ký tự.");
            return "auth/reset-password";
        }
        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("email", email);
            model.addAttribute("error", "Mật khẩu xác nhận không khớp.");
            return "auth/reset-password";
        }

        try {
            // Đặt lại mật khẩu trực tiếp bằng email
            passwordResetService.resetPasswordByEmail(email, newPassword);

            // Xóa session data
            session.removeAttribute("resetEmail");
            session.removeAttribute("otpVerified");

            ra.addFlashAttribute("success", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
            return "redirect:/auth/login";
        } catch (Exception e) {
            model.addAttribute("email", email);
            model.addAttribute("error", e.getMessage());
            return "auth/reset-password";
        }
    }
}