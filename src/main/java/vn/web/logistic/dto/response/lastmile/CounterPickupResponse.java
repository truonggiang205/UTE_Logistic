package vn.web.logistic.dto.response.lastmile;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// DTO Response cho chức năng: Khách nhận tại quầy (Counter Pickup)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CounterPickupResponse {

    // ID đơn hàng
    private Long requestId;

    // Mã vận đơn
    private String trackingCode;

    // Trạng thái đơn hàng sau cập nhật
    private String requestStatus;

    // Số tiền COD đã thu tại quầy
    private BigDecimal codAmount;

    // ID giao dịch COD (nếu có)
    private Long codTxId;

    // Trạng thái COD (settled - đã quyết toán)
    private String codStatus;

    // ID ParcelAction được log
    private Long actionId;

    // Loại action đã log
    private String actionType;

    // Thời gian khách nhận
    private LocalDateTime receivedAt;

    // Ghi chú
    private String note;
}
