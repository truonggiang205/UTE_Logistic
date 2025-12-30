package vn.web.logistic.dto.response.manager;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

// DTO chứa thông tin chi tiết đơn hàng kèm lịch sử hành trình (Tracking)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderTrackingResponse {

    // === THÔNG TIN ĐƠN HÀNG ===

    // ID đơn hàng
    private Long requestId;

    // Trạng thái đơn hàng
    private String status;

    // Tên trạng thái hiển thị
    private String statusDisplay;

    // === THÔNG TIN NGƯỜI GỬI ===

    // Tên người gửi
    private String senderName;

    // SĐT người gửi
    private String senderPhone;

    // Địa chỉ lấy hàng
    private String pickupAddress;

    // === THÔNG TIN NGƯỜI NHẬN ===

    // Tên người nhận
    private String receiverName;

    // SĐT người nhận
    private String receiverPhone;

    // Địa chỉ giao hàng
    private String deliveryAddress;

    // === THÔNG TIN HÀNG HÓA ===

    // Tên hàng hóa
    private String itemName;

    // Trọng lượng (kg)
    private BigDecimal weight;

    // Kích thước (DxRxC)
    private String dimensions;

    // === THÔNG TIN PHÍ ===

    // Tiền thu hộ COD
    private BigDecimal codAmount;

    // Phí vận chuyển
    private BigDecimal shippingFee;

    // Tổng tiền
    private BigDecimal totalPrice;

    // Trạng thái thanh toán
    private String paymentStatus;

    // === THÔNG TIN VỊ TRÍ HIỆN TẠI ===

    // Tên Hub hiện tại
    private String currentHubName;

    // Địa chỉ Hub hiện tại
    private String currentHubAddress;

    // === THÔNG TIN THỜI GIAN ===

    // Ngày tạo đơn
    private LocalDateTime createdAt;

    // Thời gian dự kiến lấy hàng
    private LocalDateTime expectedPickupTime;

    // Loại dịch vụ
    private String serviceTypeName;

    // Ghi chú đơn hàng
    private String note;

    // === LỊCH SỬ HÀNH TRÌNH ===

    // Danh sách các hành động (Timeline)
    private List<ActionHistoryResponse> actionHistory;
}
