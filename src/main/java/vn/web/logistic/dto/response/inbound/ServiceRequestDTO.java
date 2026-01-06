package vn.web.logistic.dto.response.inbound;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO cho ServiceRequest - thông tin cơ bản
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ServiceRequestDTO {
    private Long requestId;
    private String status;
    private String note;
    private LocalDateTime createdAt;

    // Pickup Address
    private AddressDTO pickupAddress;

    // Delivery Address
    private AddressDTO deliveryAddress;

    // Current Hub
    private HubDTO currentHub;

    /**
     * DTO cho địa chỉ
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AddressDTO {
        private String contactName;
        private String contactPhone;
        private String addressDetail;
        private String ward;
        private String district;
        private String province;
    }

    /**
     * DTO cho Hub
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class HubDTO {
        private Long hubId;
        private String hubName;
    }
}
