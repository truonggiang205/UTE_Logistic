package vn.web.logistic.service;

import vn.web.logistic.dto.request.RegisterRequest;
import vn.web.logistic.dto.request.LoginRequest;

/**
 * Giao diện định nghĩa các nghiệp vụ liên quan đến xác thực và đăng ký
 */
public interface AuthService {

    /**
     * Xử lý đăng ký khách hàng mới (Shop) 
     * Bao gồm tạo User, Customer và địa chỉ mặc định
     */
    void register(RegisterRequest dto);

    /**
     * Xử lý đăng nhập hệ thống
     * @return Chuỗi JWT Token hoặc thông báo trạng thái đăng nhập thành công
     */
    String login(LoginRequest dto);
}