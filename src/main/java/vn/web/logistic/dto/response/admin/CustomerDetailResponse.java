package vn.web.logistic.dto.response.admin;

import java.time.LocalDateTime;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CustomerDetailResponse {
    // User info
    private Long userId;
    private String username;
    private String userEmail;
    private String userPhone;
    private String userStatus;
    private LocalDateTime lastLoginAt;

    // Customer info
    private Long customerId;
    private String fullName;
    private String businessName;
    private String customerType; // individual, business
    private String email;
    private String phone;
    private String taxCode;
    private String status;
    private LocalDateTime createdAt;

    // Addresses
    private List<AddressInfo> addresses;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class AddressInfo {
        private Long addressId;
        private String contactName;
        private String contactPhone;
        private String addressDetail;
        private String ward;
        private String district;
        private String province;
        private String fullAddress; // Combined address
        private Boolean isDefault;
        private String note;
    }
}
