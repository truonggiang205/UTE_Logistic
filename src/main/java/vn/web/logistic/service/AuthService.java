package vn.web.logistic.service;

import vn.web.logistic.dto.request.LoginRequest;
import vn.web.logistic.dto.request.RegisterRequest;

public interface AuthService {
    void logout(String token);

    /**
     * Xử lý đăng ký khách hàng mới (Shop)
     * Bao gồm tạo User, Customer và địa chỉ mặc định
     */
    void register(RegisterRequest dto);

    /**
     * Xử lý đăng nhập hệ thống
     * 
     * @return Chuỗi JWT Token hoặc thông báo trạng thái đăng nhập thành công
     */
    String login(LoginRequest dto);

    /**
     * Xác định URL redirect dựa trên Role của User sau khi đăng nhập
     * Thứ tự ưu tiên: Admin > Staff > Shipper > Customer
     * 
     * @param identifier username, email hoặc phone của user
     * @return URL redirect tương ứng với role của user
     */
    String getRedirectUrlByRole(String identifier);

    /**
     * Kiểm tra số điện thoại đã được đăng ký trong hệ thống chưa
     * 
     * @param phone Số điện thoại cần kiểm tra
     * @return true nếu đã tồn tại, false nếu chưa
     */
    boolean isPhoneRegistered(String phone);
}
