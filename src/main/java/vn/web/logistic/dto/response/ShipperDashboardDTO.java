package vn.web.logistic.dto.response;

import java.math.BigDecimal;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ShipperDashboardDTO {

    // === Statistics Cards (Tổng hợp) ===

    // Tổng số đơn cần xử lý hôm nay (pickup + delivery)
    private Long todayOrdersCount;

    // Số đơn đang xử lý (assigned + in_progress)
    private Long deliveringCount;

    // Số đơn đã hoàn thành hôm nay
    private Long completedCount;

    // Tổng tiền COD cần nộp
    private BigDecimal totalCodAmount;

    // === Statistics theo loại Task ===

    // Số đơn cần LẤY HÀNG hôm nay (pickup)
    private Long todayPickupCount;

    // Số đơn đang lấy hàng (pickup in progress)
    private Long pickupInProgressCount;

    // Số đơn đã lấy thành công hôm nay
    private Long pickupCompletedCount;

    // Số đơn cần GIAO hôm nay (delivery)
    private Long todayDeliveryCount;

    // Số đơn đang giao (delivery in progress)
    private Long deliveryInProgressCount;

    // Số đơn đã giao thành công hôm nay
    private Long deliveryCompletedCount;

    // === Shipper Info ===

    // Rating của shipper
    private BigDecimal shipperRating;

    // Tổng số đánh giá
    private Long totalRatings;

    // === Monthly Stats ===

    // Thu nhập tháng này
    private BigDecimal monthlyEarnings;

    // Số đơn đã giao trong tháng
    private Long monthlyOrders;

    // Tỷ lệ giao hàng thành công (%)
    private Integer successRate;

    // === Today's Orders ===

    // Danh sách đơn cần lấy hàng hôm nay
    private List<TodayOrderDTO> todayPickupOrders;

    // Danh sách đơn cần giao hôm nay
    private List<TodayOrderDTO> todayDeliveryOrders;

    // Danh sách tất cả đơn hàng hôm nay (giới hạn 5 đơn để hiển thị)
    private List<TodayOrderDTO> todayOrders;

    // DTO cho đơn hàng hôm nay
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class TodayOrderDTO {
        private Long id; // Request ID
        private Long taskId; // Task ID (để cập nhật trạng thái)
        private String trackingNumber;

        // Thông tin liên hệ (người gửi hoặc người nhận tùy taskType)
        private String contactName; // Tên người liên hệ
        private String contactPhone; // SĐT người liên hệ
        private String contactAddress; // Địa chỉ
        private String contactLabel; // "Người gửi" hoặc "Người nhận"

        private BigDecimal codAmount;
        private String status;
        private String statusText;
        private String statusBadge;
        private String taskType; // "pickup" hoặc "delivery"
        private String taskTypeText; // "Lấy hàng" hoặc "Giao hàng"
    }
}
