package vn.web.logistic.dto.response.outbound;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO Response cho danh sách Xe (Vehicle)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VehicleSelectResponse {

    private Long vehicleId;
    private String plateNumber;
    private String vehicleType;
    private BigDecimal loadCapacity;
    private String status;

    // Thông tin Hub hiện tại (có thể null nếu xe đang di chuyển)
    private Long currentHubId;
    private String currentHubName;
}
