package vn.web.logistic.dto.response.inbound;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * DTO cho ServiceRequest - thông tin chi tiết
 * Dùng cho lookup và hiển thị chi tiết sau khi bàn giao
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class ServiceRequestDetailDTO {
    private Long requestId;
    private String status;
    private String note;
    private LocalDateTime createdAt;
    private String trackingCode;

    // Thông tin hàng hóa
    private String itemName;
    private BigDecimal weight;
    private BigDecimal codAmount;
    private BigDecimal shippingFee;
    private BigDecimal totalPrice;
    private BigDecimal receiverPayAmount;
    private String paymentStatus;

    // Pickup Address
    private ServiceRequestDTO.AddressDTO pickupAddress;

    // Delivery Address
    private ServiceRequestDTO.AddressDTO deliveryAddress;

    // Current Hub
    private ServiceRequestDTO.HubDTO currentHub;

    // Customer (người gửi)
    private CustomerDTO customer;

    // Service Type
    private ServiceTypeDTO serviceType;

    /**
     * DTO cho Customer
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CustomerDTO {
        private Long customerId;
        private String fullName;
        private String phone;
        private String businessName;
    }

    /**
     * DTO cho ServiceType
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ServiceTypeDTO {
        private Long serviceTypeId;
        private String serviceName;
    }
}
