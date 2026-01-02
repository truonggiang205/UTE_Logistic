package vn.web.logistic.dto.request.outbound;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO cho chức năng XẾP BAO LÊN CHUYẾN XE
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoadContainerRequest {

    /**
     * ID chuyến xe
     */
    @NotNull(message = "ID chuyến xe không được để trống")
    private Long tripId;

    /**
     * ID bao hàng cần xếp lên xe
     */
    @NotNull(message = "ID bao hàng không được để trống")
    private Long containerId;
}
