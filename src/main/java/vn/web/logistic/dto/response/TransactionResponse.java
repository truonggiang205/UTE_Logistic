package vn.web.logistic.dto.response;

import lombok.*;
import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TransactionResponse {
    private String transactionDate; // Lấy từ collected_at, settled_at hoặc paid_at
    private String transactionType; // "Thu hộ COD", "Đối soát trả tiền", "Thanh toán VNPAY"
    private String orderId;         // Mã đơn hàng liên quan
    private BigDecimal amount;      // Số tiền giao dịch
    private String flowType;        // "IN" (Tiền vào ví/giữ hộ) hoặc "OUT" (Tiền trả cho shop/phí)
    private String status;          // Trạng thái từ bảng gốc
}