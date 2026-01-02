package vn.web.logistic.dto.request.outbound;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO cho chức năng GỠ BAO KHỎI CHUYẾN XE
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UnloadContainerRequest {

    /**
     * ID chuyến xe
     */
    @NotNull(message = "ID chuyến xe không được để trống")
    private Long tripId;

    /**
     * ID bao hàng cần gỡ khỏi xe
     */
    @NotNull(message = "ID bao hàng không được để trống")
    private Long containerId;
}
