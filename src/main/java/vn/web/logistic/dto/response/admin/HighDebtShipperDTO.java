package vn.web.logistic.dto.response.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO cho thông tin Shipper nợ COD cao
 * Tách riêng từ WarningResponse.HighDebtShipperDTO để Hibernate có thể resolve
 * trong JPQL
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HighDebtShipperDTO {
    private Long shipperId;
    private String shipperName;
    private String phone;
    private BigDecimal totalPendingCOD;
}
