package vn.web.logistic.dto.response.lastmile;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

// DTO Response cho chức năng 1: Phân công Shipper (Assign Task)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AssignTaskResponse {

    // ID của Shipper được phân công
    private Long shipperId;

    // Tên Shipper
    private String shipperName;

    // Số điện thoại Shipper
    private String shipperPhone;

    // Số đơn được phân công thành công
    private int assignedCount;

    // Danh sách các Task đã tạo
    private List<TaskInfo> tasks;

    // Thời gian phân công
    private LocalDateTime assignedAt;

    // Thông tin một Task
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TaskInfo {
        private Long taskId;
        private Long requestId;
        private String trackingCode;
        private String receiverName;
        private String receiverAddress;
        private String taskStatus;
    }
}
