package vn.web.logistic.dto.request;

import java.math.BigDecimal;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO request cho việc quyết toán COD
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CodSettlementRequest {

    private Long shipperId; // ID của shipper cần quyết toán
    private BigDecimal amount; // Số tiền quyết toán (để verify)
    private List<Long> codTxIds; // Danh sách ID các transaction cần quyết toán (optional)
    private String note; // Ghi chú (optional)
    private String paymentMethod; // Phương thức thanh toán: cash, bank_transfer
}
