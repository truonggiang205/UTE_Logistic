package vn.web.logistic.dto.request.admin;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ReportRequest {

    // Loại báo cáo muốn xuất (bắt buộc)
    private ReportType type;

    // Ngày bắt đầu lọc dữ liệu
    private LocalDateTime fromDate;

    // Ngày kết thúc lọc dữ liệu
    private LocalDateTime toDate;

    // (Optional) Nếu muốn lọc báo cáo riêng cho 1 Hub cụ thể
    private Long hubId;
}