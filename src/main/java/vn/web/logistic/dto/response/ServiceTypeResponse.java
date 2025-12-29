package vn.web.logistic.dto.response;

import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;

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
}