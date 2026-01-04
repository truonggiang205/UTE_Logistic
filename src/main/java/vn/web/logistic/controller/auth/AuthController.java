package vn.web.logistic.controller.auth;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.dto.request.LoginRequest;
import vn.web.logistic.dto.request.RegisterRequest;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.AuthService;
import vn.web.logistic.service.OtpService;

@Controller
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

	private final AuthService authService;      
    private final OtpService otpService;         
    private final UserRepository userRepository;

    @GetMapping("/register")
    public String showRegisterPage(HttpServletRequest request) {
        // Báo cho main-layout biết là phải ẩn Footer đi
        request.setAttribute("hideFooter", true);
        return "auth/register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute RegisterRequest request, Model model, HttpServletRequest requestHttp) {
        // Kiểm tra mật khẩu nhập lại
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            model.addAttribute("error", "Mật khẩu nhập lại không khớp!");
            requestHttp.setAttribute("hideFooter", true); // Giữ footer ẩn nếu có lỗi
            return "auth/register";
        }
        
        try {
            authService.register(request);
            return "redirect:/auth/login?success";
        } catch (Exception e) {
            model.addAttribute("error", "Đăng ký thất bại: " + e.getMessage());
            requestHttp.setAttribute("hideFooter", true);
            return "auth/register";
        }
    }

    @GetMapping("/login")
    public String showLoginPage(HttpServletRequest request) {
        request.setAttribute("hideFooter", true);
        return "auth/login";
    }

    @PostMapping("/login")
    public String login(@ModelAttribute LoginRequest request, HttpServletResponse response, Model model) {
        try {
            String token = authService.login(request);
            
            // Lưu JWT vào Cookie để trình duyệt tự gửi lên trong các request sau
            Cookie cookie = new Cookie("JWT_TOKEN", token);
            cookie.setPath("/");
            cookie.setHttpOnly(true); // Chống XSS
            cookie.setMaxAge(86400);  // Hết hạn sau 1 ngày
            response.addCookie(cookie);
            
            return "redirect:/customer/overview";
        } catch (Exception e) {
            model.addAttribute("error", "Đăng nhập thất bại: " + e.getMessage());
            return "auth/login";
        }
    }
    

    @PostMapping("/request-otp")
    @ResponseBody
    public ResponseEntity<String> requestOtp(@RequestBody RegisterRequest dto) {
        // 1. Kiểm tra SĐT đã tồn tại trong hệ thống chưa
        if (userRepository.existsByPhone(dto.getPhone())) {
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
    
 // Thêm phương thức này vào cuối class AuthController
    @GetMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response, jakarta.servlet.http.HttpSession session) {
        // 1. Xóa Session nếu có sử dụng
        if (session != null) {
            session.invalidate();
        }

        // 2. Xóa JWT Token bằng cách tạo một Cookie cùng tên nhưng hết hạn ngay lập tức
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", null);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0); // Đặt thời gian tồn tại bằng 0 để trình duyệt xóa ngay
        response.addCookie(cookie);

        // 3. Quay về trang login kèm theo tham số báo đăng xuất thành công
        return "redirect:/auth/login?logout";
    }
}