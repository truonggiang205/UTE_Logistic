package vn.web.logistic.dto.request.lastmile;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// DTO Request cho chức năng 3: Xác nhận hẹn lại giao
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DeliveryDelayRequest {

    @NotNull(message = "Task ID không được để trống")
    private Long taskId;

    @NotBlank(message = "Lý do không được để trống")
    private String reason;
}
