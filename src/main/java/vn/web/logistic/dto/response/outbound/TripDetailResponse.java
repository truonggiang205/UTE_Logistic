package vn.web.logistic.dto.response.outbound;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO Response cho thông tin chi tiết Chuyến xe (Trip)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TripDetailResponse {

    private Long tripId;
    private String tripCode;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime departedAt;
    private LocalDateTime arrivedAt;

    // Thông tin xe
    private VehicleInfo vehicle;

    // Thông tin tài xế
    private DriverInfo driver;

    // Thông tin Hub xuất phát
    private HubInfo fromHub;

    // Thông tin Hub đích
    private HubInfo toHub;

    // Danh sách bao hàng đã xếp lên xe
    private List<ContainerOnTripInfo> containers;

    // Tổng tải trọng đã xếp
    private BigDecimal totalLoadedWeight;

    // Sức chứa xe
    private BigDecimal vehicleCapacity;

    // Tổng số bao
    private int containerCount;

    // Tổng số đơn hàng
    private int totalOrderCount;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class VehicleInfo {
        private Long vehicleId;
        private String plateNumber;
        private String vehicleType;
        private BigDecimal loadCapacity;
        private String status;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DriverInfo {
        private Long driverId;
        private String fullName;
        private String phoneNumber;
        private String licenseNumber;
        private String licenseClass;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class HubInfo {
        private Long hubId;
        private String hubName;
        private String address;
        private String province;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ContainerOnTripInfo {
        private Long containerId;
        private String containerCode;
        private String type;
        private String containerStatus;
        private String tripContainerStatus;
        private BigDecimal weight;
        private int orderCount;
        private LocalDateTime loadedAt;
    }
}
