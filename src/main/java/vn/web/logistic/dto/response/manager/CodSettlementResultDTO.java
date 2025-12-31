package vn.web.logistic.dto.response.manager;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO response cho kết quả quyết toán COD
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CodSettlementResultDTO {

    private boolean success;
    private String message;

    // Thông tin quyết toán
    private Long shipperId;
    private String shipperName;
    private BigDecimal settledAmount; // Tổng tiền đã quyết toán
    private Integer settledCount; // Số đơn đã quyết toán
    private LocalDateTime settledAt; // Thời gian quyết toán
    private String settledBy; // Người thực hiện quyết toán (Manager)
}
