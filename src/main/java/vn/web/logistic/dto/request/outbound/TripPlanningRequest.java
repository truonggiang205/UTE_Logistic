package vn.web.logistic.dto.request.outbound;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO cho chức năng TẠO CHUYẾN XE (Trip Planning)
 * Lên kế hoạch chuyến vận chuyển từ Hub này đến Hub khác
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TripPlanningRequest {

    /**
     * ID phương tiện (xe tải)
     * Xe phải có status = 'available' và đang ở Hub hiện tại
     */
    @NotNull(message = "Phương tiện không được để trống")
    private Long vehicleId;

    /**
     * ID tài xế
     * Tài xế phải có status = 'active'
     */
    @NotNull(message = "Tài xế không được để trống")
    private Long driverId;

    /**
     * ID Hub xuất phát
     */
    @NotNull(message = "Hub xuất phát không được để trống")
    private Long fromHubId;

    /**
     * ID Hub đích
     */
    @NotNull(message = "Hub đích không được để trống")
    private Long toHubId;

    /**
     * Ghi chú cho chuyến xe
     */
    private String note;
}
