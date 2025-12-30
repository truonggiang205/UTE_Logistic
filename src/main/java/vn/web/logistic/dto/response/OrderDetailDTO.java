package vn.web.logistic.dto.response;

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
public class OrderDetailDTO {

    // Thông tin đơn hàng
    private Long requestId;
    private String trackingNumber;
    private String itemName;
    private String status;
    private String statusText;
    private String statusBadge;

    // Task Info
    private Long taskId;
    private String taskType;
    private String taskTypeText;
    private String taskStatus;
    private String taskStatusText;
    private LocalDateTime assignedAt;
    private LocalDateTime completedAt;
    private String resultNote;

    // Thông tin người gửi (pickup)
    private String senderName;
    private String senderPhone;
    private String senderAddress;

    // Thông tin người nhận (delivery)
    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;

    // Kích thước & Trọng lượng
    private BigDecimal weight;
    private BigDecimal length;
    private BigDecimal width;
    private BigDecimal height;
    private BigDecimal chargeableWeight;

    // === Chi phí ===
    private BigDecimal codAmount;
    private BigDecimal shippingFee;
    private BigDecimal codFee;
    private BigDecimal insuranceFee;
    private BigDecimal totalPrice;
    private BigDecimal receiverPayAmount;
    private String paymentStatus;
    private String paymentStatusText;

    private String note;
    private String imageOrder;
    private LocalDateTime expectedPickupTime;
    private LocalDateTime createdAt;
    private String serviceTypeName;

    // === Customer Info ===
    private String customerName;
    private String customerPhone;
    private String customerEmail;
}
