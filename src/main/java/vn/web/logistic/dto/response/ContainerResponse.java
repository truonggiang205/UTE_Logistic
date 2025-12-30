package vn.web.logistic.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ContainerResponse {
    private Long containerId;
    private String containerCode;
    private String type;
    private BigDecimal weight;
    private Long createdAtHubId;
    private String createdAtHubName;
    private Long destinationHubId;
    private String destinationHubName;
    private Long createdById;
    private String createdByName;
    private String status;
    private LocalDateTime createdAt;
}
