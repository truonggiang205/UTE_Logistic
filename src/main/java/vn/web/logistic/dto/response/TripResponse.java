package vn.web.logistic.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TripResponse {
    private Long tripId;
    private String tripCode;

    // Vehicle info
    private Long vehicleId;
    private String plateNumber;
    private String vehicleType;

    // Driver info
    private Long driverId;
    private String driverName;
    private String driverPhone;

    // Hub info
    private Long fromHubId;
    private String fromHubName;
    private Long toHubId;
    private String toHubName;

    private LocalDateTime departedAt;
    private LocalDateTime arrivedAt;
    private String status;
    private LocalDateTime createdAt;

    // List of containers on this trip (for detail view)
    private List<ContainerSimpleResponse> containers;
}
