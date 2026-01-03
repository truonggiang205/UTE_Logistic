package vn.web.logistic.dto.response;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO cho trang Thông tin cá nhân của Shipper
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ShipperProfileDTO {
    // Thông tin user
    private Long userId;
    private String username;
    private String fullName;
    private String email;
    private String phone;
    private String avatarUrl;
    private String userStatus;
    private String lastLoginAt;
    private String createdAt;

    // Thông tin shipper
    private Long shipperId;
    private String shipperType;
    private String vehicleType;
    private String shipperStatus;
    private String joinedAt;
    private BigDecimal rating;
    private int totalRatings;

    // Thống kê
    private int totalOrders;
    private int completedOrders;
    private int failedOrders;
    private double successRate;
    private BigDecimal totalEarnings;

    // Hub info
    private String hubName;
    private String hubAddress;
}
