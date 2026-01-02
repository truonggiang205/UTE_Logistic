package vn.web.logistic.dto.request.lastmile;

import java.math.BigDecimal;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// Khách đến trực tiếp bưu cục lấy hàng (không qua Shipper)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CounterPickupRequest {

    // ID đơn hàng khách đến nhận
    @NotNull(message = "Request ID không được để trống")
    private Long requestId;

    // Số tiền COD thực thu (có thể bằng hoặc khác COD trên đơn)
    private BigDecimal codCollected;

    // Ghi chú khi giao
    private String note;
}
