package vn.web.logistic.dto.response;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO cho lịch sử nộp COD của shipper
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CodHistoryDTO {
    private Long transactionId;
    private String transactionCode;
    private BigDecimal amount;
    private int orderCount;
    private String submittedAt;
    private String receiverName;
    private String status;
}
