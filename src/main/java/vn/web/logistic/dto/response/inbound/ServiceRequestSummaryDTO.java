package vn.web.logistic.dto.response.inbound;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO tóm tắt cho ServiceRequest
 * Dùng cho danh sách đơn pending
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ServiceRequestSummaryDTO {
    private Long requestId;
    private String status;
    private LocalDateTime createdAt;
    private String trackingCode;
    private String itemName;
    private BigDecimal codAmount;

    // Sender info
    private String senderName;
    private String senderPhone;
    private String pickupProvince;

    // Receiver info
    private String receiverName;
    private String receiverPhone;
    private String deliveryProvince;
}
