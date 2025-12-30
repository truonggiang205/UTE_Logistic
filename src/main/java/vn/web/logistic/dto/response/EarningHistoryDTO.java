package vn.web.logistic.dto.response;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO cho lịch sử thu nhập từng đơn của Shipper
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EarningHistoryDTO {
    private Long taskId;
    private String trackingNumber;
    private String customerName;
    private BigDecimal amount;
    private String completedAt;
    private String taskType;
    private String status;
}
