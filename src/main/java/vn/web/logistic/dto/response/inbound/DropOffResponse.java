package vn.web.logistic.dto.response.inbound;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Response cho chức năng Tạo đơn tại quầy (Drop-off)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DropOffResponse {

    /**
     * ID đơn hàng vừa tạo
     */
    private Long requestId;

    /**
     * Thông tin phí vận chuyển
     */
    private FeeDetails feeDetails;

    /**
     * Thông tin giao dịch COD
     */
    private CodTransactionInfo codTransaction;

    /**
     * Thời gian tạo đơn
     */
    private LocalDateTime createdAt;

    /**
     * Trạng thái đơn
     */
    private String status;

    /**
     * Trạng thái thanh toán
     */
    private String paymentStatus;

    /**
     * Thông tin người gửi
     */
    private AddressInfo senderInfo;

    /**
     * Thông tin người nhận
     */
    private AddressInfo receiverInfo;

    /**
     * Message thành công
     */
    private String message;

    /**
     * Chi tiết các loại phí
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class FeeDetails {
        /**
         * Trọng lượng thực
         */
        private BigDecimal actualWeight;

        /**
         * Trọng lượng quy đổi (theo kích thước)
         */
        private BigDecimal dimensionalWeight;

        /**
         * Trọng lượng tính cước (max của 2 loại trên)
         */
        private BigDecimal chargeableWeight;

        /**
         * Phí vận chuyển cơ bản
         */
        private BigDecimal shippingFee;

        /**
         * Phí COD (nếu có)
         */
        private BigDecimal codFee;

        /**
         * Phí bảo hiểm (nếu có)
         */
        private BigDecimal insuranceFee;

        /**
         * Tổng tiền khách phải trả
         */
        private BigDecimal totalPrice;
    }

    /**
     * Thông tin giao dịch thu tiền
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CodTransactionInfo {
        private Long transactionId;
        private BigDecimal amount;
        private String paymentMethod;
        private String status;
        private LocalDateTime collectedAt;
    }

    /**
     * Thông tin địa chỉ
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AddressInfo {
        private String contactName;
        private String contactPhone;
        private String fullAddress;
    }
}
