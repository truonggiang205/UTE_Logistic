package vn.web.logistic.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AssignTaskRequest {

    @NotNull(message = "Mã đơn hàng không được để trống")
    private Long requestId;

    @NotNull(message = "Mã shipper không được để trống")
    private Long shipperId;

    @NotNull(message = "Loại task không được để trống")
    private String taskType; // pickup hoặc delivery
}
