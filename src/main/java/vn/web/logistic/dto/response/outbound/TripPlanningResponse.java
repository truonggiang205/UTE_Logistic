package vn.web.logistic.dto.response.outbound;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO Response cho chức năng TẠO CHUYẾN XE (Trip Planning)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TripPlanningResponse {

    /**
     * ID chuyến xe
     */
    private Long tripId;

    /**
     * Mã chuyến xe (tự động generate)
     */
    private String tripCode;

    /**
     * Trạng thái chuyến xe
     */
    private String status;

    /**
     * Thông tin xe
     */
    private VehicleInfo vehicle;

    /**
     * Thông tin tài xế
     */
    private DriverInfo driver;

    /**
     * Thông tin Hub xuất phát
     */
    private HubInfo fromHub;

    /**
     * Thông tin Hub đích
     */
    private HubInfo toHub;

    /**
     * Thời gian tạo chuyến
     */
    private LocalDateTime createdAt;

    /**
     * Thông tin xe
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class VehicleInfo {
        private Long vehicleId;
        private String plateNumber;
        private String vehicleType;
        private String loadCapacity;
    }

    /**
     * Thông tin tài xế
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DriverInfo {
        private Long driverId;
        private String fullName;
        private String phoneNumber;
        private String licenseNumber;
    }

    /**
     * Thông tin Hub
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class HubInfo {
        private Long hubId;
        private String hubName;
        private String address;
    }
}
