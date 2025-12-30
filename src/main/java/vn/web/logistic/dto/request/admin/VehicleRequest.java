package vn.web.logistic.dto.request.admin;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VehicleRequest {

    @NotBlank(message = "Biển số xe không được để trống")
    private String plateNumber;

    private String vehicleType;

    @NotNull(message = "Tải trọng không được để trống")
    private BigDecimal loadCapacity;

    private Long currentHubId;

    private String status; // available, in_transit, maintenance
}
