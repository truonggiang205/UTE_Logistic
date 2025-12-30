package vn.web.logistic.dto.response.outbound;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO Response cho chức năng XUẤT BẾN (Gate Out)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GateOutResponse {

    /**
     * Thông tin chuyến xe
     */
    private TripInfo trip;

    /**
     * Số container đã xuất thành công
     */
    private int containerCount;

    /**
     * Tổng số đơn hàng trong các container
     */
    private int totalOrders;

    /**
     * Số đơn đã cập nhật trạng thái thành công
     */
    private int updatedOrdersCount;

    /**
     * Danh sách container đã xuất
     */
    private List<ContainerInfo> containers;

    /**
     * Thời gian xuất bến
     */
    private LocalDateTime departedAt;

    /**
     * Thông tin chuyến xe
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TripInfo {
        private Long tripId;
        private String tripCode;
        private String status;
        private String vehiclePlate;
        private String driverName;
        private String driverPhone;
        private String fromHubName;
        private String toHubName;
    }

    /**
     * Thông tin container
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ContainerInfo {
        private Long containerId;
        private String containerCode;
        private String type;
        private int orderCount;
    }
}
