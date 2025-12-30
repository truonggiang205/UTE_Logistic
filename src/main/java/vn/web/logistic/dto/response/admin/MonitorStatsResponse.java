package vn.web.logistic.dto.response.admin;

import lombok.Builder;
import lombok.Data;

// DTO trả về thống kê nhanh
@Data
@Builder // Thêm Builder để dễ tạo object trong Service
public class MonitorStatsResponse {
    private long totalLogs; // Tổng số hành động trong khoảng time
    private long activeUsersCount; // Số lượng user hoạt động
    private String topAction; // Hành động phổ biến nhất
    private String mostActiveUser; // User hoạt động nhiều nhất
}