package vn.web.logistic.dto.request.customer;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CustomerProfileForm {

    @NotBlank(message = "Họ tên không được để trống")
    @Size(max = 150)
    private String fullName;

    @Email(message = "Email không hợp lệ")
    @Size(max = 100)
    private String email;

    @NotBlank(message = "Số điện thoại không được để trống")
    @Size(max = 20)
    private String phone;
}
