package vn.web.logistic.dto.request.lastmile;

import java.math.BigDecimal;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// DTO Request cho chức năng 2: Xác nhận giao xong
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConfirmDeliveryRequest {

    @NotNull(message = "Task ID không được để trống")
    private Long taskId;

    // Số tiền COD thực thu (nếu null sẽ lấy theo receiverPayAmount trên đơn)
    private BigDecimal codCollected;

    // Ghi chú khi giao
    private String note;
}
