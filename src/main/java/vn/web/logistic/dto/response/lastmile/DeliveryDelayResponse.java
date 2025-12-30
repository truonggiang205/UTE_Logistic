package vn.web.logistic.dto.response.lastmile;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

// DTO Response cho chức năng 3: Xác nhận Hẹn Lại (Delivery Delay/Reschedule)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DeliveryDelayResponse {

    // ID Task đã fail
    private Long taskId;

    // ID đơn hàng
    private Long requestId;

    // Mã vận đơn
    private String trackingCode;

    // Trạng thái task sau cập nhật
    private String taskStatus;

    // Trạng thái đơn hàng (vẫn giữ picked)
    private String requestStatus;

    // Lý do không giao được
    private String reason;

    // ID ParcelAction được log
    private Long actionId;

    // Loại action đã log
    private String actionType;

    // Thời gian ghi nhận
    private LocalDateTime recordedAt;
}
