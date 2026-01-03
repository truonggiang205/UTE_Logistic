package vn.web.logistic.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO cho yêu cầu cập nhật thông tin cá nhân Shipper
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UpdateProfileRequest {

    private String fullName;

    private String phone;

    private String email;

    private String vehicleType;
}
