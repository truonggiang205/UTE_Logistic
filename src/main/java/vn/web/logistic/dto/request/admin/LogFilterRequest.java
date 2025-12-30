package vn.web.logistic.dto.request.admin;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

// DTO nhận dữ liệu lọc từ UI
@Data
@Builder // Thêm Builder để dễ tạo object trong Service
public class LogFilterRequest {
    private LocalDateTime fromDate; // Lọc theo thời gian (Từ)
    private LocalDateTime toDate; // Lọc theo thời gian (Đến)
    private String username; // Lọc theo User (username hoặc fullName)
    private String action; // Lọc theo hành động (CREATE, UPDATE, LOGIN...)
    private String objectType; // Lọc theo đối tượng (PARCEL, USER, ROUTE...)
}
