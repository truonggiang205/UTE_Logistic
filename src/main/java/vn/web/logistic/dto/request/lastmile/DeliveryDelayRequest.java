package vn.web.logistic.dto.request.lastmile;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// DTO Request cho chức năng 3: Xác nhận Hẹn Lại (Delivery Delay/Reschedule)
// Shipper không giao được (khách vắng nhà, gọi không nghe...) và hẹn ngày mai giao lại
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DeliveryDelayRequest {

    // ID của Task giao hàng thất bại hôm nay
    @NotNull(message = "Task ID không được để trống")
    private Long taskId;

    // Lý do không giao được
    @NotBlank(message = "Lý do không được để trống")
    private String reason;
}
