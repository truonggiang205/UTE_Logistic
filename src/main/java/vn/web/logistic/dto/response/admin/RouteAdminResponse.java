package vn.web.logistic.dto.response.admin;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class RouteAdminResponse {
    private Long routeId;
    private Long fromHubId;
    private String fromHubName;
    private Long toHubId;
    private String toHubName;
    private Integer estimatedTime;
    private String description;
}
