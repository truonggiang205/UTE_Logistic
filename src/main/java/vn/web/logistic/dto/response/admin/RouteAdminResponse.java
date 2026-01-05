package vn.web.logistic.dto.response.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RouteAdminResponse {
    private Long routeId;
    private Long fromHubId;
    private String fromHubName;
    private String fromHubProvince;
    private Long toHubId;
    private String toHubName;
    private String toHubProvince;
    private Integer estimatedTime;
    private String description;
}
