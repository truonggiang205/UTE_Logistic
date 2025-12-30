package vn.web.logistic.dto.response.manager;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

// DTO chứa số liệu thống kê Dashboard cho Manager (Trưởng bưu cục)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ManagerDashboardStatsResponse {

    // Tổng số đơn hàng thuộc Hub
    private Long totalOrders;

    // Số đơn đang chờ xử lý (pending)
    private Long pendingCount;

    // Số đơn đã lấy hàng (picked)
    private Long pickedCount;

    // Số đơn đang vận chuyển (in_transit)
    private Long inTransitCount;

    // Số đơn giao thành công (delivered)
    private Long deliveredCount;

    // Số đơn đã hủy (cancelled)
    private Long cancelledCount;

    // Số đơn giao thất bại (failed)
    private Long failedCount;

    // Tổng tiền COD đang giữ bởi Shipper (status = pending)
    private BigDecimal currentCodPendingAmount;

    // Tổng tiền COD đã thu (status = collected)
    private BigDecimal totalCodCollected;

    // Số lượng Shipper đang hoạt động
    private Long activeShipperCount;

    // Số lượng task đang thực hiện hôm nay
    private Long todayTaskCount;
}
