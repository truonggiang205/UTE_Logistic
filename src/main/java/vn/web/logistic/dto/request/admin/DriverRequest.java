package vn.web.logistic.dto.request.admin;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DriverRequest {

    @NotBlank(message = "Họ tên không được để trống")
    private String fullName;

    private String phoneNumber;

    @NotBlank(message = "Số bằng lái không được để trống")
    private String licenseNumber;

    private String licenseClass;

    @NotBlank(message = "Số CCCD không được để trống")
    private String identityCard;
}
