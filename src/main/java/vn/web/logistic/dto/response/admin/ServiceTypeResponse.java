package vn.web.logistic.dto.response.admin;

import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
public class ServiceTypeResponse {
    private Long serviceTypeId;
    private String serviceCode;
    private String serviceName;
    private BigDecimal baseFee;
    private BigDecimal extraPricePerKg;
    private BigDecimal codRate;
    private BigDecimal codMinFee;
    private BigDecimal insuranceRate;
    private String description;

    // Thêm các trường này để hiển thị trên giao diện Admin
    private boolean isActive; // Để tô màu bản ghi (VD: Active thì màu xanh, Inactive màu xám)
    private Integer version; // Hiển thị số phiên bản (V1, V2, V3...)
    private LocalDateTime effectiveFrom; // Ngày bắt đầu áp dụng mức giá này
}