package vn.web.logistic.dto.request.lastmile;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

// DTO Request cho chức năng 2: Xác nhận Giao Xong (Confirm Delivery)
// Shipper báo cáo đã giao hàng thành công và thu tiền (nếu có)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConfirmDeliveryRequest {

    // ID của Task cần xác nhận hoàn thành
    @NotNull(message = "Task ID không được để trống")
    private Long taskId;

    // Số tiền COD thực thu (có thể = 0 nếu đơn không COD)
    @PositiveOrZero(message = "Số tiền thu không được âm")
    private BigDecimal codCollected;

    // Ghi chú khi giao hàng (tùy chọn)
    private String note;
}
