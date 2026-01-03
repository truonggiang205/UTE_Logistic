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
public class OrderForAssignDTO {

    private Long requestId;
    private String taskType; // pickup hoặc delivery

    // Thông tin người gửi
    private String senderName;
    private String senderPhone;
    private String pickupAddress;
    private String pickupDistrict;

    // Thông tin người nhận
    private String receiverName;
    private String receiverPhone;
    private String deliveryAddress;
    private String deliveryDistrict;

    // Thông tin đơn hàng
    private String itemName;
    private BigDecimal codAmount;
    private BigDecimal shippingFee;
    private BigDecimal receiverPayAmount; // Tổng tiền người nhận phải trả
    private String status;
    private LocalDateTime createdAt;

    // Thông tin Hub hiện tại (nếu có)
    private Long currentHubId;
    private String currentHubName;
}
