package vn.web.logistic.dto.response.manager;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO response cho thông tin COD của Shipper (dùng cho Manager quyết toán)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ShipperCodSummaryDTO {

    // Thông tin shipper
    private Long shipperId;
    private String shipperName;
    private String shipperPhone;
    private String shipperEmail;

    // Thống kê COD
    private BigDecimal totalCollectedAmount; // Tổng tiền đã thu (chờ nộp)
    private Long totalCollectedCount; // Số đơn đã thu (chờ nộp)

    // Danh sách chi tiết các khoản COD
    private List<CodTransactionDTO> transactions;

    /**
     * DTO cho mỗi transaction COD
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CodTransactionDTO {
        private Long codTxId;
        private Long requestId;
        private String trackingCode; // VN + requestId
        private String customerName; // Tên người nhận
        private BigDecimal amount;
        private LocalDateTime collectedAt;
        private String paymentMethod;
    }
}
