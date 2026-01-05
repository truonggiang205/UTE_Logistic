package vn.web.logistic.dto.request.admin;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class HubRequest {

    @NotBlank(message = "Tên Hub không được để trống")
    @Size(max = 100, message = "Tên Hub không được quá 100 ký tự")
    private String hubName;

    @Size(max = 255, message = "Địa chỉ không được quá 255 ký tự")
    private String address;

    @Size(max = 50, message = "Phường/Xã không được quá 50 ký tự")
    private String ward;

    @Size(max = 50, message = "Quận/Huyện không được quá 50 ký tự")
    private String district;

    @Size(max = 50, message = "Tỉnh/Thành phố không được quá 50 ký tự")
    private String province;

    private String hubLevel; // central, regional, local

    @Size(max = 20, message = "Số điện thoại không được quá 20 ký tự")
    private String contactPhone;

    @Size(max = 100, message = "Email không được quá 100 ký tự")
    private String email;
}
