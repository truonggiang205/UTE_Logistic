package vn.web.logistic.service;

import vn.web.logistic.dto.request.RegisterRequest;

public interface OtpService {
    // ===== PHONE OTP (for Registration) =====
    String generateAndSaveOtp(RegisterRequest request);

    boolean validateOtp(String phone, String otp);

    RegisterRequest getPendingRegistration(String phone);

    void clearOtp(String phone);

    // ===== EMAIL OTP (for Forgot Password) =====
    /**
     * Tạo OTP 6 số và gửi qua email
     * 
     * @param email Email của user
     * @return OTP đã tạo (dùng cho testing) hoặc null nếu email không tồn tại
     */
    String generateEmailOtp(String email);

    /**
     * Xác minh OTP từ email
     * 
     * @param email Email của user
     * @param otp   OTP user nhập
     * @return true nếu OTP đúng và chưa hết hạn
     */
    boolean validateEmailOtp(String email, String otp);

    /**
     * Xóa OTP sau khi đã sử dụng hoặc hết hạn
     * 
     * @param email Email của user
     */
    void clearEmailOtp(String email);
}
