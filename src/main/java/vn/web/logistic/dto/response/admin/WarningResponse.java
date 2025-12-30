package vn.web.logistic.dto.response.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WarningResponse {

    private List<StuckOrderDTO> stuckOrders;
    private List<HighDebtShipperDTO> debtShippers;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class StuckOrderDTO {
        private Long requestId;
        private String trackingCode;
        private String currentStatus;
        private LocalDateTime createdTime;
        private long daysStuck;
    }

    // HighDebtShipperDTO đã được tách ra thành class riêng: HighDebtShipperDTO.java
}