package vn.web.logistic.dto.response.manager;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ShipperInfoDTO {
    private Long shipperId;
    private Long userId;

    // Thông tin cơ bản
    private String fullName;
    private String phone;
    private String email;
    private String avatarUrl;

    // Thông tin shipper
    private String shipperType; // fulltime, parttime
    private String vehicleType;
    private String status; // active, inactive, busy
    private LocalDateTime joinedAt;
    private BigDecimal rating;

    // Thống kê
    private Long totalTasksToday;
    private Long completedTasksToday;
    private BigDecimal totalCodToday;
    private Long pendingCodCount;
}
