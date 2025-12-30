package vn.web.logistic.dto.response.lastmile;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

// DTO Response cho chức năng 2: Xác nhận Giao Xong (Confirm Delivery)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConfirmDeliveryResponse {

    // ID Task đã hoàn thành
    private Long taskId;

    // ID đơn hàng
    private Long requestId;

    // Mã vận đơn
    private String trackingCode;

    // Trạng thái task sau cập nhật
    private String taskStatus;

    // Trạng thái đơn hàng sau cập nhật
    private String requestStatus;

    // Số tiền COD đã thu
    private BigDecimal codCollected;

    // ID giao dịch COD (nếu có)
    private Long codTxId;

    // Trạng thái giao dịch COD
    private String codStatus;

    // Thời gian hoàn thành
    private LocalDateTime completedAt;

    // Ghi chú
    private String note;
}
