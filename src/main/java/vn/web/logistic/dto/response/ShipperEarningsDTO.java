package vn.web.logistic.dto.response;

import java.math.BigDecimal;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO cho trang Thu nhập của Shipper
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ShipperEarningsDTO {
    // Tổng quan
    private BigDecimal todayEarnings;
    private BigDecimal weeklyEarnings;
    private BigDecimal monthlyEarnings;
    private BigDecimal totalEarnings;

    // Số đơn
    private int todayOrders;
    private int weeklyOrders;
    private int monthlyOrders;
    private int totalOrders;

    // Thống kê
    private BigDecimal averagePerOrder;
    private double successRate;
    private BigDecimal bonusAmount;

    // Dữ liệu biểu đồ (7 ngày gần nhất)
    private List<String> chartLabels;
    private List<BigDecimal> chartData;

    // Lịch sử giao dịch gần đây
    private List<EarningHistoryDTO> recentHistory;
}
