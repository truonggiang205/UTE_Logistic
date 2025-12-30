package vn.web.logistic.dto.response.admin;

import lombok.Builder;
import lombok.Data;
import vn.web.logistic.entity.CodTransaction;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
public class CodTransactionResponse {
    private Long codTxId;
    private String orderCode; // Mã đơn hàng
    private String shipperName; // Tên Shipper
    private String hubName; // Tên Hub quản lý
    private BigDecimal amount; // Số tiền thu hộ
    private String status; // collected (đang giữ), settled (đã nộp), pending
    private LocalDateTime collectedAt; // Ngày thu tiền của khách
    private LocalDateTime settledAt; // Ngày nộp tiền về kho

    public static CodTransactionResponse fromEntity(CodTransaction tx) {
        String shipper = (tx.getShipper() != null && tx.getShipper().getUser() != null)
                ? tx.getShipper().getUser().getFullName()
                : "Unknown";

        String hub = (tx.getShipper() != null && tx.getShipper().getHub() != null)
                ? tx.getShipper().getHub().getHubName()
                : "N/A";

        return CodTransactionResponse.builder()
                .codTxId(tx.getCodTxId())
                .orderCode("REQ-" + tx.getRequest().getRequestId())
                .shipperName(shipper)
                .hubName(hub)
                .amount(tx.getAmount())
                .status(tx.getStatus().name())
                .collectedAt(tx.getCollectedAt())
                .settledAt(tx.getSettledAt())
                .build();
    }
}