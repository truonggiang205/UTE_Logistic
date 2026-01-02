package vn.web.logistic.dto.response.outbound;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * DTO Response cho danh sách Container (dạng summary)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ContainerListResponse {

    private Long containerId;
    private String containerCode;
    private String type;
    private String status;
    private BigDecimal weight;
    private LocalDateTime createdAt;

    // Thông tin Hub tạo bao
    private String createdAtHubName;

    // Thông tin Hub đích
    private String destinationHubName;

    // Số lượng đơn hàng trong bao
    private int orderCount;
}
