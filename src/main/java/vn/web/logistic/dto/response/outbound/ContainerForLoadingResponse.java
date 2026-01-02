package vn.web.logistic.dto.response.outbound;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO Response cho danh sách Bao chờ xếp lên xe
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ContainerForLoadingResponse {

    private Long containerId;
    private String containerCode;
    private String type;
    private String status;
    private BigDecimal weight;

    // Thông tin Hub tạo bao
    private String createdAtHubName;

    // Thông tin Hub đích
    private Long destinationHubId;
    private String destinationHubName;

    // Số lượng đơn hàng trong bao
    private int orderCount;
}
