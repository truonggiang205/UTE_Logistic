package vn.web.logistic.dto.response.inbound;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Response cho chức năng Quét Nhập (Scan In)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ScanInResponse {

    /**
     * Tổng số đơn được quét
     */
    private int totalScanned;

    /**
     * Số đơn nhập kho thành công
     */
    private int successCount;

    /**
     * Số đơn thất bại
     */
    private int failedCount;

    /**
     * Danh sách kết quả chi tiết từng đơn
     */
    private List<ScanResult> results;

    /**
     * Trạng thái chuyến xe (nếu nhập từ xe)
     */
    private TripStatusInfo tripStatus;

    /**
     * Thông tin kết quả quét từng đơn
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ScanResult {
        private Long requestId;
        private boolean success;
        private String message;
        private String previousStatus;
        private String newStatus;
    }

    /**
     * Thông tin trạng thái chuyến xe
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TripStatusInfo {
        private Long tripId;
        private String tripCode;
        private String previousStatus;
        private String newStatus;
        private int totalContainers;
        private int unloadedContainers;
        private boolean isCompleted;
    }
}
