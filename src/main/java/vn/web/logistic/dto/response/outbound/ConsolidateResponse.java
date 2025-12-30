package vn.web.logistic.dto.response.outbound;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO Response cho chức năng ĐÓNG BAO (Consolidate)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConsolidateResponse {

    /**
     * Thông tin container vừa tạo
     */
    private ContainerInfo container;

    /**
     * Số đơn hàng đã đóng thành công
     */
    private int successCount;

    /**
     * Số đơn hàng đóng thất bại
     */
    private int failedCount;

    /**
     * Tổng số đơn được yêu cầu
     */
    private int totalRequested;

    /**
     * Danh sách kết quả đóng bao từng đơn
     */
    private List<ConsolidateResult> results;

    /**
     * Thông tin container
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ContainerInfo {
        private Long containerId;
        private String containerCode;
        private String type;
        private String status;
        private BigDecimal totalWeight;
        private String fromHubName;
        private String toHubName;
        private LocalDateTime createdAt;
    }

    /**
     * Kết quả đóng bao từng đơn
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ConsolidateResult {
        private Long requestId;
        private boolean success;
        private String message;
        private String previousStatus;
    }
}
