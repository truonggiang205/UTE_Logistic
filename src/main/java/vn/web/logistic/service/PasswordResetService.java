package vn.web.logistic.service;

public interface PasswordResetService {

    /**
     * Tạo token đặt lại mật khẩu cho email. Trả về token thô để tạo link
     * (dev/demo).
     * Nếu email không tồn tại thì trả về null.
     */
    String createResetToken(String email);

    /**
     * Kiểm tra token có hợp lệ để hiển thị trang reset.
     */
    boolean isTokenValid(String rawToken);

    /**
     * Đặt lại mật khẩu bằng token.
     */
    void resetPassword(String rawToken, String newPassword, String confirmPassword);

    /**
     * Đặt lại mật khẩu trực tiếp bằng email (dùng sau khi đã xác minh OTP).
     */
    void resetPasswordByEmail(String email, String newPassword);
}
