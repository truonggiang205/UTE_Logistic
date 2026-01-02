package vn.web.logistic.dto.response.outbound;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * DTO Response cho đơn hàng chờ đóng bao (Pending Orders)
 * Bao gồm đầy đủ thông tin để quản lý biết đơn nào cần ưu tiên
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PendingOrderResponse {

    private Long requestId;
    private String trackingCode; // Mã vận đơn
    private String status;
    private String paymentStatus;

    // Thông tin người gửi
    private String senderName;
    private String senderPhone;
    private String senderAddress;
    private String senderProvince;
    private String senderDistrict;
    private String senderWard;

    // Thông tin người nhận
    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;
    private String receiverProvince;
    private String receiverDistrict;
    private String receiverWard;

    // Thông tin hàng hóa
    private String itemName;
    private BigDecimal weight;
    private BigDecimal length;
    private BigDecimal width;
    private BigDecimal height;
    private BigDecimal volumetricWeight; // Trọng lượng quy đổi

    // Thông tin dịch vụ
    private Long serviceTypeId;
    private String serviceTypeName; // Loại dịch vụ (Standard, Express, Same-day,...)
    private Boolean isFragile; // Hàng dễ vỡ
    private Boolean isUrgent; // Hàng gấp

    // Thông tin phí
    private BigDecimal codAmount; // Tiền thu hộ
    private BigDecimal shippingFee;
    private BigDecimal totalPrice;

    // Thông tin Hub hiện tại
    private Long currentHubId;
    private String currentHubName;

    // Thông tin Hub đích (để biết đơn này đi đâu)
    private Long destinationHubId;
    private String destinationHubName;

    // Thông tin thời gian
    private LocalDateTime createdAt;
    private LocalDateTime arrivedAtHubTime; // Thời điểm hàng đến Hub
    private Long hoursInWarehouse; // Số giờ tồn kho (để ưu tiên đơn lâu)
    private String priorityLevel; // Mức ưu tiên: HIGH, MEDIUM, LOW
}
