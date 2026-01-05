package vn.web.logistic.dto.request.admin;

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
public class RoleRequest {

    @NotBlank(message = "Tên role không được để trống")
    @Size(min = 2, max = 50, message = "Tên role phải từ 2-50 ký tự")
    @Pattern(regexp = "^[A-Z_]+$", message = "Tên role chỉ chứa CHỮ IN HOA và dấu gạch dưới")
    private String roleName;

    @Size(max = 255, message = "Mô tả không được quá 255 ký tự")
    private String description;

    private String status; // active, inactive
}
