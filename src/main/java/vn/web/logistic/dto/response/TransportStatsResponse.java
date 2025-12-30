package vn.web.logistic.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TransportStatsResponse {
    private Long totalVehicles;
    private Long activeVehicles; // in_transit
    private Long availableVehicles; // available
    private Long maintenanceVehicles; // maintenance
    private BigDecimal loadFactor; // % lấp đầy tải trọng

    // Additional stats
    private Long totalDrivers;
    private Long activeDrivers;
    private Long totalTripsToday;
    private Long ongoingTrips; // loading + on_way
}
