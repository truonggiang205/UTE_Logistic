package vn.web.logistic.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import vn.web.logistic.service.DashboardService;
import vn.web.logistic.dto.response.admin.ChartResponse;
import vn.web.logistic.dto.response.admin.DashboardKpiResponse;
import vn.web.logistic.repository.projection.TopPerformerProjection;

import java.util.List;

@RestController
@RequestMapping("/api/admin/dashboard")
@RequiredArgsConstructor
public class DashboardRestController {

    private final DashboardService dashboardService;

    @GetMapping("/kpi")
    public ResponseEntity<DashboardKpiResponse> getKpi() {
        return ResponseEntity.ok(dashboardService.getKpi());
    }

    @GetMapping("/revenue-chart")
    public ResponseEntity<ChartResponse> getRevenueChart() {
        return ResponseEntity.ok(dashboardService.getRevenueChartData());
    }

    @GetMapping("/top-hubs")
    public ResponseEntity<List<TopPerformerProjection>> getTopHubs() {
        return ResponseEntity.ok(dashboardService.getTopHubs());
    }

    @GetMapping("/top-shippers")
    public ResponseEntity<List<TopPerformerProjection>> getTopShippers() {
        return ResponseEntity.ok(dashboardService.getTopShippers());
    }
}