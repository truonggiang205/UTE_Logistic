package vn.web.logistic.dto.response.admin;

import lombok.Builder;
import lombok.Data;
import vn.web.logistic.entity.VnpayTransaction;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
public class VnpayReconciliationResponse {
    private Long transactionId;
    private String vnpTxnRef; // Mã tham chiếu VNPAY
    private String orderCode; // Mã vận đơn (Tracking Code hoặc ID đơn)

    // Thông tin người dùng & Hub
    private String customerName;
    private String hubName;

    // Số liệu tài chính (Logic đối soát)
    private BigDecimal orderValue; // Giá trị đơn hàng gốc
    private BigDecimal paidAmount; // Số tiền thực nhận qua VNPAY
    private BigDecimal discrepancy; // Chênh lệch (Paid - Order)
    private String reconciliationStatus; // "Khớp", "Thiếu", "Dư"

    private String paymentStatus; // Success/Fail
    private LocalDateTime paidAt;

    // Helper tính toán đối soát
    public static VnpayReconciliationResponse fromEntity(VnpayTransaction tx) {
        BigDecimal orderVal = tx.getRequest().getTotalPrice();
        BigDecimal paidVal = tx.getAmount();
        BigDecimal diff = paidVal.subtract(orderVal);

        String statusRec = "MATCHED"; // Khớp
        if (diff.compareTo(BigDecimal.ZERO) > 0)
            statusRec = "OVER_PAID"; // Dư
        else if (diff.compareTo(BigDecimal.ZERO) < 0)
            statusRec = "UNDER_PAID"; // Thiếu

        // Lấy tên Hub an toàn (tránh null)
        String hub = (tx.getRequest().getCurrentHub() != null)
                ? tx.getRequest().getCurrentHub().getHubName()
                : "N/A";

        // Lấy tên User (Customer)
        String customer = (tx.getRequest().getCustomer() != null)
                ? tx.getRequest().getCustomer().getFullName()
                : "Unknown";

        return VnpayReconciliationResponse.builder()
                .transactionId(tx.getVnpayTxId())
                .vnpTxnRef(tx.getVnpTxnRef())
                .orderCode("REQ-" + tx.getRequest().getRequestId()) // Ví dụ mã đơn
                .customerName(customer)
                .hubName(hub)
                .orderValue(orderVal)
                .paidAmount(paidVal)
                .discrepancy(diff)
                .reconciliationStatus(statusRec)
                .paymentStatus(tx.getPaymentStatus().name())
                .paidAt(tx.getPaidAt())
                .build();
    }
}