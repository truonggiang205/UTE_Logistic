package vn.web.logistic.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VehicleResponse {
    private Long vehicleId;
    private String plateNumber;
    private String vehicleType;
    private BigDecimal loadCapacity;
    private Long currentHubId;
    private String currentHubName;
    private String status;
    private LocalDateTime createdAt;
}
