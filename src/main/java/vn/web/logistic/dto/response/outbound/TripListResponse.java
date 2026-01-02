package vn.web.logistic.dto.response.outbound;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * DTO Response cho danh sách Chuyến xe (dạng summary)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TripListResponse {

    private Long tripId;
    private String tripCode;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime departedAt;

    // Thông tin xe
    private String vehiclePlate;
    private String vehicleType;

    // Thông tin tài xế
    private String driverName;
    private String driverPhone;

    // Thông tin Hub
    private Long fromHubId;
    private String fromHubName;
    private Long toHubId;
    private String toHubName;

    // Số bao đã xếp
    private int containerCount;

    // Tổng tải trọng
    private BigDecimal totalWeight;

    // Sức chứa xe
    private BigDecimal vehicleCapacity;
}
