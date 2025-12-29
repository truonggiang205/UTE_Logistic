package vn.web.logistic.dto.request;

import jakarta.validation.constraints.*;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class ServiceTypeRequest {

    @NotBlank(message = "Mã dịch vụ không được để trống")
    @Size(min = 2, max = 20, message = "Mã dịch vụ từ 2-20 ký tự")
    private String serviceCode;

    @NotBlank(message = "Tên dịch vụ không được để trống")
    private String serviceName;

    @NotNull(message = "Phí cơ bản không được null")
    @Min(value = 0, message = "Phí cơ bản không được âm")
    private BigDecimal baseFee;

    @Min(value = 0, message = "Phí thêm/kg không được âm")
    private BigDecimal extraPricePerKg;

    @DecimalMin(value = "0.0", message = "Tỉ lệ COD thấp nhất là 0")
    @DecimalMax(value = "1.0", message = "Tỉ lệ COD cao nhất là 1 (100%)")
    private BigDecimal codRate;

    private BigDecimal codMinFee;

    private BigDecimal insuranceRate;

    private String description;
}