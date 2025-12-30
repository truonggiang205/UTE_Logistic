package vn.web.logistic.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DriverResponse {
    private Long driverId;
    private String fullName;
    private String phoneNumber;
    private String licenseNumber;
    private String licenseClass;
    private String identityCard;
    private String status;
    private LocalDateTime createdAt;
}
