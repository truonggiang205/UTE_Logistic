package vn.web.logistic.dto.response.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ContainerSimpleResponse {
    private Long containerId;
    private String containerCode;
    private String type;
    private BigDecimal weight;
    private String status;
    private String destinationHubName;
}
