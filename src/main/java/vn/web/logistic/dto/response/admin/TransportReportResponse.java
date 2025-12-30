package vn.web.logistic.dto.response.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TransportReportResponse {

    private List<DailyStats> dailyStats;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DailyStats {
        private String date; // Format: yyyy-MM-dd
        private long tripCount; // Số chuyến xe trong ngày
        private BigDecimal totalWeight; // Tổng trọng lượng vận chuyển (kg)
        private long completedCount; // Số chuyến hoàn thành
        private long ongoingCount; // Số chuyến đang chạy
    }
}
