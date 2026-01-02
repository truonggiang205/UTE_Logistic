package vn.web.logistic.dto.request.outbound;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO cho chức năng THÊM ĐƠN HÀNG VÀO BAO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AddOrderToContainerRequest {

    /**
     * ID của bao hàng (container)
     */
    @NotNull(message = "ID bao hàng không được để trống")
    private Long containerId;

    /**
     * ID của đơn hàng cần thêm vào bao
     */
    @NotNull(message = "ID đơn hàng không được để trống")
    private Long requestId;
}
