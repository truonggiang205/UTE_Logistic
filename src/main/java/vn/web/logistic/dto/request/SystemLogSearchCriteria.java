package vn.web.logistic.dto.request;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Builder
public class SystemLogSearchCriteria {
    // Tầng 1: Thời gian
    private LocalDateTime fromDate;
    private LocalDateTime toDate;

    // Tầng 2: User (Tìm theo username hoặc tên nhân viên)
    private String keywordUser; // Có thể là username hoặc full name

    // Tầng 3: Action & Object
    private String action; // VD: "CREATE", "UPDATE", "LOGIN"
    private String objectType; // VD: "ORDER", "SHIPPER" (để filter sâu hơn nếu cần)
}