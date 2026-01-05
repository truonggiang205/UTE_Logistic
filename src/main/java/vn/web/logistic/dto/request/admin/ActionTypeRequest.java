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
public class ActionTypeRequest {

    @NotBlank(message = "Mã hành động không được để trống")
    @Size(max = 20, message = "Mã hành động không được quá 20 ký tự")
    @Pattern(regexp = "^[A-Z_]+$", message = "Mã hành động chỉ được chứa chữ in hoa và dấu gạch dưới")
    private String actionCode;

    @NotBlank(message = "Tên hành động không được để trống")
    @Size(max = 100, message = "Tên hành động không được quá 100 ký tự")
    private String actionName;

    @Size(max = 500, message = "Mô tả không được quá 500 ký tự")
    private String description;
}
