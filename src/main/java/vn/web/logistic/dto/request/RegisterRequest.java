package vn.web.logistic.dto.request;

import lombok.*;

@Data
public class RegisterRequest {
    private String username; // Số điện thoại đăng nhập
    private String password;
    private String confirmPassword;
    private String fullName; // Họ tên chủ shop
    private String email;
    private String phone;
    private String businessName; // Tên cửa hàng (Shop name)
    private String taxCode;
    // Địa chỉ lấy hàng mặc định
    private String addressDetail;
    private String ward;
    private String district;
    private String province;
}