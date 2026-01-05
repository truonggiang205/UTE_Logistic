package vn.web.logistic.dto.request.admin;

import java.util.Set;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StaffAccountRequest {

    @NotBlank(message = "Username không được để trống")
    @Size(min = 3, max = 50, message = "Username phải từ 3-50 ký tự")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "Username chỉ chứa chữ cái, số và dấu gạch dưới")
    private String username;

    @Size(min = 6, message = "Mật khẩu phải ít nhất 6 ký tự")
    private String password; // Chỉ bắt buộc khi tạo mới

    @NotBlank(message = "Họ tên không được để trống")
    @Size(max = 100, message = "Họ tên không được quá 100 ký tự")
    private String fullName;

    @NotBlank(message = "Email không được để trống")
    @Email(message = "Email không hợp lệ")
    private String email;

    @Pattern(regexp = "^(\\+84|0)[0-9]{9,10}$", message = "Số điện thoại không hợp lệ")
    private String phone;

    private String status; // active, inactive, banned

    private Set<String> roleNames; // ADMIN, MANAGER, SHIPPER, STAFF, CUSTOMER

    private String avatarUrl;

    // Thêm thông tin cho Staff entity (nếu có)
    private Long hubId; // Hub được gán cho nhân viên (Manager/Shipper)
}
