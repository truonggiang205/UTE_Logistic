package vn.web.logistic.dto.request.inbound;

import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO cho chức năng Tạo đơn tại quầy (Drop-off)
 * Khách mang hàng ra bưu cục gửi trực tiếp
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DropOffRequest {

    /**
     * Thông tin người gửi
     */
    @Valid
    @NotNull(message = "Thông tin người gửi không được để trống")
    private AddressInfo senderInfo;

    /**
     * Thông tin người nhận
     */
    @Valid
    @NotNull(message = "Thông tin người nhận không được để trống")
    private AddressInfo receiverInfo;

    /**
     * Trọng lượng (kg)
     */
    @NotNull(message = "Trọng lượng không được để trống")
    @DecimalMin(value = "0.01", message = "Trọng lượng phải lớn hơn 0")
    private BigDecimal weight;

    /**
     * Chiều dài (cm)
     */
    private BigDecimal length;

    /**
     * Chiều rộng (cm)
     */
    private BigDecimal width;

    /**
     * Chiều cao (cm)
     */
    private BigDecimal height;

    /**
     * ID loại dịch vụ
     */
    @NotNull(message = "Loại dịch vụ không được để trống")
    private Long serviceTypeId;

    /**
     * ID kho hiện tại (bưu cục nhận hàng)
     */
    @NotNull(message = "Kho hiện tại không được để trống")
    private Long currentHubId;

    /**
     * Tiền thu hộ COD (0 nếu không có)
     */
    @Builder.Default
    private BigDecimal codAmount = BigDecimal.ZERO;

    /**
     * Tên hàng hóa
     */
    @NotBlank(message = "Tên hàng hóa không được để trống")
    private String itemName;

    /**
     * Ghi chú
     */
    private String note;

    /**
     * Phương thức thanh toán (cash, card, transfer)
     */
    @NotBlank(message = "Phương thức thanh toán không được để trống")
    @Builder.Default
    private String paymentMethod = "cash";

    /**
     * Inner class: Thông tin địa chỉ (dùng chung cho sender và receiver)
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AddressInfo {

        /**
         * Tên liên hệ
         */
        @NotBlank(message = "Tên liên hệ không được để trống")
        private String contactName;

        /**
         * Số điện thoại
         */
        @NotBlank(message = "Số điện thoại không được để trống")
        private String contactPhone;

        /**
         * Địa chỉ chi tiết
         */
        @NotBlank(message = "Địa chỉ chi tiết không được để trống")
        private String addressDetail;

        /**
         * Phường/Xã
         */
        private String ward;

        /**
         * Quận/Huyện
         */
        @NotBlank(message = "Quận/Huyện không được để trống")
        private String district;

        /**
         * Tỉnh/Thành phố
         */
        @NotBlank(message = "Tỉnh/Thành phố không được để trống")
        private String province;

        /**
         * Email (optional)
         */
        private String email;
    }
}
