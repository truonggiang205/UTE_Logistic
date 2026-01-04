package vn.web.logistic.dto.request.customer;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CustomerAddressForm {

    @NotBlank(message = "Tên liên hệ không được để trống")
    @Size(max = 100)
    private String contactName;

    @NotBlank(message = "Số điện thoại không được để trống")
    @Size(max = 20)
    private String contactPhone;

    @NotBlank(message = "Địa chỉ chi tiết không được để trống")
    @Size(max = 255)
    private String addressDetail;

    @Size(max = 50)
    private String ward;

    @Size(max = 50)
    private String district;

    @Size(max = 50)
    private String province;

    @Size(max = 255)
    private String note;

    private boolean makeDefault;
}
