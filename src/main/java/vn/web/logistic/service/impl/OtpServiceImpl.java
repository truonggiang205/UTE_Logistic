package vn.web.logistic.service.impl;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.request.RegisterRequest;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.EmailService;
import vn.web.logistic.service.OtpService;

@Service
@RequiredArgsConstructor
@Slf4j
public class OtpServiceImpl implements OtpService {

    private final UserRepository userRepository;
    private final EmailService emailService;

    // ===== PHONE OTP STORAGE =====
    private final Map<String, PendingData> otpCache = new ConcurrentHashMap<>();

    private static class PendingData {
        RegisterRequest request;
        String otp;
    }

    // ===== EMAIL OTP STORAGE =====
    private final Map<String, EmailOtpData> emailOtpCache = new ConcurrentHashMap<>();

    private static class EmailOtpData {
        String otp;
        LocalDateTime expiresAt;
    }

    private static final int EMAIL_OTP_EXPIRE_MINUTES = 5;

    // ==================== PHONE OTP (for Registration) ====================

    @Override
    public String generateAndSaveOtp(RegisterRequest request) {
        String otp = String.format("%06d", new Random().nextInt(1000000));

        PendingData data = new PendingData();
        data.request = request;
        data.otp = otp;

        otpCache.put(request.getPhone(), data);

        // Giả lập gửi SMS (Bạn sẽ thấy mã in ra ở Console Spring Boot)
        System.out.println("NGHV LOGISTICS - OTP cho " + request.getPhone() + " là: " + otp);
        return otp;
    }

    @Override
    public boolean validateOtp(String phone, String otp) {
        PendingData data = otpCache.get(phone);
        return data != null && data.otp.equals(otp);
    }

    @Override
    public RegisterRequest getPendingRegistration(String phone) {
        PendingData data = otpCache.get(phone);
        return (data != null) ? data.request : null;
    }

    @Override
    public void clearOtp(String phone) {
        otpCache.remove(phone);
    }

    // ==================== EMAIL OTP (for Forgot Password) ====================

    @Override
    public String generateEmailOtp(String email) {
        if (email == null || email.isBlank()) {
            return null;
        }

        // Kiểm tra email có tồn tại trong hệ thống
        var userOpt = userRepository.findByEmail(email.trim());
        if (userOpt.isEmpty()) {
            log.warn("[OTP] Email not found: {}", email);
            return null;
        }

        // Tạo OTP 6 số
        String otp = String.format("%06d", new Random().nextInt(1000000));

        // Lưu vào cache với thời gian hết hạn
        EmailOtpData data = new EmailOtpData();
        data.otp = otp;
        data.expiresAt = LocalDateTime.now().plusMinutes(EMAIL_OTP_EXPIRE_MINUTES);
        emailOtpCache.put(email.toLowerCase(), data);

        // Gửi OTP qua email
        try {
            emailService.sendOtpEmail(email, otp);
            log.info("[OTP] Sent email OTP to: {}", email);
        } catch (Exception e) {
            log.error("[OTP] Failed to send email to {}: {}", email, e.getMessage());
        }

        // Log cho dev mode
        log.info("[DEV MODE] OTP for {} is: {}", email, otp);
        System.out.println("============================================");
        System.out.println("[DEV MODE] OTP for " + email + " is: " + otp);
        System.out.println("============================================");

        return otp;
    }

    @Override
    public boolean validateEmailOtp(String email, String otp) {
        if (email == null || otp == null) {
            return false;
        }

        EmailOtpData data = emailOtpCache.get(email.toLowerCase());
        if (data == null) {
            log.warn("[OTP] No OTP found for email: {}", email);
            return false;
        }

        // Kiểm tra hết hạn
        if (LocalDateTime.now().isAfter(data.expiresAt)) {
            log.warn("[OTP] OTP expired for email: {}", email);
            emailOtpCache.remove(email.toLowerCase());
            return false;
        }

        // So khớp OTP
        boolean valid = data.otp.equals(otp.trim());
        if (!valid) {
            log.warn("[OTP] Invalid OTP for email: {}", email);
        }
        return valid;
    }

    @Override
    public void clearEmailOtp(String email) {
        if (email != null) {
            emailOtpCache.remove(email.toLowerCase());
        }
    }
}
