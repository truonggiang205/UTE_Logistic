package vn.web.logistic.dto.response;

import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;

@Data
@Builder
public class DashboardKpiResponse {
    private long newOrders;
    private long completedOrders;
    private long incidentCount;
    private BigDecimal totalRevenue;
}