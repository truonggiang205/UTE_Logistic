package vn.web.logistic.dto.response.outbound;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO Response cho thông tin chi tiết Container
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ContainerDetailResponse {

    private Long containerId;
    private String containerCode;
    private String type;
    private String status;
    private BigDecimal weight;
    private LocalDateTime createdAt;

    // Thông tin Hub tạo bao
    private HubInfo createdAtHub;

    // Thông tin Hub đích
    private HubInfo destinationHub;

    // Người tạo bao
    private String createdByName;

    // Danh sách đơn hàng trong bao
    private List<OrderInContainerInfo> orders;

    // Số lượng đơn hàng trong bao
    private int orderCount;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class HubInfo {
        private Long hubId;
        private String hubName;
        private String address;
        private String province;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OrderInContainerInfo {
        private Long requestId;
        private String senderName;
        private String senderPhone;
        private String receiverName;
        private String receiverPhone;
        private String status;
        private BigDecimal weight;
        private BigDecimal totalPrice;
        private String itemName;
        private LocalDateTime addedAt;
    }
}
