package vn.web.logistic.dto.response.manager;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

// DTO chứa thông tin một hành động trong lịch sử vận đơn (Timeline)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ActionHistoryResponse {

    // ID của hành động
    private Long actionId;

    // Mã loại hành động (VD: PICKUP, DELIVER, TRANSIT...)
    private String actionCode;

    // Tên loại hành động (VD: "Lấy hàng", "Giao hàng"...)
    private String actionName;

    // Tên Hub xuất phát
    private String fromHubName;

    // Tên Hub đích
    private String toHubName;

    // Tên nhân viên thực hiện
    private String actorName;

    // Số điện thoại nhân viên
    private String actorPhone;

    // Thời gian thực hiện hành động
    private LocalDateTime actionTime;

    // Ghi chú
    private String note;
}
