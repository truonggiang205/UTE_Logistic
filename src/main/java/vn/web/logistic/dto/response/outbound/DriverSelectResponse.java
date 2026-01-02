package vn.web.logistic.dto.response.outbound;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO Response cho danh sách Tài xế (Driver)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DriverSelectResponse {

    private Long driverId;
    private String fullName;
    private String phoneNumber;
    private String licenseNumber;
    private String licenseClass;
    private String status;
}
